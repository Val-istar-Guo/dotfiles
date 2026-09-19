#!/usr/bin/env zsh

#======================================================================
# Rime 输入法配置管理（配置即代码）
# 命令：
#   rime-init      初始化配置（克隆 rime-ice + 全量重写配置 + 重新部署）
#   rime-upgrade   升级配置（git pull + 全量重写配置 + 重新部署）
#
# 说明：
#   - 本脚本是配置的唯一来源（config-as-code）。
#   - 每次 init/upgrade 都会用 rsync --delete 全量同步 rime-ice，
#     并重新生成 default.custom.yaml 与 squirrel.custom.yaml，
#     确保所有机器执行后配置完全一致（非增量、无残留）。
#   - 中英文切换：Shift 切换中英文，Caps Lock 保持大写锁定。
#======================================================================

# ---- 常量 ----
typeset -g RIME_DIR="${HOME}/Library/Rime"
typeset -g RIME_ICE_REPO="https://github.com/iDvel/rime-ice.git"
typeset -g RIME_ICE_DIR="${HOME}/.local/share/rime-ice"
typeset -g RIME_SQUIRREL_BIN="/Library/Input Methods/Squirrel.app/Contents/MacOS/Squirrel"

# ---- 内部函数 ----

# 全量同步 rime-ice：--delete 删除源里没有的陈旧文件，保证非增量、可复现
_rime_rsync() {
  rsync -a --delete \
    --exclude='.git' --exclude='.github' \
    --exclude='README.md' --exclude='LICENSE' --exclude='AGENTS.md' \
    "${RIME_ICE_DIR}/" "${RIME_DIR}/"
}

# 生成 default.custom.yaml（全拼精简 + 中英文切换键）
_rime_apply_default() {
  cat > "${RIME_DIR}/default.custom.yaml" <<'EOF'
# 由 dotfiles 生成（config-as-code），请勿手动修改
patch:
  schema_list:
    - schema: rime_ice

  # 中英文切换：Shift 切换中英文，Caps Lock 保持大写锁定
  ascii_composer:
    good_old_caps_lock: true
    switch_key:
      Caps_Lock: clear
      Shift_L: commit_code
      Shift_R: noop
      Control_L: noop
      Control_R: noop
EOF
}

# 生成 squirrel.custom.yaml（主题 blue-reverie + 按应用自动切换英文）
_rime_apply_squirrel() {
  cat > "${RIME_DIR}/squirrel.custom.yaml" <<'EOF'
# 由 dotfiles 生成（config-as-code），请勿手动修改
patch:
  style:
    color_scheme: blue_reverie
    color_scheme_dark: blue_reverie_dark
    status_message_type: mix
    candidate_format: '[label]. [candidate] [comment]'
    text_orientation: horizontal
    inline_preedit: true
    inline_candidate: false
    translucency: true
    blur: true
    mutual_exclusive: false
    memorize_size: true
    showPaging: false
    alpha: 1e+0
    candidate_list_layout: linear
    corner_radius: 1.2e+1
    hilited_corner_radius: 1e+1
    border_height: 0e+0
    border_width: 6e+0
    line_spacing: 5e+0
    spacing: 8e+0
    shadow_size: 6e+0
    font_face: PingFangSC-Regular
    font_point: 1.6e+1

  preset_color_schemes:
    blue_reverie:
      name: "Blue Reverie"
      author: HunterJi
      color_space: srgb
      back_color: '0xFFFFFF'
      hilited_back_color: '0x252320'
      hilited_candidate_back_color: '0xFF7A00'
      text_color: '0xD8000000'
      hilited_text_color: '0xDEDDDD'
      candidate_text_color: '0x5E5E5E'
      hilited_candidate_text_color: '0xFFFFFF'
      label_color: '0x888785'
      hilited_candidate_label_color: '0xFFFFFF'
      comment_text_color: '0xDEDDDD'

    blue_reverie_dark:
      name: "Blue Reverie Dark"
      author: HunterJi
      color_space: srgb
      back_color: '0x3F000000'
      hilited_back_color: '0x252320'
      hilited_candidate_back_color: '0xFF7A00'
      text_color: '0xD8000000'
      hilited_text_color: '0xDEDDDD'
      candidate_text_color: '0xFFFFFF'
      hilited_candidate_text_color: '0xFFFFFF'
      label_color: '0xEBEBEB'
      hilited_candidate_label_color: '0xFFFFFF'
      comment_text_color: '0xDEDDDD'

  app_options:
    # 以下应用默认进入英文(ASCII)模式（仅本机已安装的终端）
    # 增删方法：`osascript -e 'id of app "应用名"'` 查看 bundle id
    com.googlecode.iterm2:       # iTerm2
      ascii_mode: true
    com.apple.Terminal:          # macOS 终端
      ascii_mode: true
EOF
}

_rime_redeploy() {
  if [[ -x "${RIME_SQUIRREL_BIN}" ]]; then
    "${RIME_SQUIRREL_BIN}" --reload
  else
    echo "[!] 未找到 Squirrel，请手动在菜单栏点击「重新部署」"
  fi
}

# ---- 命令 ----
rime-init() {
  mkdir -p "${RIME_DIR}"

  if [[ ! -d "${RIME_ICE_DIR}/.git" ]]; then
    echo "[INFO] 克隆雾凇拼音: ${RIME_ICE_REPO}"
    git clone --depth 1 "${RIME_ICE_REPO}" "${RIME_ICE_DIR}"
  else
    echo "[INFO] 已存在 clone: ${RIME_ICE_DIR}"
  fi

  echo "[INFO] 全量同步 rime-ice -> ${RIME_DIR}"
  _rime_rsync

  echo "[INFO] 生成 default.custom.yaml"
  _rime_apply_default

  echo "[INFO] 生成 squirrel.custom.yaml（主题 + app_options）"
  _rime_apply_squirrel

  echo "[INFO] 重新部署"
  _rime_redeploy

  echo "[✓] Rime 配置初始化完成"
}

rime-upgrade() {
  if [[ ! -d "${RIME_ICE_DIR}/.git" ]]; then
    echo "[✗] 未找到 clone: ${RIME_ICE_DIR}"
    echo "[INFO] 请先运行 rime-init"
    return 1
  fi

  echo "[INFO] 更新雾凇拼音"
  git -C "${RIME_ICE_DIR}" pull

  echo "[INFO] 全量同步 rime-ice -> ${RIME_DIR}"
  _rime_rsync

  echo "[INFO] 生成 default.custom.yaml"
  _rime_apply_default

  echo "[INFO] 生成 squirrel.custom.yaml（主题 + app_options）"
  _rime_apply_squirrel

  echo "[INFO] 重新部署"
  _rime_redeploy

  echo "[✓] Rime 配置升级完成"
}
