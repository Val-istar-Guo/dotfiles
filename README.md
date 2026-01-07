# Val.istar.Guo's dotfiles

## 前置依赖

- [mise](https://github.com/jdx/mise) - 开发工具版本管理器
- [powerlevel10k](https://github.com/romkatv/powerlevel10k) - Zsh 主题

## 安装

### 首次安装

一键安装（推荐）：

```bash
curl -fsSL https://raw.githubusercontent.com/val-istar-guo/dotfiles/master/install.sh | bash
```

或手动安装：

```bash
git clone https://github.com/val-istar-guo/dotfiles.git && cd dotfiles && ./bootstrap.sh && source ~/.zshrc
```

安装完成后，`dotfiles` 命令会自动添加到 PATH 中。

### 更新配置

使用 CLI 工具（推荐）：

```bash
dotfiles upgrade
# 或简写（默认命令）
dotfiles
```

或手动更新：

```bash
cd ~/dotfiles && ./upgrade.sh
```

### CLI 工具

安装后可使用 `dotfiles` 命令管理配置：

```bash
dotfiles upgrade     # 更新配置（默认）
dotfiles install     # 重新安装配置
dotfiles backup      # 查看备份
dotfiles logs        # 查看日志
```

## 目录结构

```
dotfiles/
├── src/
│   ├── home/          # 符号链接到 $HOME 的文件
│   └── zsh/           # Zsh 相关配置
├── backup/            # 带时间戳的配置备份
├── lib/               # 辅助脚本和工具函数
│   ├── common.sh      # 公共变量定义
│   ├── utils.sh       # 日志输出函数
│   └── bootstrap_crontab.sh  # Crontab 注册函数库
├── logs/              # 日志文件
├── bootstrap.sh       # 主安装脚本
├── install.sh         # 首次安装脚本（独立脚本，支持 curl 直接执行）
├── upgrade.sh         # 更新脚本（git pull + bootstrap）
├── dotfiles           # CLI 工具（安装后可全局使用）
└── crontab.sh         # Crontab 定时任务包装脚本
```

## 个人扩展配置

不被 git 跟踪的个人配置路径：

| 路径                         | 说明             |
| :--------------------------- | :--------------- |
| ~/.config/git/config.local   | Git 本地配置     |
| ~/.config/ssh/conf.d/\*      | SSH 配置扩展     |
| ~/.config/zsh/conf.d/\*      | Zsh 配置扩展     |
| ~/.config/zsh/completions/\* | Zsh 自动补全脚本 |
