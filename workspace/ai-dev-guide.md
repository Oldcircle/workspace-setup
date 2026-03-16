# Opensource 开发规范总览

> **核心理念**：你负责决策，AI 负责执行。你的主要工作是清晰地描述意图，而不是手写代码。

---

## 目录

1. [目录结构](#一目录结构)
2. [工具速查](#二工具速查)
3. [AI 编程工具矩阵](#三ai-编程工具矩阵)
4. [项目标准结构与 CLAUDE.md 模板](#四项目标准结构与-claudemd-模板)
5. [新项目创建流程](#五新项目创建流程)
6. [日常开发工作流](#六日常开发工作流)
7. [Git 工作流](#七git-工作流)
8. [开源项目工作流](#八开源项目工作流)
9. [日常维护](#九日常维护)
10. [有效指令原则](#十有效指令原则)

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
├── forks/               # Fork 的开源项目（向上游贡献）
├── vendor/              # 克隆的第三方项目（学习/参考）
├── scripts/             # 个人自动化脚本（已加入 $PATH）
├── configs/             # dotfiles 和跨机器同步的配置
└── ai-dev-guide.md      # 本文档（唯一规范入口）
```

---

## 二、工具速查

| 工具 | 用途 |
|------|------|
| `mise` | 统一语言版本管理，按项目自动切换 |
| `pnpm` | Node.js 推荐包管理器 |
| `uv` | Python 推荐包管理器（极快） |
| `gh` | GitHub CLI，AI 用于 PR/Issue 管理 |
| `ripgrep` / `fd` | 快速搜索，AI 用于代码查找 |
| `jq` | JSON 处理 |
| `lazygit` | Git TUI，人工快速审查 AI 的提交 |
| `zoxide` | 智能目录跳转（`z 项目名`） |
| `tmux` | 终端复用，并行运行 AI 和开发服务器 |
| `orbstack` | 轻量容器运行时，`docker` / `docker-compose` 直接可用 |

---

## 三、AI 编程工具矩阵

| 工具 | 最佳场景 | 启动方式 |
|------|---------|---------|
| **Claude Code** | 全栈开发、复杂重构、多文件修改、命令执行 | `claude` |
| **Trae** | 日常编码、实时补全、单文件编辑 | 打开 Trae |
| **Cursor** | 代码编辑、Chat + Composer 多文件协作 | 打开 Cursor |

**选择建议**：新建项目 / 大规模修改 / 调试运维 → Claude Code；日常编码 → Trae 或 Cursor；不确定 → Claude Code。

### Claude Code 实用操作

| 操作 | 说明 |
|------|------|
| `claude` | 启动交互式会话 |
| `claude "简短任务描述"` | 一次性执行后退出 |
| `cat file \| claude "解释这段代码"` | 管道输入 |
| `claude /compact` | 压缩上下文，释放对话空间 |
| `claude /help` | 查看所有命令 |

---

## 四、项目标准结构与指令文件模板

### 每个项目的标准文件

```
my-project/
├── CLAUDE.md             # 项目指令（source of truth）
├── AGENTS.md → CLAUDE.md # 软链接，让所有 Agent 都能读到
├── .cursorrules          # Cursor 项目规则（如使用 Cursor）
├── README.md             # 项目说明
├── .mise.toml            # 锁定本项目的语言运行时版本
├── .gitignore
└── ...
```

> 策略：`CLAUDE.md` 为唯一 source of truth，`AGENTS.md` 软链接指向它。创建方式：`ln -sf CLAUDE.md AGENTS.md`

### CLAUDE.md 模板

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
- 代码风格、命名规范
- 提交信息格式
- 分支策略
```

> AI 读完 `CLAUDE.md` 后应能独立开发，无需额外询问基本信息。

### 版本锁定

```bash
cd ~/Opensource/projects/web/my-project
mise use node@20    # 生成 .mise.toml，进入此目录自动切换
```

---

## 五、新项目创建流程

```bash
cd ~/Opensource/projects/web   # 进入对应类型目录
claude
```

```
帮我创建一个名为 my-blog 的项目，用 Next.js + TypeScript + Tailwind CSS，
包含首页和文章详情页。帮我初始化 git 仓库，配置好 ESLint 和 Prettier。
```

如果 AI 没有自动创建上下文文件，追加：

```
帮我创建 CLAUDE.md，包含这个项目的技术栈、开发命令和编码约定。
再创建 .mise.toml 锁定当前 Node.js 版本。
```

---

## 六、日常开发工作流

```bash
cd ~/Opensource/projects/web/my-blog
claude   # 自动读取 CLAUDE.md，理解上下文后等待指令
```

### 常见指令

```
# 功能开发
> 添加一个标签系统，文章可以打多个标签，首页可以按标签筛选。

# Bug 修复
> 文章详情页在移动端标题溢出了，帮我修复。

# 重构
> 把所有 API 调用从各个组件里抽取到统一的 services 层。

# 代码审查
> 审查 src/components/ 下的所有组件，检查是否有性能问题或不规范的写法。

# 调试
> 运行 npm run dev 后页面白屏，帮我排查原因。

# 依赖
> 帮我升级所有依赖到最新版本，运行测试确保没有问题。
> 帮我检查有没有安全漏洞需要修复的依赖。

# Docker
> 帮我写一个 docker-compose.yml，包含这个项目需要的 MySQL/Redis。
> 帮我写一个 Dockerfile，用多阶段构建，生产环境用 Node alpine 镜像。

# 发布
> 帮我写 GitHub Actions CI/CD 配置。
> 帮我把项目部署到 Vercel / Fly.io。
```

### AI 做错时的处理

| 情况 | 处理方式 |
|------|---------|
| 方向不对 | "停，这不是我要的，我要的是……" |
| 改坏了代码 | `git diff` 查看，`git checkout .` 回滚，重新描述 |
| 不理解需求 | 拆分成更小步骤，逐步推进 |
| 技术选型不满意 | "不要用 X，换成 Y" |

---

## 七、Git 工作流

### 分支策略

```
main              # 稳定版本
├── feat/xxx      # 功能开发
├── fix/xxx       # Bug 修复
└── refactor/xxx  # 重构
```

### 常用指令

```
> 先创建 feat/tag-system 分支再开始开发。
> 帮我提交当前的改动，写好 commit message。
> 帮我创建一个 PR，目标分支是 main。
> 帮我把最近 3 次提交合并成一个，重写 commit message。
> 帮我回滚上一次提交，保留代码改动。
> 帮我创建一个 tag v1.0.0 并推送。
```

审查 AI 的提交：

```bash
lazygit
# 或
> 总结一下你刚才做了哪些修改，为什么这样做。
```

---

## 八、开源项目工作流

### 场景 A：克隆并运行（学习/参考）

```bash
cd ~/Opensource/vendor && claude
```

```
帮我把 https://github.com/xxx/project-name 克隆到当前目录，
分析它的技术栈和依赖，然后帮我把它运行起来。
```

遇到问题追加：

```
> 它需要 PostgreSQL，帮我用 docker compose 启动所需的服务。
> 它需要环境变量，帮我根据 .env.example 创建 .env 并填入合理的默认值。
```

---

### 场景 B：Fork 后二次开发并提交 PR

```bash
cd ~/Opensource/forks && claude
```

```
# 1. Fork 和准备
帮我 fork https://github.com/原作者/project-name 到我的 GitHub 账号，
然后克隆我的 fork 到当前目录，配置好上游 remote。

# 2. 创建分支 + 开发
帮我创建分支 fix/issue-123，然后 [描述修改]。

# 3. 测试 + 提交
运行这个项目的测试，确保改动没有破坏任何东西。如果都通过了，帮我提交并推送。

# 4. 创建 PR
帮我向原仓库的 main 分支创建 PR。标题简洁描述改动，正文说明改了什么、为什么改、怎么测试的。

# 5. 处理 review 意见
帮我看一下 PR 上的 review 评论，按照 reviewer 的建议修改代码，然后提交推送更新 PR。
```

---

### 场景 C：同步上游更新到 Fork

```
帮我同步上游仓库的最新代码到我的 fork 的 main 分支。

# 有开发中的分支时
帮我把 main 的最新更新 rebase 到我的 feat/xxx 分支上，解决可能的冲突。
```

---

### 场景 D：基于开源模板开发自己的项目

```bash
cd ~/Opensource/projects/web && claude
```

```
帮我基于 https://github.com/xxx/template-project 创建我自己的项目 my-app。
克隆后去掉原仓库的 git 关联，重新初始化为我自己的仓库，
然后帮我在 GitHub 上创建一个私有仓库并推送上去。
```

---

## 九、日常维护

```bash
brew update && brew upgrade    # 更新 Homebrew 包
mise upgrade                   # 更新语言运行时
brew cleanup && mise prune     # 清理旧版本
```

---

## 十、有效指令原则

**万能公式**：`[做什么] + [用什么/不用什么] + [范围] + [完成标准]`

```
帮我 [添加用户注册功能]，
[用 React Hook Form 做表单验证]，
[只改前端，后端 API 已经有了在 /api/auth/register]，
[注册成功后跳转到首页并显示欢迎提示]。
```

### 好指令 vs 坏指令

| 坏指令 | 好指令 |
|--------|--------|
| "帮我改改这个项目" | "帮我给首页添加一个搜索框，支持按标题模糊搜索文章" |
| "这个跑不起来" | "执行 npm run dev 后报错 [粘贴错误]，帮我修复" |
| "帮我优化一下" | "这个列表页加载很慢，帮我加上分页，每页 20 条" |

### 复杂任务分步推进

```
> 帮我分析这个项目的认证系统是怎么实现的。
> 我想加谷歌 OAuth 登录，基于现在的代码怎么实现最简单？
> 按你说的方案来，先从后端 API 开始。
> 帮我写几个测试覆盖正常登录和异常情况。
```

### 关键提醒

- **给完整 URL**：克隆时给完整 GitHub URL，不要假设 AI 知道。
- **粘贴错误信息**：遇到报错直接粘贴完整错误输出，不要只说"报错了"。
- **让 AI 先读再改**：陌生项目先让 AI 分析结构，再要求修改。
- **维护 CLAUDE.md**：引入新依赖、修改结构、确立新约定时及时更新。
