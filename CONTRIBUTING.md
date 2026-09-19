# Contributing Guide

## Branch Model

| Branch | Purpose | Who merges into it |
|--------|---------|--------------------|
| `main` | Stable code, updated once per sprint | Track leads via PR, approved by the team leader |
| `front-develop` | Frontend (Angular) integration | Frontend team via PR |
| `back-develop` | Backend (.NET) integration | Backend team via PR |
| `mobile-develop` | Mobile (Flutter) integration | Mobile team via PR |
| `ai-develop` | AI integration | AI team via PR |

```
feature/CU-xxxx-task  ->  PR  ->  <area>-develop  ->  (end of sprint, by the track lead)  ->  main
```

### Rules
- **Never create a branch from `main`.** Always branch from your area's develop branch.
- **Never open a task PR into `main`.** Your PR must target your area's develop branch.
- Direct pushes to `main` and to the develop branches are not allowed.
- **Never delete the develop branches**, even after merging them into `main`.

### Task branches
Create your branch from your area's develop branch and name it with the ClickUp task ID:
- `feature/CU-<task-id>-short-name`, e.g. `feature/CU-86abc12-login-page`
- `fix/CU-<task-id>-short-name`

```bash
git checkout front-develop
git pull
git checkout -b feature/CU-86abc12-login-page
```

> Including the ClickUp task ID (`CU-xxxx`) in the branch name or PR title links them automatically when the GitHub integration is enabled.

## Commits
Keep messages short and clear, and add the area in parentheses: `backend`, `frontend`, `mobile`, `ai`, or `docs`.

- `feat(backend): add order creation endpoint`
- `fix(frontend): correct total price display`
- `docs: update ERD`

## Pull Requests
1. Push your branch and open a PR **into your area's develop branch** (check the base branch before creating it).
2. Fill in the PR template.
3. Required reviewers before merging: Backend 2, Frontend 2, Mobile 1, AI 0.
4. Delete your task branch after merging.

## End of Sprint
Each track has a **track lead** who merges their track into `main`. Track leads are listed in the README.

1. Make sure all the sprint's tasks of your track are merged into your develop branch.
2. Bring `main` into your develop branch and fix any conflicts there, on your own branch:
   ```bash
   git checkout front-develop
   git pull
   git merge main
   git push
   ```
3. Open a PR from your develop branch (e.g. `front-develop`) into `main`.
4. Ask the team leader to approve it.
5. Merge using **Create a merge commit** (do not squash), so the branches do not diverge.
6. **Do not** click "Delete branch" after the merge. Develop branches are permanent.

### After merging into `main`
At the start of the next sprint, each track lead brings `main` back into their develop branch, so it includes the other tracks' work:

```bash
git checkout front-develop
git pull
git merge main
git push
```

Each track works in its own folder, so conflicts should be rare. Avoid editing shared files (`README.md`, `CONTRIBUTING.md`, `docs/`, `.github/`) inside a track branch unless you agreed on it with the team leader.

## Sprint Workflow
Sprint length may change from sprint to sprint. ClickUp statuses:

| Status | When |
|--------|------|
| To Do | Task is planned for the sprint |
| In Progress | You started working on it |
| In Review | You opened a PR |
| Done | The PR is merged into your develop branch |

Only pick tasks from the current sprint.

## Secrets and Configuration
- **Never** commit `.env` files, connection strings, passwords, or API keys.
- Do not put the SQL Server connection string in `appsettings*.json`. Use a local `.env` file (see `backend/.env.example`) or `dotnet user-secrets`.
- If new environment variables are needed, add them to the relevant `.env.example` with empty values.
