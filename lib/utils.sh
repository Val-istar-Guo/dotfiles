#!/usr/bin/env bash

#======================================================================
# 辅助函数库
# 提供日志输出等通用功能
#======================================================================

# 防止重复加载
if [[ -n "${DOTFILES_UTILS_LOADED:-}" ]]; then
  return 0
fi
readonly DOTFILES_UTILS_LOADED=1

log_info() {
  echo "[INFO] $*"
}

log_success() {
  echo "[✓] $*"
}

log_warning() {
  echo "[!] $*"
}

log_error() {
  echo "[✗] $*"
}

log_step() {
  echo
  echo "==> $*"
}
