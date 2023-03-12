[[ -r $HOME/.bashrc ]] && source $HOME/.bashrc
[[ -r $HOME/.profile ]] && source $HOME/.profile

export PATH=$HOME/bin:/usr/local/sbin:$PATH

# 关闭终端提示声
set bell-style none

# .oh-my-zsh安装位置
export ZSH=~/.oh-my-zsh

# ZSH 主题
ZSH_THEME="pmcgee"

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
plugins=(git docker)

# 加载.dotfiles/zsh下的配置文件
for FILE in $HOME/.dotfiles/zsh/*; do
  [ -r "${FILE}" ] && [ -f "${FILE}" ] && source ${FILE}
done
unset file

# 启动oh-my-zsh
source $ZSH/oh-my-zsh.sh
