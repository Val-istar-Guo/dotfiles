#!/usr/bin/env bash
set -e

#===== 初始化 =====
if [[ "$(uname)" == "Darwin" ]]; then
  OS="Mac"
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  OS="Linux"
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
  OS="MinGW"
fi

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BAKUP_DIR=$DIR/backup

FILES=(".curlrc" ".czrc" ".zshrc" ".p10k.zsh" ".gitconfig" ".gitignore" "bin" ".ssh/config" ".config/nvim" ".gnupg/gpg.conf" ".gnupg/gpg-agent.conf")
for FILE in ${DIR}/src/.dotfiles/zsh/*; do
  FILE_PATH=".dotfiles/zsh/$(basename ${FILE})"
  FILES=(${FILES[@]} ${FILE_PATH})
done
for FILE in ${DIR}/src/.dotfiles/fpath/*; do
  FILE_PATH=".dotfiles/fpath/$(basename ${FILE})"
  FILES=(${FILES[@]} ${FILE_PATH})
done

INDIVISUAL_FILES=(".vimrc" ".vim")
BACKUP_FILES=(${FILES[@]} ${INDIVISUAL_FILES[@]})

echo FILES: ${FILES[@]}
echo BACKUP_FILES: ${BACKUP_FILES[@]}

#===== 清理文件 =====
mkdir -p $BAKUP_DIR
for FILE in "${BACKUP_FILES[@]}"; do
  if [[ -L $HOME/$FILE ]]; then
    rm $HOME/$FILE
  elif [[ -r $HOME/$FILE ]]; then
    TARGET_DIR=$(dirname ${BAKUP_DIR}/${FILE})
    [[ ! -d $TARGET_DIR ]] && mkdir -p $TARGET_DIR
    mv $HOME/$FILE $BAKUP_DIR/$FILE.bak-$(date +"%F-%R")
  fi
done

#===== 安装文件 =====
for FILE in "${FILES[@]}"; do
  TARGET_DIR=$(dirname ${HOME}/${FILE})
  [[ ! -d $TARGET_DIR ]] && mkdir -p $TARGET_DIR
  ln -s $DIR/src/$FILE ${HOME}/${FILE}
done

ln -s $DIR/.config/nvim/init.vim $HOME/.vimrc
ln -s $DIR/.config/nvim $HOME/.vim
