#!/usr/bin/env bash
set -euo pipefail

#======================================================================
# Dotfiles 更新检查脚本
# 离线检查是否有可用更新（基于 crontab 的 git fetch 结果）
#
# 用法: check-update.sh [选项]
#   --offline  离线模式，不执行 git fetch
#   --silent   静默模式，无更新时不输出任何信息
#======================================================================

# 获取脚本目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 加载公共变量和工具函数
source "$SCRIPT_DIR/lib/common.sh"
source "$SCRIPT_DIR/lib/utils.sh"

# 默认参数
OFFLINE_MODE=false
SILENT_MODE=false

# 解析参数
while [[ $# -gt 0 ]]; do
  case "$1" in
    --offline)
      OFFLINE_MODE=true
      shift
      ;;
    --silent)
      SILENT_MODE=true
      shift
      ;;
    *)
      log_error "未知参数: $1"
      exit 1
      ;;
  esac
done

# 检查目录是否存在
if [[ ! -d "${DOTFILES_DIR}/.git" ]]; then
  log_error "${DOTFILES_DIR} 不是有效的 git 仓库"
  exit 1
fi

# 如果不是离线模式，先执行 git fetch
if [[ "$OFFLINE_MODE" == false ]]; then
  [[ "$SILENT_MODE" == false ]] && log_info "正在检查更新..."
  if ! git -C "${DOTFILES_DIR}" fetch origin main --quiet 2>/dev/null; then
    [[ "$SILENT_MODE" == false ]] && log_warning "git fetch 失败（可能无网络连接），使用缓存的远程信息"
  fi
fi

# 获取本地和远程的 commit hash
local_hash=$(git -C "${DOTFILES_DIR}" rev-parse HEAD 2>/dev/null) || {
  log_error "无法获取本地 HEAD"
  exit 1
}

remote_hash=$(git -C "${DOTFILES_DIR}" rev-parse origin/main 2>/dev/null) || {
  [[ "$SILENT_MODE" == false ]] && log_warning "无法获取远程分支信息，请确保已执行过 git fetch"
  exit 0
}

# 比较本地与远程分支
if [[ "${local_hash}" == "${remote_hash}" ]]; then
  [[ "$SILENT_MODE" == false ]] && log_success "Dotfiles 已是最新版本"
  exit 0
fi

# 检查本地是否落后于远程
if git -C "${DOTFILES_DIR}" merge-base --is-ancestor HEAD origin/main 2>/dev/null; then
  behind_count=$(git -C "${DOTFILES_DIR}" rev-list --count HEAD..origin/main 2>/dev/null) || behind_count="若干"
  echo ""
  echo "╔══════════════════════════════════════════════════════════════╗"
  echo "║  📦 Dotfiles 有新版本可用！                                  ║"
  echo "║  当前分支落后远程 ${behind_count} 个提交                              ║"
  echo "║  运行 'dotfiles upgrade' 更新                                ║"
  echo "╚══════════════════════════════════════════════════════════════╝"
  echo ""
  exit 0
fi

# 本地有未推送的提交
[[ "$SILENT_MODE" == false ]] && log_warning "本地分支与远程分支不同步（可能有未推送的提交）"
exit 0
