#!/usr/bin/env bash
set -euo pipefail

#===== 初始化 =====
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR=$DIR/backup

LOG_DIR="${DIR}/logs"
mkdir -p "${LOG_DIR}"

FILES=(".curlrc" ".czrc" ".zshrc" ".p10k.zsh" ".gitconfig" ".gitignore" "bin" ".ssh/config" ".gnupg/gpg.conf" ".gnupg/gpg-agent.conf")
for FILE in ${DIR}/src/.dotfiles/zsh/*; do
  FILE_PATH=".dotfiles/zsh/$(basename ${FILE})"
  FILES=(${FILES[@]} ${FILE_PATH})
done

INDIVISUAL_FILES=(".vimrc" ".vim")
BACKUP_FILES=(${FILES[@]} ${INDIVISUAL_FILES[@]})

# echo FILES: ${FILES[@]}
# echo BACKUP_FILES: ${BACKUP_FILES[@]}

#===== 清理文件 =====
echo "Backup and remove existing files..."
mkdir -p $BACKUP_DIR
for FILE in "${BACKUP_FILES[@]}"; do
  if [[ -L $HOME/$FILE ]]; then
    rm $HOME/$FILE
  elif [[ -r $HOME/$FILE ]]; then
    TARGET_DIR=$(dirname ${BACKUP_DIR}/${FILE})
    [[ ! -d $TARGET_DIR ]] && mkdir -p $TARGET_DIR
    mv $HOME/$FILE $BACKUP_DIR/$FILE.bak-$(date +"%F-%R")
  fi
done

#===== 安装文件 =====
echo "Link dotfiles..."
for FILE in "${FILES[@]}"; do
  TARGET_DIR=$(dirname ${HOME}/${FILE})
  [[ ! -d $TARGET_DIR ]] && mkdir -p $TARGET_DIR
  ln -s $DIR/src/$FILE ${HOME}/${FILE}
done

#===== 注册 Crontab =====
echo "Register crontab..."
source "${DIR}/crontab.sh"

echo "Installation completed."
