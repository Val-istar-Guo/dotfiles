# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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

# ZSH命令行时间格式
# HIST_STAMPS="yyyy-mm-dd"

# 配置ZSH History文件位置
export HISTFILE=~/.config/zsh/history

# 加载的ZSH插件
# 示例: plugins=(rails git textmate ruby lighthouse)
plugins=(git docker kubectl direnv)

# 添加自定义 Zsh 补全脚本
fpath=(/home/$USER/.dotfiles/fpath $fpath)

# 加载.dotfiles/zsh下的配置文件
for FILE in $HOME/.dotfiles/zsh/*; do
  [ -r "${FILE}" ] && [ -f "${FILE}" ] && source ${FILE}
done
unset file

# 启动oh-my-zsh
source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# fnm
export PATH="/home/admin/.local/share/fnm:$PATH"
eval "$(fnm env --use-on-cd --version-file-strategy recursive)"

# disable p10k instant prompt
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
