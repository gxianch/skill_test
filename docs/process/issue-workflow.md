# Issue 开发流程

本仓库使用 GitHub Issues 管理需求和实现任务，并采用 Git Flow / `develop` 模式。

默认流程是一个 issue 一条分支，一个 PR 关闭一个 issue。普通功能和修复分支从最新 `develop` 创建，PR 合回 `develop`。`main` 只代表稳定发布线。

## 分支模型

```text
main        稳定发布分支
develop     日常集成分支
  ├── feature/<issue-number>-<short-name>
  ├── fix/<issue-number>-<short-name>
  ├── chore/<issue-number>-<short-name>
  └── docs/<issue-number>-<short-name>
release/<version>
hotfix/<version>
```

规则：

- 普通功能、修复、文档、技术任务都从 `develop` 创建分支。
- 普通 PR 默认合回 `develop`。
- GitHub 仓库默认分支设置为 `develop`，这样 PR 合入 `develop` 时，`Closes #<issue-number>` 可以自动关闭对应 Issue。
- `main` 不直接承接日常功能 PR，只用于稳定发布。
- 发布时从 `develop` 创建 `release/<version>`，验收后合入 `main` 并打 tag，同时回合到 `develop`。
- 线上紧急修复从 `main` 创建 `hotfix/<version>`，修复后合入 `main` 和 `develop`。

## 标准流程

1. 确认要实现的 issue
   - 读取 GitHub Issue 的正文、验收标准和依赖关系。
   - 确认该 issue 没有未完成 blocker。
   - 不在同一个分支里混做多个无关 issue。

2. 从最新 `develop` 创建分支
   - 切回 `develop`。
   - 拉取远端最新代码。
   - 创建 issue 分支。

   示例：

   ```bash
   git switch develop
   git pull --ff-only origin develop
   git switch -c feature/3-permission-onboarding
   ```

3. 按 TDD 实现
   - RED：写一条描述外部行为的测试，让它失败。
   - GREEN：写刚好足够的实现，让测试通过。
   - 重复 RED/GREEN，直到该 issue 的验收标准满足。
   - 测试应验证公开接口和用户可观察行为，不绑定私有实现细节。

4. 本地验证
   - 跑该 issue 相关的行为测试和构建命令。
   - 记录无法运行的验证项和原因。
   - 不把 `.build/` 等构建产物提交进仓库。

5. 提交
   - 提交只包含当前 issue 的相关改动。
   - commit message 关联 issue 编号。

   示例：

   ```bash
   git add -- .
   git commit -m "Implement menu bar app skeleton (#2)"
   ```

6. 推送并创建 PR
   - 推送当前 issue 分支。
   - 创建 PR 指向 `develop`。
   - PR 正文写明关闭的 issue、变更摘要和验证结果。

   示例：

   ```bash
   git push -u origin feature/3-permission-onboarding
   gh pr create --base develop --head feature/3-permission-onboarding \
     --title "Add permission onboarding" \
     --body "Closes #3"
   ```

7. 合并后再开始下一个 issue
   - PR 合并后切回 `develop`。
   - 拉取最新 `develop`。
   - 再从最新 `develop` 创建下一个 issue 分支。

   示例：

   ```bash
   git switch develop
   git pull --ff-only origin develop
   git switch -c feature/4-right-option-event-tap
   ```

## 标签约定

- `ready-for-agent`：规格清楚，可以由 agent 独立实现。
- `ready-for-human`：需要人工参与，例如证书、账号、发布决策。

## 当前项目注意事项

- 当前机器只有 Command Line Tools，没有完整 Xcode 时，`swift test` 可能因 XCTest 路径缺失不可用。
- 在这种环境下，可以使用不依赖 XCTest 的行为测试目标作为临时验证入口。
- 完整 Xcode 可用后，应继续保留 XCTest 测试，并优先使用 `swift test` 或 Xcode test action 验证。
