#!/usr/bin/env zsh

#======================================================================
# Dotfiles 更新检查
# 在 shell 启动时检查是否有可用更新
#======================================================================

if command -v dotfiles &>/dev/null; then
  dotfiles check-update --offline --silent
fi
