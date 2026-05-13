# Issue 开发流程

本仓库使用 GitHub Issues 管理需求和实现任务。默认流程是一个 issue 一条分支，一个 PR 关闭一个 issue。

## 标准流程

1. 确认要实现的 issue
   - 读取 GitHub Issue 的正文、验收标准和依赖关系。
   - 确认该 issue 没有未完成 blocker。
   - 不在同一个分支里混做多个无关 issue。

2. 从最新 `main` 创建分支
   - 切回 `main`。
   - 拉取远端最新代码。
   - 创建 issue 分支。

   示例：

   ```bash
   git switch main
   git pull --ff-only origin main
   git switch -c issue-2-app-skeleton
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
   - 创建 PR 指向 `main`。
   - PR 正文写明关闭的 issue、变更摘要和验证结果。

   示例：

   ```bash
   git push -u origin issue-2-app-skeleton
   gh pr create --base main --head issue-2-app-skeleton \
     --title "Implement menu bar app skeleton" \
     --body "Closes #2"
   ```

7. 合并后再开始下一个 issue
   - PR 合并后切回 `main`。
   - 拉取最新 `main`。
   - 再从最新 `main` 创建下一个 issue 分支。

## 标签约定

- `ready-for-agent`：规格清楚，可以由 agent 独立实现。
- `ready-for-human`：需要人工参与，例如证书、账号、发布决策。

## 当前项目注意事项

- 当前机器只有 Command Line Tools，没有完整 Xcode 时，`swift test` 可能因 XCTest 路径缺失不可用。
- 在这种环境下，可以使用不依赖 XCTest 的行为测试目标作为临时验证入口。
- 完整 Xcode 可用后，应继续保留 XCTest 测试，并优先使用 `swift test` 或 Xcode test action 验证。
