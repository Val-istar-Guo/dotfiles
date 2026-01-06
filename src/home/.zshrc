# ============================ Powerlevel10k ============================
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# disable p10k instant prompt
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
# ============================ Powerlevel10k ============================


[[ -r $HOME/.profile ]] && source $HOME/.profile
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export PATH=$HOME/bin:/usr/local/sbin:$PATH

# 关闭终端提示声
set bell-style none

# .oh-my-zsh安装位置
export ZSH=~/.oh-my-zsh

# ZSH 主题
# ZSH_THEME="pmcgee"
ZSH_THEME="powerlevel10k/powerlevel10k"

# ZSH更新周期
export UPDATE_ZSH_DAYS=30

# 禁用ZSH的命令自动修正
ENABLE_CORRECTION="false"
unsetopt correct_all
unsetopt correct


# 自动检测 DOTFILES 项目根目录
# 通过解析当前 .zshrc 文件的符号链接来获取真实路径
if [[ -L "$HOME/.zshrc" ]]; then
  # 如果 ~/.zshrc 是符号链接，解析其真实路径
  ZSHRC_REAL_PATH="$(readlink "$HOME/.zshrc")"
  # 从 src/home/.zshrc 向上两级得到项目根目录
  DOTFILES_ROOT="$(cd "$(dirname "$ZSHRC_REAL_PATH")/../.." && pwd)"
else
  # 如果不是符号链接，使用默认路径（可根据需要调整）
  DOTFILES_ROOT="${DOTFILES_ROOT:-$HOME/dotfiles}"
fi

DOTFILES_ZSH_CONFIG_HOME="$DOTFILES_ROOT/src/zsh"
ZSH_CONFIG_HOME="$HOME/.config/zsh/conf.d"
ZSH_COMPLETIONS_HOME="$HOME/.conf/zsh/completions"

fpath=($ZSH_COMPLETIONS_HOME $fpath)

# 加载 .dotfiles/zsh 配置文件
# 使用 (N) glob 限定符，当没有匹配文件时返回空列表，不会报错
for folder in "$DOTFILES_ZSH_CONFIG_HOME" "$ZSH_CONFIG_HOME"; do
  if [ -d "$folder" ]; then
    for file in "$folder"/*.init(N); do
      [ -r "$file" ] && [ -f "$file" ] && source "$file"
    done
  fi
done

# 启动oh-my-zsh
source $ZSH/oh-my-zsh.sh

# 使用 (N) glob 限定符，当没有匹配文件时返回空列表，不会报错
for folder in "$DOTFILES_ZSH_CONFIG_HOME" "$ZSH_CONFIG_HOME"; do
  if [ -d "$folder" ]; then
    # 加载所有非 .init 结尾的文件
    for file in "$folder"/*(N); do
      [[ "$file" == *.init ]] && continue
      [ -r "$file" ] && [ -f "$file" ] && source "$file"
    done
  fi
done
