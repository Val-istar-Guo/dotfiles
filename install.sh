#!/usr/bin/env bash
set -euo pipefail

#======================================================================
# Dotfiles 安装脚本
# 用途：首次安装 dotfiles 配置
# 支持两种运行方式：
#   1. 通过 curl 直接执行（会自动克隆仓库）
#   2. 在已克隆的仓库目录中执行（跳过克隆步骤）
#
#======================================================================

# 仓库配置
readonly DOTFILES_REPO="https://github.com/val-istar-guo/dotfiles.git"
readonly DEFAULT_INSTALL_DIR="${HOME}/dotfiles"

# 依赖配置
readonly REQUIRED_DEPENDENCIES=("git" "p10k")  # 必须的命令行工具
readonly OPTIONAL_DEPENDENCIES=("mise")        # 可选的命令行工具

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 日志函数（与 lib/utils.sh 保持一致）
log_info() {
  echo "[INFO] $*"
}

log_success() {
  echo "[✓] $*"
}

log_error() {
  echo "[✗] $*"
}

log_step() {
  echo
  echo "==> $*"
}

# 检查当前是否在 dotfiles 仓库中运行
_is_running_in_repo() {
  # 检查当前目录是否是 git 仓库
  if [[ ! -d "$SCRIPT_DIR/.git" ]]; then
    return 1
  fi

  # 检查是否包含必要的文件
  if [[ -f "$SCRIPT_DIR/bootstrap.sh" ]] && [[ -d "$SCRIPT_DIR/src" ]]; then
    return 0
  fi

  return 1
}

# 克隆仓库或使用当前仓库
# 返回：仓库目录路径（通过 echo）
setup_repo() {
  # 如果在仓库中运行，直接使用当前目录
  if _is_running_in_repo; then
    log_step "检测到在仓库中运行"
    log_info "使用当前目录: $SCRIPT_DIR"
    log_success "仓库已就绪"

    # 返回当前目录路径
    echo "$SCRIPT_DIR"
    return 0
  fi

  # 通过 curl 执行，需要克隆仓库到默认位置
  local target_dir="$DEFAULT_INSTALL_DIR"

  log_step "克隆 dotfiles 仓库"
  log_info "目标位置: $target_dir"

  if [[ -d "$target_dir" ]]; then
    log_error "目录已存在: $target_dir"
    log_info "如需更新配置，请使用以下命令："
    echo "  dotfiles upgrade"
    echo "或者："
    echo "  cd $target_dir && ./upgrade.sh"
    exit 1
  fi

  git clone "$DOTFILES_REPO" "$target_dir"
  log_success "仓库克隆完成"

  # 返回克隆的目录路径
  echo "$target_dir"
}

# 检查前置依赖
check_dependencies() {
  log_step "检查前置依赖"

  local missing_deps=()

  # 检查必须依赖
  for cmd in "${REQUIRED_DEPENDENCIES[@]}"; do
    if ! command -v "$cmd" &> /dev/null; then
      missing_deps+=("$cmd")
    fi
  done

  # 如果缺少必须依赖，退出
  if [[ ${#missing_deps[@]} -gt 0 ]]; then
    log_error "缺少以下必须依赖: ${missing_deps[*]}"
    log_info "请先安装缺失的依赖后再运行安装脚本"
    exit 1
  fi

  # 检查可选依赖
  for cmd in "${OPTIONAL_DEPENDENCIES[@]}"; do
    if ! command -v "$cmd" &> /dev/null; then
      log_warning "$cmd 未安装（可选依赖）"
    fi
  done

  log_success "所有必须依赖已满足"
}

# 运行 bootstrap
run_bootstrap() {
  local dotfiles_dir="$1"

  log_step "运行配置安装脚本"

  cd "$dotfiles_dir"
  ./bootstrap.sh
}

# 加载配置
reload_shell() {
  log_step "加载新配置"

  if [[ -f "${HOME}/.zshrc" ]]; then
    log_success "配置安装完成！"
    echo
    log_info "请运行以下命令以加载新配置："
    echo "  source ~/.zshrc"
    echo
    log_info "或重启终端会话"
  else
    log_error "未找到 ~/.zshrc 文件"
    exit 1
  fi
}

# 主流程
main() {
  echo "========================================"
  echo "  Val.istar.Guo's Dotfiles - 安装程序"
  echo "========================================"

  check_dependencies

  # 获取仓库目录路径
  local dotfiles_dir
  dotfiles_dir="$(setup_repo)"

  run_bootstrap "$dotfiles_dir"
  reload_shell

  log_success "🎉 安装完成！"
}

main "$@"
