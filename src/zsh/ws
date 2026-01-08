# https://github.com/Val-istar-Guo/workspace

if command -v ws &> /dev/null; then
  ws() {
    if [[ $# -eq 0 ]]; then
      # 不带参数时，调用 ws 命令获取项目目录并跳转
      local target_dir=$(command ws)
      if [[ -n "$target_dir" && -d "$target_dir" ]]; then
        cd "$target_dir" || return 1
      fi
    else
      # 带参数时，直接调用原始 ws 命令
      command ws "$@"
    fi
  }
fi
