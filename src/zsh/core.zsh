#!/usr/bin/env zsh

#====================== SYSTEM ======================
# 设置默认编辑器
if command -v vim &>/dev/null; then
  export EDITOR=vim
  export VISDL=vim
fi

killport() {
  local signal="-9"
  local ports=("$@")

  # 如果最后一个参数以 - 开头，将其视为信号
  if [[ "${ports[-1]}" == -* ]]; then
    signal="${ports[-1]}"
    ports=(${ports[1,-2]})
  fi

  for port in "${ports[@]}"; do
    lsof -ti ":$port" | xargs kill "$signal"
  done
}
