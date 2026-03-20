#!/bin/bash
set -e

echo "========================================="
echo "  工作区环境自动配置"
echo "========================================="
echo ""

# 检查前置条件
if ! command -v brew &>/dev/null; then
  echo "❌ Homebrew 未安装，请先完成 manual-steps.md 中的手动步骤"
  exit 1
fi

if ! gh auth status &>/dev/null 2>&1; then
  echo "⚠️  GitHub CLI 未登录，部分功能可能受限"
  echo "   请稍后执行: gh auth login"
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# ===== 第一步：安装 mise =====
echo ""
echo "==> [1/8] 安装 mise（版本管理）..."
brew install mise 2>/dev/null || echo "mise 已安装"

if ! grep -q 'mise activate zsh' ~/.zshrc 2>/dev/null; then
  echo 'eval "$(mise activate zsh)"' >> ~/.zshrc
fi
eval "$(mise activate zsh)" 2>/dev/null || true

# ===== 第二步：安装语言运行时 =====
echo ""
echo "==> [2/8] 安装语言运行时..."
mise use --global node@lts
mise use --global python@3.12
mise use --global go@latest

if ! command -v rustup &>/dev/null; then
  echo "   安装 Rust..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source "$HOME/.cargo/env"
fi

# ===== 第三步：安装全局 npm 包 =====
echo ""
echo "==> [3/8] 安装全局 npm 包..."
npm install -g pnpm @anthropic-ai/claude-code @openai/codex

# ===== 第四步：安装 CLI 工具集 =====
echo ""
echo "==> [4/8] 安装 CLI 工具集..."
brew install git gh uv bat eza fd fzf jq ripgrep tree \
  lazygit starship zoxide tmux \
  2>/dev/null || true

# ===== 第五步：安装容器运行时 =====
echo ""
echo "==> [5/8] 安装 OrbStack..."
brew install orbstack 2>/dev/null || true

# ===== 第六步：安装 AI/ML 工具（按需） =====
echo ""
echo "==> [6/8] 安装 AI/ML 工具..."
brew install ollama cmake mlx 2>/dev/null || true

# ===== 第七步：部署配置文件 =====
echo ""
echo "==> [7/8] 部署配置文件..."

# dotfiles
cp "$SCRIPT_DIR/dotfiles/zshrc" ~/.zshrc
mkdir -p ~/.config/mise
cp "$SCRIPT_DIR/dotfiles/mise-config.toml" ~/.config/mise/config.toml

# Claude Code 配置
mkdir -p ~/.claude/commands ~/.claude/skills/browser-use
cp "$SCRIPT_DIR/claude-code/settings.json" ~/.claude/settings.json
cp "$SCRIPT_DIR/claude-code/commands/onboard.md" ~/.claude/commands/onboard.md
cp "$SCRIPT_DIR/claude-code/commands/dev-init.md" ~/.claude/commands/dev-init.md
cp "$SCRIPT_DIR/claude-code/skills/browser-use/SKILL.md" ~/.claude/skills/browser-use/SKILL.md

# ===== 第八步：创建工作区 =====
echo ""
echo "==> [8/8] 创建工作区目录结构..."

mkdir -p ~/Opensource/{projects/{web,mobile,cli,ai,playground},forks,vendor,scripts,configs,notes/dotfiles}

# 工作区规范文件
cp "$SCRIPT_DIR/workspace/CLAUDE.md" ~/Opensource/CLAUDE.md
cp "$SCRIPT_DIR/workspace/ai-dev-guide.md" ~/Opensource/ai-dev-guide.md
cp "$SCRIPT_DIR/workspace/workflow-handbook.md" ~/Opensource/workflow-handbook.md
cp "$SCRIPT_DIR/workspace/dev-setup-plan.md" ~/Opensource/dev-setup-plan.md
cd ~/Opensource && ln -sf CLAUDE.md AGENTS.md

# 笔记库
cp "$SCRIPT_DIR/workspace/notes/CLAUDE.md" ~/Opensource/notes/CLAUDE.md
cp "$SCRIPT_DIR/workspace/notes/_template.md" ~/Opensource/notes/_template.md
cp "$SCRIPT_DIR/workspace/notes/dotfiles/claude-global.md" ~/Opensource/notes/dotfiles/claude-global.md
cp "$SCRIPT_DIR/workspace/notes/AI辅助工作区搭建与笔记系统迁移指南.md" ~/Opensource/notes/

# 全局 Claude Code 指令：symlink 指向笔记库中的源文件（便于 git 统一管理）
ln -sf ~/Opensource/notes/dotfiles/claude-global.md ~/.claude/CLAUDE.md

# 创建笔记索引（空的）
if [ ! -f ~/Opensource/notes/_index.md ]; then
  cat > ~/Opensource/notes/_index.md << 'EOF'
# 笔记索引

> 维护规则：每次创建新笔记后必须更新此文件

| 文件名 | 摘要 | 适用工具 | 日期 |
|--------|------|---------|------|
| [AI辅助工作区搭建与笔记系统迁移指南.md](AI辅助工作区搭建与笔记系统迁移指南.md) | 记录整个笔记系统的设计思路、文件构成和新机器一键还原流程 | Claude Code / 通用 | 2026-03-08 |
EOF
fi

# 初始化 git
cd ~/Opensource
if [ ! -d .git ]; then
  git init
  echo ".DS_Store" > .gitignore
  echo "node_modules/" >> .gitignore
fi

echo ""
echo "========================================="
echo "  ✅ 环境配置完成！"
echo "========================================="
echo ""
echo "已部署的个人化配置："
echo "  - ~/.zshrc                      Shell 配置"
echo "  - ~/.config/mise/config.toml    语言版本管理"
echo "  - ~/.claude/settings.json       Claude Code 权限"
echo "  - ~/.claude/commands/onboard.md 自定义 /onboard 命令"
echo "  - ~/.claude/commands/dev-init.md 自定义 /dev-init 命令"
echo "  - ~/.claude/skills/browser-use  browser-use 技能"
echo "  - ~/.claude/CLAUDE.md           → ~/Opensource/notes/dotfiles/claude-global.md (symlink)"
echo "  - ~/Opensource/CLAUDE.md        工作区统一规范"
echo "  - ~/Opensource/AGENTS.md        → CLAUDE.md (symlink)"
echo "  - ~/Opensource/ai-dev-guide.md  开发规范"
echo "  - ~/Opensource/workflow-handbook.md 工作流手册"
echo "  - ~/Opensource/notes/           笔记库（规范 + 模板 + 索引）"
echo ""
echo "后续步骤："
echo "  1. 执行 source ~/.zshrc 或重开终端"
echo "  2. cd ~/Opensource && claude"
echo "  3. 用 /onboard 命令接入各个项目"
echo ""
