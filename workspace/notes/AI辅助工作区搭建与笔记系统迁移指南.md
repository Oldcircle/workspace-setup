---
topic: AI辅助工作区搭建与笔记系统迁移指南
date: 2026-03-08
tools: Claude Code / 通用
summary: 记录整个笔记系统的设计思路、文件构成和新机器一键还原流程
---

# AI 辅助工作区搭建与笔记系统迁移指南

> 换新电脑或新环境时，按此文档操作可在 10 分钟内还原完整工作区。

---

## 一、设计思路

### 为什么需要一套专为 AI 设计的笔记系统？

普通笔记是给人看的，AI 编程助手（Claude Code / Cursor / Codex）不会主动翻文件夹。它们只读特定位置的特定文件：

| 工具 | 自动读取的文件 |
|------|-------------|
| Claude Code | `~/.claude/CLAUDE.md`（全局）、项目根目录 `CLAUDE.md` |
| Cursor | `.cursorrules` |
| 其他 | 你手动引用的文件 |

所以问题本质是：**笔记放在任意目录里，AI 根本不知道它们存在。**

### 解决方案：两层机制

**第一层：目录级 CLAUDE.md**
在 `~/Opensource/notes/CLAUDE.md` 里写明规范。Claude Code 进入这个目录时自动读取，知道如何创建和管理笔记。

**第二层：全局 CLAUDE.md**
在 `~/.claude/CLAUDE.md` 里写入笔记库的位置和触发指令。这样不管你在哪个项目，说"帮我记录一下"，Claude Code 都会去正确的地方创建笔记。

### 为什么不分文件夹？

对 AI 来说文件夹几乎没有意义——它靠索引文件定位知识，不靠目录结构。笔记量在 100 篇以内，平铺 + `_index.md` 索引足够，路径短、维护简单。

---

## 二、系统文件构成

```
~/Opensource/notes/              ← Git 仓库根目录
├── CLAUDE.md                    ← 笔记规范（AI 自动读）
├── _index.md                    ← 所有笔记索引表
├── _template.md                 ← 新笔记模板
├── dotfiles/
│   └── claude-global.md         ← ~/.claude/CLAUDE.md 的备份，setup.sh 会 symlink
├── setup.sh                     ← 新机器一键还原脚本
└── *.md                         ← 所有笔记

~/.claude/CLAUDE.md              ← 全局 AI 指令（symlink 指向上面的 dotfiles/claude-global.md）
```

### 各文件职责

| 文件 | 作用 | 谁来读 |
|------|------|--------|
| `notes/CLAUDE.md` | 笔记创建规范、命名规则、模板要求 | Claude Code（进入目录时） |
| `notes/_index.md` | 所有笔记的摘要索引，一行一篇 | Claude Code（查重、定位） |
| `notes/_template.md` | 新笔记的 frontmatter + 结构模板 | Claude Code（创建前读） |
| `dotfiles/claude-global.md` | 全局 AI 行为指令，笔记库位置声明 | Claude Code（每次启动） |
| `setup.sh` | 还原脚本，处理 symlink + 依赖检查 | 你（换电脑时手动运行） |

---

## 三、笔记规范摘要

每篇笔记必须包含：

```markdown
---
topic: 主题名
date: YYYY-MM-DD
tools: 适用工具
summary: 一句话摘要（AI 靠这句判断是否相关）
---

# 标题

> 一句话摘要

## 正文...

## 关键结论

- 结论1（独立成立，不依赖上下文）
- 结论2
```

**关键结论**是给 AI 快速提取要点用的，每次创建笔记必须有这一节。

---

## 四、新机器还原流程

### 前置条件

- 已安装 Git、Claude Code（`claude`）、GitHub CLI（`gh`）
- 已登录 GitHub：`gh auth login`

### 步骤

```bash
# 1. 克隆笔记库
git clone git@github.com:Oldcircle/claudenote.git ~/Opensource/notes

# 2. 运行还原脚本
cd ~/Opensource/notes
bash setup.sh
```

`setup.sh` 会自动完成：
- 创建 `~/.claude/` 目录（如不存在）
- 将 `dotfiles/claude-global.md` symlink 到 `~/.claude/CLAUDE.md`
- 检查 Claude Code 是否已安装

### 验证

```bash
# 确认 symlink 正确
ls -la ~/.claude/CLAUDE.md
# 应显示 -> .../notes/dotfiles/claude-global.md

# 启动 Claude Code，说"帮我创建一篇关于 xxx 的笔记"
# 它应该自动去 ~/Opensource/notes/ 创建并更新索引
claude
```

---

## 五、日常维护

### 同步笔记到远端

```bash
cd ~/Opensource/notes
git add .
git commit -m "add: 笔记名"
git push
```

### 修改全局 AI 指令

直接编辑 `~/Opensource/notes/dotfiles/claude-global.md`，symlink 保证 `~/.claude/CLAUDE.md` 同步更新，然后 `git push` 备份。

### 新电脑同步

```bash
cd ~/Opensource/notes && git pull
```

---

## 六、关键结论

- 笔记系统的核心不是笔记本身，而是让 AI 知道"去哪里找"和"怎么写"
- `~/.claude/CLAUDE.md` 是全局持久化 AI 指令的唯一入口，必须纳入版本控制
- 用 symlink 连接 dotfiles repo 和实际位置，一次 `git pull` 所有机器同步
- 不分文件夹，靠 `_index.md` 索引，对 AI 更友好，维护成本更低
- 换电脑本质上只需要两步：`git clone` + `bash setup.sh`
