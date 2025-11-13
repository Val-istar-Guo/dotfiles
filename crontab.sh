#!/usr/bin/env bash
set -e


DISPLAY_NAME="dotfile_crontab"
TAG="${DISPLAY_NAME}"

CRON_SCHEDULE="0 */4 * * *"

SCRIPT_NAME="install.sh"
SCRIPT_PATH="${DIR}/${SCRIPT_NAME}"

CRON_LOG_FILE="${LOG_DIR}/${DISPLAY_NAME}.log"

is_cron_installed() {
  local existing
  existing="$(crontab -l 2>/dev/null || true)"
  grep -q -F "# ${TAG}" <<< "${existing}"
}

install_cron() {
  local existing filtered job_line
  existing="$(crontab -l 2>/dev/null || true)"
  # 去除旧的同标记任务，确保幂等
  filtered="$(printf "%s\n" "${existing}" | grep -v -F "# ${TAG}")"

  # 不修改 PATH；直接执行该脚本，并追加日志
  job_line="${CRON_SCHEDULE} \"${SCRIPT_PATH}\" >> \"${CRON_LOG_FILE}\" 2>&1 # ${TAG}"

  printf "%s\n%s\n" "${filtered}" "${job_line}" | crontab -

  echo "Installed cron job: ${job_line}"
}


# 若未安装则注册
if ! is_cron_installed; then
  install_cron
fi
