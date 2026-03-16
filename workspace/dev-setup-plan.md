# Mac Mini 开发环境搭建计划

> **定位**：本机所有开发均通过 AI 编程助手（Claude Code、Cursor、Trae 等）完成。
> 环境搭建的核心目标是让 AI 助手能**快速理解项目上下文、独立执行命令、自主完成开发任务**。

## 当前环境

| 项目 | 状态 |
|------|------|
| 机型 | Mac Mini (Apple Silicon arm64) |
| 系统 | macOS 26.3 |
| 内存/磁盘 | 16 GB / 228 GB (可用 183 GB) |
| 已有 | Xcode CLT, Git 2.50.1, Python 3.9.6 (系统), Trae IDE |
| 待装 | Homebrew, mise, Node.js, 现代 Python, AI 工具链, CLI 工具集 |

---

## 一、目录结构

```
~/Opensource/
├── projects/            # 自己的项目
│   ├── web/             # Web 前后端
│   ├── mobile/          # 移动端
│   ├── cli/             # 命令行工具
│   ├── ai/              # AI/ML 项目
│   └── playground/      # 临时实验（可随时清理）
├── forks/               # Fork 的开源项目（用于向上游贡献）
├── vendor/              # 克隆的第三方项目（学习/参考）
├── scripts/             # 个人自动化脚本（已加入 $PATH）
├── configs/             # dotfiles 和跨机器同步的配置
├── dev-setup-plan.md    # 本文档（环境搭建计划）
└── ai-dev-guide.md      # AI 辅助开发使用指南
```

### 每个项目的标准结构

每个项目在创建时应包含以下 AI 上下文文件，让 AI 助手进入项目目录后能立即理解项目：

```
my-project/
├── CLAUDE.md             # Claude Code 项目指令（最重要）
├── .cursorrules          # Cursor 项目规则（如使用 Cursor）
├── .github/copilot-instructions.md  # Copilot 指令（如使用 Copilot）
├── README.md             # 项目说明
├── .mise.toml            # 锁定本项目的语言运行时版本
├── .gitignore
└── ...
```

### CLAUDE.md 模板

每个项目的 `CLAUDE.md` 应至少包含：

```markdown
# 项目名称

## 概述
一句话描述这个项目做什么。

## 技术栈
- 语言: xxx
- 框架: xxx
- 包管理器: xxx

## 项目结构
简要说明关键目录和文件。

## 开发命令
- 安装依赖: `xxx`
- 启动开发: `xxx`
- 运行测试: `xxx`
- 构建: `xxx`

## 约定
- 代码风格、命名规范等
- 提交信息格式
- 分支策略
```

> **原则**：AI 助手读完 `CLAUDE.md` 后就应该能独立进行开发，无需额外询问基本信息。

---

## 二、工具链安装

### 步骤 1：Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

安装后将以下内容加入 `~/.zprofile`：

```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
```

### 步骤 2：mise（统一版本管理）

一个工具管理所有语言版本，替代 nvm/pyenv/goenv。每个项目通过 `.mise.toml` 锁定版本，AI 助手切换项目时自动适配。

```bash
brew install mise
echo 'eval "$(mise activate zsh)"' >> ~/.zshrc
source ~/.zshrc
```

### 步骤 3：语言运行时

```bash
mise use --global node@lts        # Node.js LTS
mise use --global python@3.12     # 现代 Python
mise use --global go@latest       # Go

# 按需：
# mise use --global java@21
# mise use --global ruby@latest
```

Rust 推荐用官方 rustup（按需安装）：

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

### 步骤 4：AI 编程工具

```bash
# Claude Code CLI — 终端中的 AI 编程助手（本工具）
npm install -g @anthropic-ai/claude-code

# 其他 AI IDE（按需，已有 Trae）
# brew install --cask cursor
# brew install --cask visual-studio-code
```

### 步骤 5：包管理器

```bash
npm install -g pnpm              # Node.js 推荐包管理器
brew install uv                   # Python 推荐包管理器（极快）
```

### 步骤 6：CLI 工具集

```bash
brew install \
  git gh \
  fzf ripgrep fd bat eza jq tree \
  lazygit starship zoxide tmux
```

| 工具 | 用途 | AI 助手相关性 |
|------|------|-------------|
| git, gh | 版本控制、GitHub 操作 | AI 助手直接调用进行提交、PR 管理 |
| ripgrep, fd | 快速搜索 | AI 助手用于代码搜索和文件查找 |
| jq | JSON 处理 | AI 助手处理 API 响应、配置文件 |
| fzf, bat, eza, tree | 终端增强 | 提升人工浏览效率 |
| lazygit | Git TUI | 人工快速审查 AI 的提交 |
| starship, zoxide | Shell 美化/导航 | 提升人工操作体验 |
| tmux | 终端复用 | 同时运行 AI 助手和开发服务器 |

### 步骤 7：容器（OrbStack）

```bash
brew install orbstack
```

比 Docker Desktop 在 Apple Silicon 上更轻量，安装后 `docker` 和 `docker-compose` 直接可用。

### 步骤 8：Git 配置

```bash
git config --global user.name "你的名字"
git config --global user.email "你的邮箱"
git config --global init.defaultBranch main
git config --global pull.rebase true
git config --global core.autocrlf input

# SSH key
ssh-keygen -t ed25519 -C "你的邮箱"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# GitHub CLI 登录
gh auth login
```

### 步骤 9：Shell 配置

`~/.zshrc` 最终内容：

```bash
# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# mise (版本管理)
eval "$(mise activate zsh)"

# Shell 增强
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
source <(fzf --zsh)

# 个人脚本
export PATH="$HOME/Opensource/scripts:$PATH"

# 别名
alias ls="eza"
alias cat="bat"
alias lg="lazygit"
```

### 步骤 10：创建目录结构

```bash
mkdir -p ~/Opensource/{projects/{web,mobile,cli,ai,playground},forks,vendor,scripts,configs}
```

---

## 三、一键执行脚本

将以下内容保存为 `~/Opensource/scripts/setup.sh`，可一次性完成步骤 2-7, 9-10（步骤 1 Homebrew 和步骤 8 Git 需要交互，须手动执行）：

```bash
#!/bin/bash
set -e

echo "==> 安装 mise..."
brew install mise
echo 'eval "$(mise activate zsh)"' >> ~/.zshrc
eval "$(mise activate zsh)"

echo "==> 安装语言运行时..."
mise use --global node@lts
mise use --global python@3.12
mise use --global go@latest

echo "==> 安装 AI 工具..."
npm install -g @anthropic-ai/claude-code

echo "==> 安装包管理器..."
npm install -g pnpm
brew install uv

echo "==> 安装 CLI 工具集..."
brew install git gh fzf ripgrep fd bat eza jq tree lazygit starship zoxide tmux

echo "==> 安装 OrbStack..."
brew install orbstack

echo "==> 配置 Shell..."
cat >> ~/.zshrc << 'ZSHRC'
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
source <(fzf --zsh)
export PATH="$HOME/Opensource/scripts:$PATH"
alias ls="eza"
alias cat="bat"
alias lg="lazygit"
ZSHRC

echo "==> 创建目录结构..."
mkdir -p ~/Opensource/{projects/{web,mobile,cli,ai,playground},forks,vendor,scripts,configs}

echo "==> 完成！请执行 source ~/.zshrc 或重开终端。"
```

---

## 四、日常维护

```bash
brew update && brew upgrade    # 更新 Homebrew 包
mise upgrade                   # 更新语言运行时
brew cleanup && mise prune     # 清理旧版本
```
