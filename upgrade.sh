#!/usr/bin/env bash
set -euo pipefail

#======================================================================
# Dotfiles 更新脚本
# 用途：更新已安装的 dotfiles 配置
#======================================================================

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 加载公共变量和辅助函数
source "$SCRIPT_DIR/lib/common.sh"
source "$SCRIPT_DIR/lib/utils.sh"

# 拉取最新代码
pull_latest() {
  log_step "拉取最新配置"

  cd "$DOTFILES_DIR"

  # 检查是否有未提交的更改
  if ! git diff-index --quiet HEAD -- 2>/dev/null; then
    log_info "检测到未提交的更改"
    git status --short
    echo
    read -p "是否继续更新? 本地更改可能会丢失 (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      log_warning "更新已取消"
      exit 1
    fi
  fi

  # 拉取最新代码
  if git pull; then
    log_success "代码更新完成"
  else
    log_warning "代码拉取失败"
    exit 1
  fi
}

# 运行 bootstrap
run_bootstrap() {
  log_step "运行配置更新脚本"
  "$BOOTSTRAP_SCRIPT_PATH"
}

# 主流程
main() {
  echo "========================================"
  echo "  Val.istar.Guo's Dotfiles - 更新程序"
  echo "========================================"

  pull_latest
  run_bootstrap

  echo
  log_success "🎉 更新完成！"
  log_info "如有配置文件更新，请运行: source ~/.zshrc"
}

main "$@"
