'use client';

import Link from 'next/link';

export default function UnauthorizedPage() {
  return (
    <div className="min-h-screen bg-gray-50 flex items-center justify-center p-4">
      <div className="max-w-md w-full bg-white rounded-xl shadow-lg p-8 text-center">
        <div className="mx-auto w-20 h-20 bg-red-100 rounded-full flex items-center justify-center mb-6">
          <svg
            className="w-10 h-10 text-red-600"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              strokeLinecap="round"
              strokeLinejoin="round"
              strokeWidth={2}
              d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"
            />
          </svg>
        </div>

        <h1 className="text-2xl font-bold text-gray-900 mb-2">未授权访问</h1>
        <p className="text-gray-600 mb-6">
          您没有权限访问此页面。请联系管理员获取访问权限。
        </p>

        <div className="bg-gray-50 rounded-lg p-4 mb-6 text-left">
          <h2 className="text-sm font-semibold text-gray-700 mb-2">可能的原因：</h2>
          <ul className="text-sm text-gray-600 space-y-1">
            <li>• 未提供有效的认证令牌</li>
            <li>• IP地址不在白名单中</li>
            <li>• 令牌已过期或无效</li>
            <li>• 访问权限已被撤销</li>
          </ul>
        </div>

        <Link
          href="/"
          className="inline-block px-6 py-3 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition-colors"
        >
          返回首页
        </Link>
      </div>
    </div>
  );
}
