#!/usr/bin/env bash

#======================================================================
# 公共变量
# 定义全局共享的目录路径
#======================================================================

# 防止重复加载
if [[ -n "${DOTFILES_COMMON_LOADED:-}" ]]; then
  return 0
fi
readonly DOTFILES_COMMON_LOADED=1

# 核心目录
readonly DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly SRC_DIR="$DOTFILES_DIR/src"
readonly SRC_HOME_DIR="$SRC_DIR/home"
readonly LOG_DIR="$DOTFILES_DIR/logs"

# 核心脚本路径
readonly BOOTSTRAP_SCRIPT_PATH="$DOTFILES_DIR/bootstrap.sh"

# 确保必要的目录存在
mkdir -p "$LOG_DIR"
