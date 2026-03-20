# Workspace Setup

本项目是工作区环境一键配置包。在新机器上克隆后，让 Claude Code 执行 `setup.sh` 即可还原完整开发环境。

## 使用方式

```bash
# 新机器上
git clone <本仓库地址> ~/workspace-setup
cd ~/workspace-setup
# 先完成 manual-steps.md 中的手动步骤（Homebrew、Git、SSH、gh login）
# 然后：
bash setup.sh
```

## 项目结构

```
workspace-setup/
├── CLAUDE.md                          # 本文件（给 AI 读的说明书）
├── manual-steps.md                    # 需要人工交互的步骤
├── setup.sh                           # 自动化安装脚本
│
├── dotfiles/                          # Shell / 工具配置
│   ├── zshrc                          # → ~/.zshrc
│   ├── mise-config.toml               # → ~/.config/mise/config.toml
│   └── gitconfig                      # Git 配置参考（不自动部署）
│
├── claude-code/                       # Claude Code 配置
│   ├── settings.json                  # → ~/.claude/settings.json（权限 + 插件）
│   ├── commands/
│   │   ├── onboard.md                 # → ~/.claude/commands/onboard.md（/onboard 命令）
│   │   └── dev-init.md                # → ~/.claude/commands/dev-init.md（/dev-init 命令）
│   └── skills/
│       └── browser-use/
│           └── SKILL.md               # → ~/.claude/skills/browser-use/SKILL.md
│
└── workspace/                         # ~/Opensource/ 工作区内容
    ├── CLAUDE.md                      # 工作区统一规范（source of truth）
    ├── ai-dev-guide.md                # 开发规范总览
    ├── workflow-handbook.md           # 开源项目工作流手册
    ├── dev-setup-plan.md              # 环境搭建原始计划
    └── notes/                         # 笔记库骨架
        ├── CLAUDE.md                  # 笔记库规范
        ├── _template.md               # 笔记模板
        ├── AI辅助工作区搭建与笔记系统迁移指南.md  # 笔记系统设计文档
        └── dotfiles/
            └── claude-global.md       # → ~/.claude/CLAUDE.md（通过 symlink）
```

## 部署映射表

| 项目中的文件 | 部署到 | 方式 |
|-------------|--------|------|
| `dotfiles/zshrc` | `~/.zshrc` | 复制 |
| `dotfiles/mise-config.toml` | `~/.config/mise/config.toml` | 复制 |
| `claude-code/settings.json` | `~/.claude/settings.json` | 复制 |
| `claude-code/commands/onboard.md` | `~/.claude/commands/onboard.md` | 复制 |
| `claude-code/commands/dev-init.md` | `~/.claude/commands/dev-init.md` | 复制 |
| `claude-code/skills/browser-use/SKILL.md` | `~/.claude/skills/browser-use/SKILL.md` | 复制 |
| `workspace/CLAUDE.md` | `~/Opensource/CLAUDE.md` | 复制 |
| `workspace/ai-dev-guide.md` | `~/Opensource/ai-dev-guide.md` | 复制 |
| `workspace/workflow-handbook.md` | `~/Opensource/workflow-handbook.md` | 复制 |
| `workspace/dev-setup-plan.md` | `~/Opensource/dev-setup-plan.md` | 复制 |
| `workspace/notes/*` | `~/Opensource/notes/` | 复制 |
| `workspace/notes/dotfiles/claude-global.md` | `~/.claude/CLAUDE.md` | **symlink** |
| — | `~/Opensource/AGENTS.md` → `CLAUDE.md` | **symlink** |

## 关键约定

### symlink 策略
- `~/.claude/CLAUDE.md` 是 symlink，指向 `~/Opensource/notes/dotfiles/claude-global.md`
  - 好处：全局 AI 指令纳入笔记库 git 管理，一次 `git pull` 所有机器同步
- 每个项目 `AGENTS.md` 是 symlink，指向同目录的 `CLAUDE.md`
  - 好处：`CLAUDE.md` 为唯一 source of truth，所有 Agent 都能读到

### 笔记库独立仓库
- `~/Opensource/notes/` 可作为独立 git 仓库（如 `claudenote`）
- 笔记不分子目录，靠 `_index.md` 索引
- 每篇笔记必须有 frontmatter + 关键结论
