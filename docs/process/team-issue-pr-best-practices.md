# 团队使用 Issue 和 Pull Request 的最佳实践

这是一份与具体项目无关的协作流程文档，适合个人、小团队和中大型团队统一使用 GitHub/GitLab 的 Issue、Branch 和 Pull Request 开发项目。

## 核心概念

### Issue 是“要做什么”

Issue 用来描述需求、缺陷、任务或技术债。它回答：

- 为什么要做？
- 要做成什么样？
- 验收标准是什么？
- 有哪些依赖或限制？
- 谁负责推进？

常见 Issue 类型：

- 需求：新增一个功能
- Bug：修复一个错误
- 技术任务：重构、升级依赖、补测试
- 调研：确认方案或风险
- 发布任务：打包、上线、回滚预案

### Pull Request 是“我做了什么改动”

Pull Request，简称 PR，用来请求把一个分支的代码合并进目标分支。它回答：

- 改了哪些内容？
- 如何验证？
- 解决哪个 Issue？
- 是否影响已有行为？
- 是否可以合并？

Issue 和 PR 的关系：

```text
Issue 描述目标
  ↓
开发者基于 Issue 创建分支
  ↓
在分支上提交代码
  ↓
创建 PR 请求合并
  ↓
PR 合并后关闭 Issue
```

## 谁提 Issue，谁提 PR

### 谁可以提 Issue

Issue 不只由开发提。任何发现问题或提出需求的人都可以提 Issue：

- 产品经理：提出需求、验收标准、优先级
- 设计师：提出交互、视觉、可用性问题
- 测试人员：提交 Bug 和复现步骤
- 开发者：提交技术任务、重构、依赖升级、发现的 Bug
- 运营/客服/用户支持：反馈用户问题
- 项目负责人：拆分里程碑、规划迭代任务

最佳实践：

- 谁最了解问题，谁先提 Issue。
- 不要求一开始就完美，但必须可讨论、可补充。
- Issue 不清楚时先标记 `needs-info`，不要直接进入开发。

### 谁应该提 PR

PR 通常由实际写代码的人提：

- 开发者自己实现，就自己提 PR。
- Pair programming 时，由主要提交代码的人提 PR。
- Agent 实现时，由 agent 或负责人提 PR。
- 紧急修复时，仍建议由修复者提 PR，除非团队明确允许直接推主干。

最佳实践：

- PR 作者负责让 PR 可 review、可验证、可合并。
- Reviewer 负责检查风险、正确性、可维护性和测试覆盖。
- Issue 创建者不一定是 PR 作者。

## 从哪个分支创建开发分支

这取决于团队采用的分支模型。

## 推荐一：Trunk-Based Development

现代 Web 服务、SaaS、内部系统、小团队通常推荐这种方式。

### 分支结构

```text
main
  ├── feature/123-login
  ├── fix/456-null-crash
  └── chore/789-upgrade-deps
```

### 规则

- `main` 永远保持可构建、可测试、可发布。
- 所有功能分支从最新 `main` 创建。
- PR 合并回 `main`。
- 通过 feature flag 控制未完成的大功能。
- 发布从 `main` 打 tag 或创建 release。

### 命令

```bash
git switch main
git pull --ff-only origin main
git switch -c feature/123-login
```

PR：

```bash
git push -u origin feature/123-login

gh pr create \
  --base main \
  --head feature/123-login \
  --title "Add login flow" \
  --body "Closes #123"
```

### 适合场景

- 团队希望快速集成
- CI 比较可靠
- 发布频率较高
- 能接受 feature flag
- 不想长期维护 `develop`

## 推荐二：Git Flow / develop 模式

有明确版本发布周期、移动端 App、桌面端 App、嵌入式、需要稳定发布分支的项目，常用 `develop`。

### 分支结构

```text
main        稳定发布分支
develop     日常集成分支
  ├── feature/123-login
  ├── fix/456-settings-crash
  └── chore/789-upgrade-deps
release/1.2.0
hotfix/1.2.1
```

### 规则

- `main` 只放已经发布或即将发布的稳定代码。
- `develop` 是日常开发集成分支。
- 功能分支从最新 `develop` 创建。
- 普通功能 PR 合并回 `develop`。
- 发布时从 `develop` 创建 `release/x.y.z`。
- 发布完成后合并到 `main` 并打 tag，同时回合到 `develop`。
- 线上紧急问题从 `main` 创建 `hotfix/x.y.z`，修复后合并回 `main` 和 `develop`。

### 命令

创建功能分支：

```bash
git switch develop
git pull --ff-only origin develop
git switch -c feature/123-login
```

创建 PR 到 `develop`：

```bash
git push -u origin feature/123-login

gh pr create \
  --base develop \
  --head feature/123-login \
  --title "Add login flow" \
  --body "Closes #123"
```

### 适合场景

- 桌面端、移动端、客户端软件
- 发布周期固定
- 需要发布候选版本
- 需要维护多个线上版本
- 团队希望 `main` 只代表稳定发布状态

## 到底用 main 还是 develop

没有绝对标准，按团队需要选。

优先选 `main` 的情况：

- 项目小或中等规模
- Web 服务或内部系统
- 可以频繁发布
- CI 稳定
- 团队希望流程简单

优先选 `develop` 的情况：

- 客户端软件、桌面软件、移动 App
- 发布需要签名、公证、审核或人工测试
- 发布周期明确
- `main` 必须长期代表生产稳定版本
- 团队需要 release 分支管理候选版本

如果不确定，建议：

- 小团队先用 `main`。
- 发布流程复杂后，再引入 `develop` 和 `release/*`。
- 不要为了“看起来专业”过早引入复杂分支模型。

## 一个 Issue 一条分支是否必须

不是强制，但通常推荐。

### 推荐一个 Issue 一条分支

原因：

- 变更范围清楚
- PR 更小，更容易 review
- 一个 PR 可以精确关闭一个 Issue
- 出问题时容易回滚
- 多人协作时不容易互相阻塞
- CI 和验收结果更明确

示例：

```text
Issue #123：新增登录流程
Branch：feature/123-login-flow
PR：Add login flow
PR body：Closes #123
```

### 什么时候可以一个 PR 关联多个 Issue

可以，但要谨慎：

- 多个 Issue 是同一个不可拆分改动
- 一个重构同时修复多个重复 Bug
- 发布 PR 汇总多个已完成分支

PR body 可以写：

```text
Closes #123
Closes #124
Fixes #130
```

### 什么时候一个 Issue 可以拆多个 PR

大 Issue 可以拆成多个 PR：

- 第一个 PR 建立骨架
- 第二个 PR 接入 UI
- 第三个 PR 补权限或错误处理

这种情况下不要每个 PR 都写 `Closes #123`，否则第一个合并就会关闭 Issue。

可以写：

```text
Part of #123
Refs #123
```

最后一个 PR 再写：

```text
Closes #123
```

## 标准开发流程

### 1. 创建或领取 Issue

Issue 至少包含：

- 背景
- 要实现的行为
- 验收标准
- 依赖关系
- 相关设计或截图

示例：

```markdown
## 背景

用户需要在设置页看到当前权限状态。

## 要做什么

显示麦克风权限和辅助功能权限，并提供打开系统设置的入口。

## 验收标准

- [ ] 已授权时显示“已开启”
- [ ] 未授权时显示“未开启”
- [ ] 点击修复入口可以打开对应系统设置
```

### 2. 创建分支

从团队约定的集成分支创建：

- trunk-based：从 `main`
- Git Flow：从 `develop`
- hotfix：从 `main`

命名建议：

```text
feature/123-permission-settings
fix/456-crash-on-launch
chore/789-upgrade-swift
docs/101-pr-guidelines
hotfix/102-login-timeout
```

### 3. 开发和提交

提交应当小而清楚：

```bash
git add -- .
git commit -m "Add permission status model (#123)"
```

提交信息建议包含 Issue 编号，但真正自动关闭 Issue 通常放在 PR body 中。

### 4. 推送分支

```bash
git push -u origin feature/123-permission-settings
```

### 5. 创建 PR

Trunk-based：

```bash
gh pr create \
  --base main \
  --head feature/123-permission-settings \
  --title "Add permission status settings" \
  --body "Closes #123"
```

Git Flow：

```bash
gh pr create \
  --base develop \
  --head feature/123-permission-settings \
  --title "Add permission status settings" \
  --body "Closes #123"
```

### 6. PR 描述模板

```markdown
## Summary

- 显示麦克风权限状态
- 显示辅助功能权限状态
- 增加打开系统设置的入口

## Verification

- [ ] 单元测试通过
- [ ] 手工验证未授权状态
- [ ] 手工验证已授权状态

Closes #123
```

### 7. Review 和修改

PR 作者负责：

- 回复 review comments
- 修复问题
- 补充测试
- 保持分支与目标分支不冲突

Reviewer 负责：

- 检查是否满足 Issue 验收标准
- 检查风险和边界情况
- 检查测试是否覆盖关键行为
- 避免把 review 变成个人风格争论

### 8. 合并 PR

合并方式由团队统一：

- Squash merge：推荐小团队和多数业务项目，历史干净
- Merge commit：保留完整分支历史
- Rebase merge：线性历史，但对团队 Git 熟练度要求更高

推荐默认：

```text
Squash merge
```

### 9. 合并后清理

```bash
git switch main
git pull --ff-only origin main
git branch -d feature/123-permission-settings
```

如果使用 `develop`：

```bash
git switch develop
git pull --ff-only origin develop
git branch -d feature/123-permission-settings
```

## Issue 和 PR 如何自动关联

GitHub/GitLab 会识别 PR 描述里的关键词。

关闭 Issue：

```text
Closes #123
Fixes #123
Resolves #123
```

只引用，不关闭：

```text
Refs #123
Related to #123
Part of #123
```

多个 Issue：

```text
Closes #123
Closes #124
Refs #130
```

最佳实践：

- 如果 PR 合并后 Issue 就完成，用 `Closes #123`。
- 如果 PR 只是部分实现，用 `Part of #123` 或 `Refs #123`。
- 不要在半成品 PR 中误写 `Closes`。

## 常见团队角色分工

### 产品经理

- 提出需求 Issue
- 补充业务背景和验收标准
- 验收功能是否符合预期

### 开发者

- 拆分技术任务
- 创建分支
- 实现代码
- 提交 PR
- 补充测试和验证说明

### Reviewer

- Review PR
- 关注正确性、风险、可维护性和测试
- 不负责替 PR 作者完成实现

### QA / 测试

- 提 Bug Issue
- 补充复现步骤
- 验证修复结果

### Tech Lead

- 维护分支策略
- 确认大 Issue 拆分方式
- 决定合并策略和发布策略

## 最佳实践清单

- Issue 先清楚，再开发。
- 分支从最新目标分支创建。
- 一个 PR 尽量解决一个 Issue。
- PR 要小，便于 review。
- PR 描述必须写验证方式。
- 使用 `Closes #编号` 自动关闭 Issue。
- 大 Issue 拆多个 PR 时，前几个 PR 用 `Refs` 或 `Part of`，最后一个 PR 才用 `Closes`。
- 不把格式化、重构、功能改动混在一个 PR，除非 Issue 本身就是重构。
- 不在功能分支长期堆积大量无关改动。
- 合并前保证 CI 通过。
- 合并后删除远端分支。

## 推荐默认规范

如果团队没有历史包袱，可以从下面这套开始：

```text
分支模型：trunk-based
默认集成分支：main
分支命名：feature/<issue-number>-<short-name>
PR 粒度：一个 PR 关闭一个 Issue
合并方式：Squash merge
Issue 关闭：PR body 写 Closes #<issue-number>
```

如果团队做客户端、桌面端、移动端或强发布周期产品：

```text
分支模型：develop + release
默认集成分支：develop
稳定发布分支：main
功能分支：从 develop 创建，PR 回 develop
发布分支：从 develop 创建 release/x.y.z
热修复分支：从 main 创建 hotfix/x.y.z
```
