#!/usr/bin/env bash
set -euo pipefail

#======================================================================
# Crontab 包装脚本
# 为 bootstrap.sh 添加时间戳日志，供 crontab 任务调用
#======================================================================

# 获取脚本目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 加载公共变量
source "$SCRIPT_DIR/lib/common.sh"

# 执行带时间戳的 bootstrap
echo ""
echo "========================================"
echo "[开始执行] $(date "+%Y-%m-%d %H:%M:%S")"
echo "========================================"

"${BOOTSTRAP_SCRIPT_PATH}"

echo "[执行完成] $(date "+%Y-%m-%d %H:%M:%S")"
echo "========================================"
echo ""
