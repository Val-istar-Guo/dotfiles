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

log_step() {
  echo
  echo "==> $*"
}

# 生成带时间戳日志的 cron 任务命令
# 参数: $1 - 要执行的命令
# 返回: 单行格式的包装脚本（用分号分隔，可直接用于 crontab）
make_cron_job() {
  local command="$1"
  local script
  script=$(cat <<EOF
echo ""
echo "========================================"
echo "[开始执行] \$(date "+%Y-%m-%d %H:%M:%S")"
echo "========================================"

${command}

echo "[执行完成] \$(date "+%Y-%m-%d %H:%M:%S")"
echo "========================================"
echo ""
EOF
  )
  # 压缩为单行，用分号分隔命令
  echo "${script}" | tr '\n' ';' | sed 's/;;*/;/g'
}
