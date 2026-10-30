#!/bin/sh
# Trae FunctionWeb 运行时入口
# Next.js standalone server 前台启动，PORT 由运行时注入或默认 8080
set -eu

export PORT="${PORT:-8080}"
exec node server.js
