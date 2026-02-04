'use client';

import { useState, useRef, useEffect } from 'react';
import Link from 'next/link';

interface Box {
  id: string;
  x: number;
  y: number;
  width: number;
  height: number;
  label: string;
  recognizeMode: 'ocr' | 'barcode';  // 识别模式：OCR 或 条码识别
}

interface Template {
  id: string;
  name: string;
  imageData: string;
  boxes: Box[];
  createdAt: number;
}

export default function TemplatePage() {
  const [image, setImage] = useState<string>('');
  const [boxes, setBoxes] = useState<Box[]>([]);
  const [isDrawing, setIsDrawing] = useState(false);
  const [startPos, setStartPos] = useState({ x: 0, y: 0 });
  const [currentBox, setCurrentBox] = useState<{ x: number; y: number; width: number; height: number } | null>(null);
  const [labelInput, setLabelInput] = useState('卡号');
  const [recognizeModeInput, setRecognizeModeInput] = useState<'ocr' | 'barcode'>('ocr');
  const [showLabelModal, setShowLabelModal] = useState(false);
  const [pendingBox, setPendingBox] = useState<{ x: number; y: number; width: number; height: number } | null>(null);
  const [templates, setTemplates] = useState<Template[]>([]);
  const [templateName, setTemplateName] = useState('');
  const [showSaveModal, setShowSaveModal] = useState(false);
  const [selectedTemplate, setSelectedTemplate] = useState<string | null>(null);
  
  const imageRef = useRef<HTMLImageElement>(null);
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    // 从localStorage加载模板
    const savedTemplates = localStorage.getItem('ocr-templates');
    if (savedTemplates) {
      setTemplates(JSON.parse(savedTemplates));
    }
  }, []);

  useEffect(() => {
    drawCanvas();
  }, [image, boxes, currentBox, isDrawing]);

  const drawCanvas = () => {
    if (!canvasRef.current || !imageRef.current) return;

    const canvas = canvasRef.current;
    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    // 设置canvas尺寸与图片一致
    canvas.width = imageRef.current.naturalWidth;
    canvas.height = imageRef.current.naturalHeight;

    // 清空画布
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    // 绘制所有框
    [...boxes, ...(currentBox ? [{ ...currentBox, id: 'temp', label: '' }] : [])].forEach((box) => {
      // 绘制边框
      ctx.strokeStyle = '#3B82F6';
      ctx.lineWidth = 3;
      ctx.strokeRect(box.x, box.y, box.width, box.height);

      // 绘制半透明填充
      ctx.fillStyle = 'rgba(59, 130, 246, 0.1)';
      ctx.fillRect(box.x, box.y, box.width, box.height);

      // 绘制标签
      if (box.label) {
        const fontSize = Math.max(14, Math.floor(box.height * 0.3));
        ctx.font = `bold ${fontSize}px sans-serif`;
        ctx.fillStyle = '#3B82F6';
        
        const text = box.label;
        const textWidth = ctx.measureText(text).width;
        const padding = 8;
        
        // 标签背景
        ctx.fillStyle = 'rgba(59, 130, 246, 0.9)';
        ctx.fillRect(box.x, box.y - fontSize - padding * 2, textWidth + padding * 2, fontSize + padding * 2);
        
        // 标签文字
        ctx.fillStyle = '#FFFFFF';
        ctx.fillText(text, box.x + padding, box.y - padding);
      }
    });
  };

  const handleImageUpload = (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    if (!file) return;

    const reader = new FileReader();
    reader.onloadend = () => {
      setImage(reader.result as string);
      setBoxes([]);
      setSelectedTemplate(null);
    };
    reader.readAsDataURL(file);
  };

  const getCoordinates = (e: React.MouseEvent<HTMLCanvasElement>) => {
    if (!imageRef.current || !canvasRef.current) return { x: 0, y: 0 };

    const rect = canvasRef.current.getBoundingClientRect();
    const scaleX = canvasRef.current.width / rect.width;
    const scaleY = canvasRef.current.height / rect.height;

    return {
      x: (e.clientX - rect.left) * scaleX,
      y: (e.clientY - rect.top) * scaleY,
    };
  };

  const handleMouseDown = (e: React.MouseEvent<HTMLCanvasElement>) => {
    if (!image) return;

    const coords = getCoordinates(e);
    setIsDrawing(true);
    setStartPos(coords);
    setCurrentBox({ x: coords.x, y: coords.y, width: 0, height: 0 });
  };

  const handleMouseMove = (e: React.MouseEvent<HTMLCanvasElement>) => {
    if (!isDrawing || !startPos) return;

    const coords = getCoordinates(e);
    const x = Math.min(startPos.x, coords.x);
    const y = Math.min(startPos.y, coords.y);
    const width = Math.abs(coords.x - startPos.x);
    const height = Math.abs(coords.y - startPos.y);

    setCurrentBox({ x, y, width, height });
  };

  const handleMouseUp = () => {
    if (!isDrawing || !currentBox || currentBox.width < 10 || currentBox.height < 10) {
      setIsDrawing(false);
      setCurrentBox(null);
      return;
    }

    // 保存待确认的框选数据
    setPendingBox(currentBox);
    setIsDrawing(false);
    setShowLabelModal(true);
  };

  const handleConfirmLabel = () => {
    if (!pendingBox) return;

    const newBox: Box = {
      id: Date.now().toString(),
      ...pendingBox,
      label: labelInput,
      recognizeMode: recognizeModeInput,
    };

    setBoxes([...boxes, newBox]);
    setCurrentBox(null);
    setPendingBox(null);
    setShowLabelModal(false);
  };

  const handleDeleteBox = (id: string) => {
    setBoxes(boxes.filter((box) => box.id !== id));
  };

  const handleSaveTemplate = () => {
    if (!templateName.trim()) {
      alert('请输入模板名称');
      return;
    }

    const newTemplate: Template = {
      id: Date.now().toString(),
      name: templateName,
      imageData: image,
      boxes,
      createdAt: Date.now(),
    };

    const updatedTemplates = [...templates, newTemplate];
    setTemplates(updatedTemplates);
    localStorage.setItem('ocr-templates', JSON.stringify(updatedTemplates));

    setShowSaveModal(false);
    setTemplateName('');
    alert('模板保存成功');
  };

  const handleLoadTemplate = (id: string) => {
    const template = templates.find((t) => t.id === id);
    if (!template) return;

    // 向后兼容：如果旧模板没有 recognizeMode 字段，默认设为 'ocr'
    const boxesWithMode = template.boxes.map(box => ({
      ...box,
      recognizeMode: box.recognizeMode || 'ocr'
    }));

    setImage(template.imageData);
    setBoxes(boxesWithMode);
    setSelectedTemplate(id);
  };

  const handleDeleteTemplate = (id: string) => {
    if (!confirm('确定要删除这个模板吗？')) return;

    const updatedTemplates = templates.filter((t) => t.id !== id);
    setTemplates(updatedTemplates);
    localStorage.setItem('ocr-templates', JSON.stringify(updatedTemplates));

    if (selectedTemplate === id) {
      setSelectedTemplate(null);
      setImage('');
      setBoxes([]);
    }
  };

  const handleUseTemplate = () => {
    if (boxes.length === 0) {
      alert('请先绘制识别区域');
      return;
    }

    // 确定模板名称
    let templateNameToUse: string;
    if (selectedTemplate) {
      // 如果是从已保存的模板加载的，使用已保存的名称
      const savedTemplate = templates.find(t => t.id === selectedTemplate);
      templateNameToUse = savedTemplate?.name || '自定义模板';
    } else {
      // 否则提示用户输入名称
      templateNameToUse = prompt('请输入模板名称：', '自定义模板') || '自定义模板';
      if (!templateNameToUse.trim()) {
        templateNameToUse = '自定义模板';
      }
    }

    // 保存当前模板到sessionStorage
    const templateData = {
      imageData: image,
      name: templateNameToUse,
      boxes: boxes.map(box => ({
        ...box,
        // 转换为相对坐标（0-1）
        relativeX: box.x / canvasRef.current!.width,
        relativeY: box.y / canvasRef.current!.height,
        relativeWidth: box.width / canvasRef.current!.width,
        relativeHeight: box.height / canvasRef.current!.height,
      })),
    };
    sessionStorage.setItem('current-template', JSON.stringify(templateData));

    alert('模板已设置，现在可以批量识别了！');
    // 跳转到首页
    window.location.href = '/';
  };

  return (
    <div className="min-h-screen bg-gray-50 p-6">
      <div className="max-w-7xl mx-auto">
        <div className="mb-6 flex justify-between items-center">
          <h1 className="text-3xl font-bold text-gray-900">OCR模板设置</h1>
          <Link
            href="/"
            className="px-4 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition-colors"
          >
            返回首页
          </Link>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          {/* 左侧：图片区域 */}
          <div className="lg:col-span-2 bg-white rounded-xl shadow-lg p-6">
            <div className="mb-4 flex items-center justify-between">
              <h2 className="text-xl font-semibold text-gray-800">图片区域</h2>
              <div className="flex gap-2">
                <button
                  onClick={() => fileInputRef.current?.click()}
                  className="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition-colors"
                >
                  上传图片
                </button>
                <input
                  ref={fileInputRef}
                  type="file"
                  accept="image/*"
                  onChange={handleImageUpload}
                  className="hidden"
                />
                {boxes.length >= 2 && (
                  <button
                    onClick={() => setShowSaveModal(true)}
                    className="px-4 py-2 bg-green-500 text-white rounded-lg hover:bg-green-600 transition-colors"
                  >
                    保存模板
                  </button>
                )}
                {image && boxes.length > 0 && (
                  <button
                    onClick={handleUseTemplate}
                    className="px-4 py-2 bg-purple-500 text-white rounded-lg hover:bg-purple-600 transition-colors"
                  >
                    使用此模板
                  </button>
                )}
              </div>
            </div>

            <div className="relative bg-gray-100 rounded-lg overflow-hidden min-h-[400px] flex items-center justify-center">
              {!image ? (
                <div className="text-center text-gray-400">
                  <svg className="w-16 h-16 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                  </svg>
                  <p className="text-lg">请上传一张卡片图片</p>
                  <p className="text-sm mt-2">然后在图片上框选需要识别的区域</p>
                </div>
              ) : (
                <div className="relative inline-block max-w-full">
                  <img
                    ref={imageRef}
                    src={image}
                    alt="模板图片"
                    className="max-w-full h-auto"
                    onLoad={drawCanvas}
                  />
                  <canvas
                    ref={canvasRef}
                    onMouseDown={handleMouseDown}
                    onMouseMove={handleMouseMove}
                    onMouseUp={handleMouseUp}
                    className="absolute inset-0 cursor-crosshair"
                    style={{ display: image ? 'block' : 'none' }}
                  />
                </div>
              )}
            </div>

            {image && (
              <p className="mt-4 text-sm text-gray-600">
                💡 在图片上拖拽鼠标绘制矩形框，每个框对应一个识别区域（如卡号、密码）
              </p>
            )}
          </div>

          {/* 右侧：已保存的模板和当前框 */}
          <div className="space-y-6">
            {/* 当前框列表 */}
            <div className="bg-white rounded-xl shadow-lg p-6">
              <h3 className="text-lg font-semibold text-gray-800 mb-4">当前识别区域</h3>
              {boxes.length === 0 ? (
                <p className="text-gray-400 text-center py-8">还没有框选区域</p>
              ) : (
                <div className="space-y-2">
                  {boxes.map((box) => (
                    <div key={box.id} className="flex items-center justify-between p-3 bg-blue-50 rounded-lg">
                      <div>
                        <div className="flex items-center gap-2">
                          <span className="font-medium text-blue-700">{box.label}</span>
                          <span className={`text-xs px-2 py-0.5 rounded ${
                            box.recognizeMode === 'barcode'
                              ? 'bg-purple-100 text-purple-700'
                              : 'bg-blue-100 text-blue-700'
                          }`}>
                            {box.recognizeMode === 'barcode' ? '条码' : 'OCR'}
                          </span>
                        </div>
                        <p className="text-xs text-gray-500 mt-1">
                          位置: ({Math.round(box.x)}, {Math.round(box.y)}) 尺寸: {Math.round(box.width)}×{Math.round(box.height)}
                        </p>
                      </div>
                      <button
                        onClick={() => handleDeleteBox(box.id)}
                        className="text-red-500 hover:text-red-700 transition-colors"
                      >
                        <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                        </svg>
                      </button>
                    </div>
                  ))}
                </div>
              )}
            </div>

            {/* 已保存的模板 */}
            <div className="bg-white rounded-xl shadow-lg p-6">
              <h3 className="text-lg font-semibold text-gray-800 mb-4">已保存的模板</h3>
              {templates.length === 0 ? (
                <p className="text-gray-400 text-center py-8">还没有保存模板</p>
              ) : (
                <div className="space-y-3">
                  {templates.map((template) => (
                    <div
                      key={template.id}
                      className={`p-3 rounded-lg cursor-pointer transition-colors ${
                        selectedTemplate === template.id ? 'bg-purple-50 border-2 border-purple-500' : 'bg-gray-50 hover:bg-gray-100'
                      }`}
                    >
                      <div className="flex items-center justify-between mb-2">
                        <h4 className="font-medium text-gray-800">{template.name}</h4>
                        <div className="flex gap-2">
                          <button
                            onClick={() => handleLoadTemplate(template.id)}
                            className="text-blue-500 hover:text-blue-700 text-sm"
                          >
                            加载
                          </button>
                          <button
                            onClick={() => handleDeleteTemplate(template.id)}
                            className="text-red-500 hover:text-red-700 text-sm"
                          >
                            删除
                          </button>
                        </div>
                      </div>
                      <div className="flex items-center gap-2">
                        <img src={template.imageData} alt={template.name} className="w-16 h-16 object-cover rounded" />
                        <span className="text-sm text-gray-500">{template.boxes.length} 个区域</span>
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>
          </div>
        </div>

        {/* 标签输入弹窗 */}
        {showLabelModal && (
          <div
            className="fixed inset-0 flex items-center justify-center z-[9999]"
            style={{ backgroundColor: 'rgba(0,0,0,0.5)' }}
            onClick={(e) => {
              // 点击遮罩层时关闭
              if (e.target === e.currentTarget) {
                setShowLabelModal(false);
                setCurrentBox(null);
                setPendingBox(null);
              }
            }}
          >
            <div 
              className="bg-white rounded-xl p-6 w-full max-w-md"
              onClick={(e) => e.stopPropagation()} // 阻止点击内容时关闭弹窗
            >
              <h3 className="text-lg font-semibold mb-4">设置识别区域名称</h3>
              <input
                type="text"
                value={labelInput}
                onChange={(e) => setLabelInput(e.target.value)}
                onKeyDown={(e) => {
                  // 支持回车确认
                  if (e.key === 'Enter') {
                    handleConfirmLabel();
                  } else if (e.key === 'Escape') {
                    setShowLabelModal(false);
                    setCurrentBox(null);
                    setPendingBox(null);
                  }
                }}
                className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                placeholder="例如：卡号、密码"
                autoFocus
              />
              <div className="mt-4">
                <p className="text-sm font-medium text-gray-700 mb-2">识别模式</p>
                <div className="grid grid-cols-2 gap-3">
                  <button
                    type="button"
                    onClick={() => setRecognizeModeInput('ocr')}
                    className={`px-4 py-3 rounded-lg border-2 transition-all ${
                      recognizeModeInput === 'ocr'
                        ? 'border-blue-500 bg-blue-50 text-blue-700'
                        : 'border-gray-200 bg-white text-gray-600 hover:border-gray-300'
                    }`}
                  >
                    <div className="flex items-center justify-center gap-2">
                      <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                      </svg>
                      <span>OCR识别</span>
                    </div>
                    <p className="text-xs text-gray-500 mt-1">识别文字数字</p>
                  </button>
                  <button
                    type="button"
                    onClick={() => setRecognizeModeInput('barcode')}
                    className={`px-4 py-3 rounded-lg border-2 transition-all ${
                      recognizeModeInput === 'barcode'
                        ? 'border-purple-500 bg-purple-50 text-purple-700'
                        : 'border-gray-200 bg-white text-gray-600 hover:border-gray-300'
                    }`}
                  >
                    <div className="flex items-center justify-center gap-2">
                      <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 4v1m6 11h2m-6 0h-2v4m0-11v3m0 0h.01M12 12h4.01M16 20h4M4 12h4m12 0h.01M5 8h2a1 1 0 001-1V5a1 1 0 00-1-1H5a1 1 0 00-1 1v2a1 1 0 001 1zm12 0h2a1 1 0 001-1V5a1 1 0 00-1-1h-2a1 1 0 00-1 1v2a1 1 0 001 1zM5 20h2a1 1 0 001-1v-2a1 1 0 00-1-1H5a1 1 0 00-1 1v2a1 1 0 001 1z" />
                      </svg>
                      <span>条码识别</span>
                    </div>
                    <p className="text-xs text-gray-500 mt-1">二维码/条码</p>
                  </button>
                </div>
              </div>
              <div className="mt-4 flex gap-2">
                <button
                  type="button"
                  onClick={handleConfirmLabel}
                  className="flex-1 px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 cursor-pointer"
                >
                  确认
                </button>
                <button
                  type="button"
                  onClick={() => {
                    setShowLabelModal(false);
                    setCurrentBox(null);
                    setPendingBox(null);
                  }}
                  className="flex-1 px-4 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 focus:ring-2 focus:ring-gray-500 focus:ring-offset-2 cursor-pointer"
                >
                  取消
                </button>
              </div>
            </div>
          </div>
        )}

        {/* 保存模板弹窗 */}
        {showSaveModal && (
          <div
            className="fixed inset-0 flex items-center justify-center z-[9999]"
            style={{ backgroundColor: 'rgba(0,0,0,0.5)' }}
            onClick={(e) => {
              // 点击遮罩层时关闭
              if (e.target === e.currentTarget) {
                setShowSaveModal(false);
              }
            }}
          >
            <div 
              className="bg-white rounded-xl p-6 w-full max-w-md"
              onClick={(e) => e.stopPropagation()} // 阻止点击内容时关闭弹窗
            >
              <h3 className="text-lg font-semibold mb-4">保存模板</h3>
              <input
                type="text"
                value={templateName}
                onChange={(e) => setTemplateName(e.target.value)}
                onKeyDown={(e) => {
                  // 支持回车确认
                  if (e.key === 'Enter') {
                    handleSaveTemplate();
                  } else if (e.key === 'Escape') {
                    setShowSaveModal(false);
                  }
                }}
                className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                placeholder="输入模板名称"
                autoFocus
              />
              <div className="mt-4 flex gap-2">
                <button
                  type="button"
                  onClick={handleSaveTemplate}
                  className="flex-1 px-4 py-2 bg-green-500 text-white rounded-lg hover:bg-green-600 focus:ring-2 focus:ring-green-500 focus:ring-offset-2 cursor-pointer"
                >
                  保存
                </button>
                <button
                  type="button"
                  onClick={() => setShowSaveModal(false)}
                  className="flex-1 px-4 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 focus:ring-2 focus:ring-gray-500 focus:ring-offset-2 cursor-pointer"
                >
                  取消
                </button>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
