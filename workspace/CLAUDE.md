# Workspace Rules

本文件是 `/Users/yb/Opensource` 工作区的统一规范，所有 Agent 共享（AGENTS.md 为本文件的软链接）。

当子目录有自己的 `CLAUDE.md` 或 `AGENTS.md` 时，在遵守本规范的基础上，优先遵循子目录的更具体规则。

## 笔记管理

用户说"创建笔记"、"记录一下"、"帮我记录"等时：

1. 统一创建到 `/Users/yb/Opensource/notes/` 目录下
2. 创建前先读 `/Users/yb/Opensource/notes/_index.md`，确认是否已有相关笔记（有则更新，不重复创建）
3. 创建前先读 `/Users/yb/Opensource/notes/CLAUDE.md` 了解笔记规范和模板
4. 创建后必须更新 `/Users/yb/Opensource/notes/_index.md`

## 知识库

用户的笔记库位于 `/Users/yb/Opensource/notes/`，涵盖以下主题：

- Claude Code 使用与扩展开发
- Vibecoding / AI 协作方法论
- OpenClaw 配置与运维
- 开源项目二次开发

需要相关知识时：

1. 先读 `/Users/yb/Opensource/notes/_index.md` 定位
2. 按需读取具体笔记文件

## 目录结构

详细开发规范见 `/Users/yb/Opensource/ai-dev-guide.md`。

核心目录约定：

- 自己的项目 → `/Users/yb/Opensource/projects/`
- Fork 的开源项目 → `/Users/yb/Opensource/forks/`
- 第三方学习/参考项目 → `/Users/yb/Opensource/vendor/`
- 笔记 → `/Users/yb/Opensource/notes/`

## 项目索引

| 项目 | 路径 | 状态 |
|------|------|------|
| Antigravity Manager | `/Users/yb/Opensource/forks/Antigravity-Manager` | 首次启动完成 |
| OpenClaw | `/Users/yb/Opensource/forks/openclaw` | 已 fork |
| Vibe Kanban | `/Users/yb/Opensource/vendor/vibe-kanban` | 已部署运行 |
| AIRI | `/Users/yb/Opensource/vendor/airi` | 已克隆，Web 版可运行 |
| RisuAI | `/Users/yb/Opensource/vendor/RisuAI` | 首次启动完成 |
| SillyTavern | `/Users/yb/Opensource/vendor/ST` | 首次启动完成 |
| browser-use | `/Users/yb/Opensource/vendor/browser-use` | 已克隆 |
| Trace Viewer | `/Users/yb/Opensource/projects/ai/trace-viewer` | 开发中 |
| StoryForge | `/Users/yb/Opensource/projects/ai/storyforge` | 规划中 |
| ComfyUI | `/Users/yb/Opensource/vendor/ComfyUI` | 首次启动完成 |
| Fable | `/Users/yb/Opensource/projects/ai/fable` | 开发中 |

## 环境概览

- macOS Apple Silicon (`arm64`)
- Node 24 via `mise`
- Rust 1.93 via `rustup`
- npm 11
- `mise` 管理 Node/Python/Go 版本

## 子项目规则文件

每个子项目以 `CLAUDE.md` 为 source of truth，`AGENTS.md` 为其软链接。已知的：

- `/Users/yb/Opensource/forks/Antigravity-Manager/CLAUDE.md`
- `/Users/yb/Opensource/forks/openclaw/CLAUDE.md`
- `/Users/yb/Opensource/vendor/vibe-kanban/CLAUDE.md`
- `/Users/yb/Opensource/vendor/airi/CLAUDE.md`
- `/Users/yb/Opensource/vendor/RisuAI/CLAUDE.md`
- `/Users/yb/Opensource/vendor/ST/CLAUDE.md`
- `/Users/yb/Opensource/vendor/browser-use/CLAUDE.md`
- `/Users/yb/Opensource/projects/ai/trace-viewer/CLAUDE.md`
- `/Users/yb/Opensource/projects/ai/storyforge/CLAUDE.md`
- `/Users/yb/Opensource/vendor/ComfyUI/CLAUDE.md`
- `/Users/yb/Opensource/projects/ai/fable/CLAUDE.md`

## CLAUDE.md 与 Memory 的分工（Claude Code 专属）

### 项目 CLAUDE.md = 项目说明书（source of truth）
- 放：技术栈、目录结构、开发命令、代码约定、首次运行记录、**活跃文档清单**
- 更新时机：项目本身发生变化时（加依赖、改启动方式、换分支策略、文档新增/废弃）
- 目标：任何新会话进入项目后能立即独立工作
- **活跃文档清单**：CLAUDE.md 中维护 `## 活跃文档` 小节，列出当前有效的 PLAN.md / STATUS.md / DESIGN.md 等。AI 进入项目时只读清单中的文档，不猜测。文档废弃时从清单移除即可

### Memory = 跨项目经验索引
- `MEMORY.md`：项目索引表（指向项目 CLAUDE.md）、工作流规则、环境信息、用户偏好
- Memory 子文件：调试踩坑、临时状态、跨项目关联发现等 CLAUDE.md 不适合放的经验性内容
- 更新时机：通过工作积累了新经验时

### 核心原则
- **不重复，单一来源**：项目信息以项目 CLAUDE.md 为准，Memory 只做索引和补充
- **首次运行记录**：项目完成首次运行后，必须在项目目录的 CLAUDE.md 中记录运行方式、依赖安装、注意事项
- **首次发布记录**：项目首次推送到 GitHub 后，必须在项目目录的 CLAUDE.md 中记录：GitHub 仓库地址、发布用的目录结构（如 monorepo 映射关系）、本地源目录与仓库目录的对应关系、提交和推送方式
- **开发文档分层**：有开发计划的项目必须创建 PLAN.md + STATUS.md；复杂项目按需加 DESIGN.md / PLAN-xxx.md / FORK.md。详见 `ai-dev-guide.md` 第四节
- **STATUS.md 是会话交接文档**：每次有实质进展时更新，记录当前进度和下次继续的入口，不是日志
