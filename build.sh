#!/bin/sh
# Trae FunctionWeb 构建脚本（Node.js 20）
# Next.js standalone 模式构建自包含产物，远程 build 执行此脚本
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cd "$SCRIPT_DIR"

export NPM_CONFIG_REGISTRY='https://registry.npmjs.org/'
export DOCKER_BUILD='1'

# 从官方 npm registry 安装依赖
npm ci --registry='https://registry.npmjs.org/' --ignore-scripts=false

# Next.js standalone 构建（自包含，含 node_modules）
npm run build

# 整理 dist/ 作为运行时产物目录
rm -rf dist
mkdir -p dist

# 复制 standalone 输出
cp -R .next/standalone/* dist/
cp -R .next/standalone/.next dist/.next 2>/dev/null || true

# 补充 static 静态资源和 public 目录
cp -R .next/static dist/.next/static
cp -R public dist/public

# 将 run.sh 放入 dist/ 作为运行时入口
cp run.sh dist/run.sh
chmod 755 dist/run.sh

echo "Build complete. Runtime artifact: dist/"
