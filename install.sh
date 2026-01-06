#!/usr/bin/env bash
set -euo pipefail

#======================================================================
# Dotfiles 安装脚本
#======================================================================

#===== 初始化 =====
# 获取脚本目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 加载公共变量和辅助函数
source "$SCRIPT_DIR/lib/common.sh"
source "$SCRIPT_DIR/lib/utils.sh"

# 安装脚本配置
readonly BACKUP_DIR="$DOTFILES_DIR/backup/$(date +"%Y-%m-%d_%H-%M-%S")"
readonly CLEANUP_SUBDIRS=(".config" ".ssh")

#===== 收集需要安装的文件 =====
log_step "扫描配置文件"

if [[ ! -d "$SRC_HOME_DIR" ]]; then
  log_warning "源目录不存在: $SRC_HOME_DIR"
  exit 1
fi

# 遍历 src/home 目录，收集所有文件和符号链接
RESOURCES=()
while IFS= read -r -d '' file; do
  relative_path="${file#$SRC_HOME_DIR/}"
  RESOURCES+=("$relative_path")
done < <(find "$SRC_HOME_DIR" -mindepth 1 \( -type f -o -type l \) -print0 | sort -z)

if [[ ${#RESOURCES[@]} -eq 0 ]]; then
  log_warning "未找到任何配置文件"
  exit 1
fi

log_info "准备安装 ${#RESOURCES[@]} 个配置文件"
for resource in "${RESOURCES[@]}"; do
  echo "  • $resource"
done

#===== 卸载旧配置 =====
log_step "卸载旧配置"

removed_count=0

# 卸载 HOME 目录直接下的符号链接（不递归）
while IFS= read -r -d '' link; do
  link_target="$(readlink "$link")"
  if [[ "$link_target" == "$DOTFILES_DIR"* ]]; then
    rm "$link"
    relative_link="${link#$HOME/}"
    log_info "移除: $relative_link"
    removed_count=$((removed_count + 1))
  fi
done < <(find "$HOME" -maxdepth 1 -type l -print0 2>/dev/null; exit 0)

# 卸载特定子目录（限制深度为3层）
for subdir in "${CLEANUP_SUBDIRS[@]}"; do
  dir_path="$HOME/$subdir"
  if [[ ! -d "$dir_path" ]]; then
    continue
  fi

  while IFS= read -r -d '' link; do
    link_target="$(readlink "$link")"
    if [[ "$link_target" == "$DOTFILES_DIR"* ]]; then
      rm "$link"
      relative_link="${link#$HOME/}"
      log_info "移除: $relative_link"
      removed_count=$((removed_count + 1))
    fi
  done < <(find "$dir_path" -maxdepth 3 -type l -print0 2>/dev/null; exit 0)
done

if [[ $removed_count -gt 0 ]]; then
  log_success "卸载完成，移除 $removed_count 个旧配置"
else
  log_info "无需卸载"
fi

#===== 备份现有配置 =====
log_step "备份现有配置"

backup_count=0
for resource in "${RESOURCES[@]}"; do
  # 跳过 .gitkeep 文件的备份
  if [[ "$(basename "$resource")" == ".gitkeep" ]]; then
    continue
  fi

  target_path="$HOME/$resource"

  # 如果文件存在且是真实文件（不是符号链接），则备份
  if [[ -e "$target_path" && ! -L "$target_path" ]]; then
    backup_path="$BACKUP_DIR/$resource"
    backup_dir="$(dirname "$backup_path")"
    mkdir -p "$backup_dir"
    mv "$target_path" "$backup_path"
    log_success "已备份: $resource"
    backup_count=$((backup_count + 1))
  fi
done

if [[ $backup_count -gt 0 ]]; then
  log_success "备份完成，共 $backup_count 个文件 → $BACKUP_DIR"
else
  log_info "无需备份任何文件"
fi

#===== 创建符号链接 =====
log_step "安装配置文件"

install_count=0
for resource in "${RESOURCES[@]}"; do
  source_path="$SRC_HOME_DIR/$resource"
  target_path="$HOME/$resource"
  target_dir="$(dirname "$target_path")"

  # 对 .gitkeep 文件特殊处理：只创建目录
  if [[ "$(basename "$resource")" == ".gitkeep" ]]; then
    mkdir -p "$target_dir"
    continue
  fi

  # 确保目标目录存在
  mkdir -p "$target_dir"

  # 创建符号链接
  ln -s "$source_path" "$target_path"
  log_success "已安装: $resource"
  install_count=$((install_count + 1))
done

log_success "安装完成，共 $install_count 个文件"

#===== 注册 Crontab =====
log_step "注册 Crontab 任务"

if [[ -f "$CRONTAB_SCRIPT_PATH" ]]; then
  source "$CRONTAB_SCRIPT_PATH"
  log_success "Crontab 任务已注册"
else
  log_warning "未找到 crontab.sh，跳过任务注册"
fi

#===== 完成 =====
echo
log_success "🎉 所有配置已安装完成！"
echo
