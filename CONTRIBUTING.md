# Contributing Guide

## Branch Model

| Branch | Purpose | Who merges into it |
|--------|---------|--------------------|
| `main` | Stable code, updated once per sprint | Team leader only |
| `front-develop` | Frontend (Angular) integration | Frontend team via PR |
| `back-develop` | Backend (.NET) integration | Backend team via PR |
| `mobile-develop` | Mobile (Flutter) integration | Mobile team via PR |
| `ai-develop` | AI integration | AI team via PR |

```
feature/CU-xxxx-task  ->  PR  ->  <area>-develop  ->  (end of sprint, by the leader)  ->  main
```

### Rules
- **Never create a branch from `main`.** Always branch from your area's develop branch.
- **Never open a PR into `main`.** Your PR must target your area's develop branch.
- Direct pushes to `main` and to the develop branches are not allowed.

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
3. At least one teammate from your area must review before merging.
4. Delete the branch after merging.

## End of Sprint (team leader)
1. Open a PR from each develop branch into `main`.
2. Merge using **Create a merge commit** (do not squash), so the branches do not diverge.
3. After merging, bring `main` back into each develop branch:
   ```bash
   git checkout front-develop
   git pull
   git merge main
   git push
   ```
   Repeat for `back-develop`, `mobile-develop`, and `ai-develop`.

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
