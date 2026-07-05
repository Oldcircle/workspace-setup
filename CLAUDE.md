# Workspace Setup

本项目把「为 AI 协作组织工作区」的一整套方法打包成了一个可安装的 **skill**——`ai-workspace`（在 `claude-code/skills/ai-workspace/`）。装上它，agent 就内建了四层工作区法（组织 / 规则 / 记忆 / **治理**），不用再手抄或每次口头交代。治理层（信息归属矩阵、文档预算、时态红线、定期 lint）同时内置在 `workspace/CLAUDE.md` 模板里，防止索引与规则文件随时间膨胀腐化。

仓库同时是工作区环境一键配置包：新机器上克隆后执行 `setup.sh`，即可还原完整开发环境 + 部署全部 skill。

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
│   └── skills/
│       ├── ai-workspace/
│       │   └── SKILL.md               # → ~/.claude/skills/ai-workspace/SKILL.md（★ 三层工作区法主 skill）
│       ├── onboard/
│       │   └── SKILL.md               # → ~/.claude/skills/onboard/SKILL.md（接手项目技能）
│       ├── dev-init/
│       │   └── SKILL.md               # → ~/.claude/skills/dev-init/SKILL.md（建 PLAN/STATUS 技能）
│       └── browser-use/
│           └── SKILL.md               # → ~/.claude/skills/browser-use/SKILL.md
│
└── workspace/                         # ~/Opensource/ 工作区内容
    ├── CLAUDE.md                      # 工作区统一规范模板（含文档治理五件套）
    ├── ai-dev-guide.md                # 开发规范总览（含文档预算与写作指南）
    └── notes/                         # 笔记库骨架
        ├── CLAUDE.md                  # 笔记库规范
        ├── _template.md               # 笔记模板
        ├── AI辅助工作区搭建与笔记系统迁移指南.md  # 笔记系统设计文档
        ├── 工作区AI文档瘦身治理提示词.md          # 已膨胀工作区的一次性大扫除提示词
        └── dotfiles/
            └── claude-global.md       # → ~/.claude/CLAUDE.md（通过 symlink）
```

## 部署映射表

| 项目中的文件 | 部署到 | 方式 |
|-------------|--------|------|
| `dotfiles/zshrc` | `~/.zshrc` | 复制 |
| `dotfiles/mise-config.toml` | `~/.config/mise/config.toml` | 复制 |
| `claude-code/settings.json` | `~/.claude/settings.json` | 复制 |
| `claude-code/skills/ai-workspace/SKILL.md` | `~/.claude/skills/ai-workspace/SKILL.md` | 复制 |
| `claude-code/skills/onboard/SKILL.md` | `~/.claude/skills/onboard/SKILL.md` | 复制 |
| `claude-code/skills/dev-init/SKILL.md` | `~/.claude/skills/dev-init/SKILL.md` | 复制 |
| `claude-code/skills/browser-use/SKILL.md` | `~/.claude/skills/browser-use/SKILL.md` | 复制 |
| `workspace/CLAUDE.md` | `~/Opensource/CLAUDE.md` | 复制 |
| `workspace/ai-dev-guide.md` | `~/Opensource/ai-dev-guide.md` | 复制 |
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
