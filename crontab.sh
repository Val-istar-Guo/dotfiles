#!/usr/bin/env bash
set -euo pipefail

#======================================================================
# Crontab 包装脚本
# 为 bootstrap.sh 添加时间戳日志，供 crontab 任务调用
# 同时执行 git fetch 以便离线检查更新
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

#======================================================================
# Git Fetch - 拉取远程分支更新
# 供 zsh/core 离线检查是否需要更新
#======================================================================
echo "[Git Fetch] $(date "+%Y-%m-%d %H:%M:%S")"
cd "${DOTFILES_DIR}"
if git fetch origin main --quiet 2>/dev/null; then
  echo "[Git Fetch] 成功拉取远程 main 分支"
else
  echo "[Git Fetch] 拉取失败（可能无网络连接）"
fi


echo "[执行完成] $(date "+%Y-%m-%d %H:%M:%S")"
echo "========================================"
echo ""
