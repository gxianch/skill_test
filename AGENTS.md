# 用户偏好

## 语言

- 母语：中文
- 默认使用中文进行交流和回复

## Agent skills

### Issue tracker

Issue 使用 GitHub Issues 跟踪，仓库为 `gxianch/skill_test`。见 `docs/agents/issue-tracker.md`。

### Triage labels

使用默认五类 triage 标签：`needs-triage`、`needs-info`、`ready-for-agent`、`ready-for-human` 和 `wontfix`。见 `docs/agents/triage-labels.md`。

### Domain docs

这是单上下文仓库。若存在根目录 `CONTEXT.md` 和 `docs/adr/`，需要在相关任务前读取。见 `docs/agents/domain.md`。

## 开发流程

- 实现 GitHub Issue 时遵循 `docs/process/issue-workflow.md`。
- 默认一个 issue 一条分支；完成当前 issue 的提交、推送和 PR 后，再从最新 `main` 开始下一个 issue。
- 使用 TDD 时按纵向切片推进：一条行为测试进入 RED，再写最小实现进入 GREEN，循环到验收标准满足。
