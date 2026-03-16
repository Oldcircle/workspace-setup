# 开源项目工作流手册

> 本手册覆盖你日常与开源项目打交道的全部场景。
> 每个场景都包含：**你该做什么** → **给 AI 什么指令** → **完整流程示例**。

---

## 目录

- [场景一：克隆并运行一个开源项目](#场景一克隆并运行一个开源项目)
- [场景二：Fork 后二次开发并提交 PR](#场景二fork-后二次开发并提交-pr)
- [场景三：同步上游更新到自己的 Fork](#场景三同步上游更新到自己的-fork)
- [场景四：把开源项目作为基础模板开发自己的项目](#场景四把开源项目作为基础模板开发自己的项目)
- [场景五：日常开发中的常用操作速查](#场景五日常开发中的常用操作速查)
- [附录：给 AI 下指令的原则](#附录给-ai-下指令的原则)

---

## 场景一：克隆并运行一个开源项目

**目的**：把 GitHub 上的项目跑起来，本地体验或学习源码。

### 你的操作

```bash
cd ~/Opensource/vendor
claude
```

### 给 AI 的指令

```
帮我把 https://github.com/xxx/project-name 克隆到当前目录，
分析它的技术栈和依赖，然后帮我把它运行起来。
```

### AI 会做什么

1. `git clone` 项目
2. 读 README、package.json / requirements.txt / go.mod 等，识别技术栈
3. 检查并安装所需的语言版本（通过 mise）
4. 安装依赖
5. 找到启动命令并运行
6. 如果报错，自动排查并修复

### 如果遇到问题，追加指令

```
# 环境问题
> 它需要 PostgreSQL 数据库，帮我用 docker compose 启动所需的服务。

# 配置问题
> 它需要环境变量，帮我根据 .env.example 创建 .env 并填入合理的默认值。

# 版本问题
> 这个项目需要 Node 18，帮我用 mise 在这个项目目录下锁定 Node 18。
```

### 完整流程示例

```
你：帮我克隆 https://github.com/vercel/next.js 到当前目录，
    我想看看它的 examples/with-tailwindcss 示例能不能跑起来。

AI：（克隆 → 进入 examples/with-tailwindcss → pnpm install → pnpm dev → 告诉你打开 localhost:3000）

你：帮我分析一下这个示例的项目结构和路由是怎么组织的。

AI：（阅读源码 → 给你解释）
```

---

## 场景二：Fork 后二次开发并提交 PR

**目的**：给开源项目修 Bug 或加功能，提交贡献。

### 阶段 1：Fork 和准备

```bash
cd ~/Opensource/forks
claude
```

```
帮我 fork https://github.com/原作者/project-name 到我的 GitHub 账号，
然后克隆我的 fork 到当前目录，配置好上游 remote。
```

> AI 会执行：
> ```bash
> gh repo fork 原作者/project-name --clone=true
> cd project-name
> git remote -v   # 确认 origin=你的fork, upstream=原仓库
> ```

### 阶段 2：创建分支 + 开发

```
帮我创建一个分支 fix/issue-123-xxx，然后 [描述你要做的修改]。
```

**指令示例（按场景）**：

```
# 修 Bug
> 创建分支 fix/dropdown-overflow，修复下拉菜单在移动端溢出的问题。

# 加功能
> 创建分支 feat/dark-mode，参考项目现有的主题系统，添加暗色模式支持。

# 改文档
> 创建分支 docs/api-examples，给 README 的 API 部分补充使用示例。
```

### 阶段 3：测试 + 提交

```
运行这个项目的测试，确保我的改动没有破坏任何东西。
如果测试都通过了，帮我提交并推送。
```

### 阶段 4：创建 PR

```
帮我向原仓库的 main 分支创建 PR。
标题简洁描述改动，正文说明改了什么、为什么改、怎么测试的。
```

> AI 会执行 `gh pr create --repo 原作者/project-name` 并填写规范的 PR 描述。

### 阶段 5：PR 被要求修改

```
帮我看一下 PR 上的 review 评论，按照 reviewer 的建议修改代码，
然后提交推送更新 PR。
```

### 完整流程示例

```
你：帮我 fork https://github.com/some-org/cool-tool 并克隆到当前目录。

AI：（fork → clone → 配置 upstream → 安装依赖 → 确认能运行）

你：创建分支 fix/typo-in-config，把 src/config.ts 第 42 行的 "recieve" 改成 "receive"。

AI：（创建分支 → 修改 → 运行测试 → 提交）

你：帮我创建 PR 到原仓库。

AI：（gh pr create → 返回 PR 链接）

你：reviewer 说要补个测试，帮我看看他的评论然后加上测试。

AI：（gh pr view → 读评论 → 写测试 → 提交推送）
```

---

## 场景三：同步上游更新到自己的 Fork

**目的**：原仓库有了新提交，你的 Fork 需要保持同步。

### 给 AI 的指令

```
帮我同步上游仓库的最新代码到我的 fork 的 main 分支。
```

> AI 会执行：
> ```bash
> git fetch upstream
> git checkout main
> git rebase upstream/main
> git push origin main
> ```

### 如果你有正在开发的分支

```
帮我把 main 的最新更新 rebase 到我的 feat/xxx 分支上，解决可能的冲突。
```

---

## 场景四：把开源项目作为基础模板开发自己的项目

**目的**：基于某个开源项目做自己的产品，不打算贡献回上游。

### 给 AI 的指令

```bash
cd ~/Opensource/projects/web
claude
```

```
帮我基于 https://github.com/xxx/template-project 创建我自己的项目 my-app。
克隆后去掉原仓库的 git 关联，重新初始化为我自己的仓库，
然后帮我在 GitHub 上创建一个私有仓库并推送上去。
```

> AI 会执行：
> ```bash
> git clone https://github.com/xxx/template-project my-app
> cd my-app
> rm -rf .git
> git init
> git add -A && git commit -m "init: based on template-project"
> gh repo create my-app --private --source=. --push
> ```

### 后续二次开发

```
帮我创建 CLAUDE.md，描述这个项目的技术栈、结构和开发命令。
然后 [描述你想要的修改]。
```

---

## 场景五：日常开发中的常用操作速查

### 项目状态查看

```
# 快速了解项目
> 帮我分析这个项目的整体架构和关键文件。

# 查看改动
> 帮我看看当前有哪些未提交的改动，总结一下改了什么。

# 查看分支
> 帮我列出所有分支，说明每个分支在做什么。
```

### 依赖管理

```
> 帮我升级所有依赖到最新版本，运行测试确保没有问题。
> 帮我添加 xxx 这个库，并给我一个简单的使用示例。
> 帮我检查有没有安全漏洞需要修复的依赖。
```

### 调试

```
> 运行 xxx 命令后报了这个错 [粘贴错误信息]，帮我排查。
> 帮我在 xxx 功能上加一些日志，我需要追踪 [某个变量/流程]。
> 这个 API 返回 500，帮我找到出错的位置并修复。
```

### Docker 相关

```
> 帮我写一个 docker-compose.yml，包含这个项目需要的 [MySQL/Redis/...]。
> 帮我构建 Docker 镜像并测试运行。
> 帮我把现有的 Dockerfile 优化一下，减小镜像体积。
```

### Git 操作

```
> 帮我把最近 3 次提交合并成一个，重写 commit message。
> 帮我把 feat/xxx 分支的改动 cherry-pick 到 main。
> 帮我回滚上一次提交，保留代码改动。
> 帮我创建一个 tag v1.0.0 并推送。
```

### 发布相关

```
> 帮我把项目部署到 Vercel / Fly.io / ...
> 帮我写 GitHub Actions CI/CD 配置。
> 帮我发一个 GitHub Release，包含 changelog。
```

---

## 附录：给 AI 下指令的原则

### 好指令 vs 坏指令

| 坏指令 | 好指令 | 为什么 |
|--------|--------|--------|
| "帮我改改这个项目" | "帮我给首页添加一个搜索框，支持按标题模糊搜索文章" | 明确目标和范围 |
| "这个跑不起来" | "执行 npm run dev 后报错 [粘贴错误]，帮我修复" | 提供了具体错误信息 |
| "帮我优化一下" | "这个列表页加载很慢，帮我加上分页，每页 20 条" | 说清了"优化"是什么 |
| "改成好看一点" | "参考 xxx 的设计风格，把按钮改成圆角 + 蓝色主题" | 给了具体参考 |

### 指令模板

**万能公式**：`[做什么] + [用什么/不用什么] + [范围] + [完成标准]`

```
帮我 [添加用户注册功能]，
[用 React Hook Form 做表单验证]，
[只改前端，后端 API 已经有了在 /api/auth/register]，
[注册成功后跳转到首页并显示欢迎提示]。
```

### 分步推进复杂任务

不要试图一句话描述所有需求。对于复杂任务，分步下指令更有效：

```
# 第一步：让 AI 先理解
> 帮我分析这个项目的认证系统是怎么实现的。

# 第二步：确认方案
> 我想加一个 OAuth 谷歌登录，你觉得基于现在的代码怎么实现最简单？

# 第三步：开始开发
> 按你说的方案来，先从后端 API 开始。

# 第四步：验证
> 帮我写几个测试覆盖正常登录和异常情况。
```

### 关键提醒

- **永远给出仓库 URL**：让 AI 克隆时给完整的 GitHub URL，不要假设它知道。
- **粘贴错误信息**：遇到报错时直接粘贴完整的错误输出，不要只说"报错了"。
- **说清楚去哪个目录**：开始前先 `cd` 到正确的目录，或者在指令里说明。
- **不满意就直说**：AI 的方案不合意时直接说"不要这样，换成 xxx"，不需要委婉。
- **让 AI 先读再改**：对于陌生项目，先让 AI 分析结构，再要求修改，效果更好。
