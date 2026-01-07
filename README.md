# Dotfiles

## 安装

```bash
# 远程安装
curl -fsSL https://raw.githubusercontent.com/val-istar-guo/dotfiles/master/install.sh | bash

# 或手动安装
git clone https://github.com/val-istar-guo/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap.sh
source ~/.zshrc
```

## 使用

```bash
dotfiles upgrade     # 更新配置
dotfiles install     # 重新安装
dotfiles help        # 帮助
```

## 目录结构

```
dotfiles/
├── src/
│   ├── home/          # 符号链接到 $HOME
│   └── zsh/           # Zsh 配置
├── lib/               # 辅助脚本
├── bootstrap.sh       # 安装脚本
├── upgrade.sh         # 更新脚本
└── dotfiles           # CLI 工具
```

## 扩展配置

- `~/.config/git/config.local` - Git 扩展配置
- `~/.config/ssh/conf.d/*` - SSH 扩展配置
- `~/.config/zsh/conf.d/*` - Zsh 扩展配置
- `~/.config/zsh/completions/*` - Zsh 补全脚本

## 依赖

- [mise](https://github.com/jdx/mise)
- [powerlevel10k](https://github.com/romkatv/powerlevel10k)
