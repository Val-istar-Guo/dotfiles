#!/usr/bin/env bash

#======================================================================
# Crontab Bootstrap 函数库
# 提供 bootstrap_crontab 函数用于注册定期更新任务
#======================================================================

#===== 配置 =====
readonly CRONTAB_DISPLAY_NAME="dotfile_crontab"
readonly CRONTAB_TAG="${CRONTAB_DISPLAY_NAME}"
readonly CRON_SCHEDULE="0 */4 * * *"  # 每4小时执行一次
readonly CRON_LOG_FILE="${LOG_DIR}/${CRONTAB_DISPLAY_NAME}.log"

#===== 辅助函数 =====

# 构建 crontab 任务行
build_cron_job_line() {
  local crontab_script="${DOTFILES_DIR}/crontab.sh"
  echo "${CRON_SCHEDULE} \"${crontab_script}\" >> \"${CRON_LOG_FILE}\" 2>&1 # ${CRONTAB_TAG}"
}

# 检查 crontab 任务状态
# 参数: $1 - 期望的 cron 任务行
# 返回值（通过 echo）:
#   - "not_installed"    : 未安装（标签不存在）
#   - "outdated"         : 已安装但命令不同（需要更新）
#   - "up_to_date"       : 已安装且命令一致（无需更新）
inspect_cron_job() {
  local expected_job="$1"
  local existing actual_job

  existing="$(crontab -l 2>/dev/null || true)"

  # 检查标签是否存在
  if ! grep -q -F "# ${CRONTAB_TAG}" <<< "${existing}"; then
    echo "not_installed"
    return
  fi

  # 对比实际命令与期望命令
  actual_job="$(grep -F "# ${CRONTAB_TAG}" <<< "${existing}" || true)"

  if [[ "${actual_job}" == "${expected_job}" ]]; then
    echo "up_to_date"
  else
    echo "outdated"
  fi
}

# 安装 crontab 任务
# 参数: $1 - 要安装的 cron 任务行
install_cron() {
  local job_line="$1"
  local existing filtered

  log_info "获取现有 crontab 配置"
  existing="$(crontab -l 2>/dev/null || true)"

  # 去除旧的同标记任务，确保幂等性
  log_info "清理旧的 ${CRONTAB_TAG} 任务"
  filtered="$(printf "%s\n" "${existing}" | grep -v -F "# ${CRONTAB_TAG}" || true)"

  # 安装到 crontab
  log_info "注册新的 cron 任务"
  printf "%s\n%s\n" "${filtered}" "${job_line}" | crontab -

  log_success "Crontab 任务已安装"
  log_info "计划: ${CRON_SCHEDULE}"
  log_info "脚本: ${DOTFILES_DIR}/crontab.sh"
  log_info "日志: ${CRON_LOG_FILE}"
}

#===== 主函数 =====

# Bootstrap crontab 任务
bootstrap_crontab() {
  log_step "检查 Crontab 任务"

  # 构建期望的 cron 任务（只调用一次）
  local expected_job_line
  expected_job_line="$(build_cron_job_line)"

  # 检查当前状态
  local cron_status
  cron_status="$(inspect_cron_job "${expected_job_line}")"

  case "${cron_status}" in
    up_to_date)
      log_success "Crontab 任务已是最新，无需更新"
      log_info "计划: ${CRON_SCHEDULE}"
      log_info "脚本: ${DOTFILES_DIR}/crontab.sh"
      log_info "日志: ${CRON_LOG_FILE}"
      ;;
    outdated)
      log_warning "发现已注册的任务，但命令不一致，将重新安装"
      install_cron "${expected_job_line}"
      ;;
    not_installed)
      install_cron "${expected_job_line}"
      ;;
    *)
      log_warning "未知的 cron 状态: ${cron_status}"
      return 1
      ;;
  esac
}
