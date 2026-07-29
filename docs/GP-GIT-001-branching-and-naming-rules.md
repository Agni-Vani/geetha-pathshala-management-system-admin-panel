# Gita Pathshala Project Git Rules

# Branching, Naming, and Staying Up to Date

**Document ID:** GP-GIT-001  
**Version:** 0.1  
**Status:** Active Team Rule  
**Audience:** All developers  

---

## 1. Purpose

This document defines the Git rules every developer must follow.

The goal is simple:

- Keep `develop` clean and working.
- Make every change easy to review.
- Avoid broken merges.
- Make branch names, commits, and pull requests predictable.
- Make sure developers are always working from the latest `develop`.

---

## 2. Main Branches

| Branch | Purpose | Who Can Push |
| --- | --- | --- |
| `main` | Production-ready code only | Maintainers only |
| `develop` | Latest accepted development code | Maintainers through pull requests |
| Work branches | Normal developer work | Individual developers |

Rules:

- Do not work directly on `main`.
- Do not work directly on `develop`.
- Always create a new branch from the latest `develop`.
- All work must go through a pull request.
- A branch should contain one focused change.

---

## 3. Branch Naming Rules

Branch names are **delivery-facing**.

This means a branch name is not only for users and not only for architecture. A branch name should tell developers, reviewers, and release maintainers:

- What kind of change is this?
- Which domain, module, or area does it affect?
- What should the reviewer expect inside the pull request?

Some branches describe user-visible features:

```bash
feature/student-admission
feature/task-date-filter
feature/attendance-approval
```

Some branches describe technical foundation work:

```bash
foundation/task-domain
foundation/supabase-auth-setup
foundation/attendance-rls-policies
```

Both are valid. The important thing is that the branch name clearly describes the reviewable unit of work.

Use this format:

```bash
<type>/<short-description>
```

Use lowercase letters.

Use hyphens between words.

Do not use spaces.

Do not use underscores.

Do not use long sentences.

### Allowed Branch Types

| Type | Use For | Example |
| --- | --- | --- |
| `feature` | New user-facing or system feature | `feature/student-admission-flow` |
| `foundation` | Domain, architecture, schema, or setup work needed before features | `foundation/task-domain` |
| `fix` | Bug fix | `fix/login-token-refresh` |
| `hotfix` | Urgent production fix | `hotfix/attendance-submit-crash` |
| `refactor` | Code restructuring without behavior change | `refactor/auth-repository-cleanup` |
| `docs` | Documentation only | `docs/git-branching-rules` |
| `test` | Test-only changes | `test/admission-service-tests` |
| `chore` | Maintenance, config, dependencies | `chore/update-flutter-packages` |
| `release` | Release preparation | `release/v1.0.0` |

Good examples:

```bash
foundation/task-domain
foundation/supabase-schema-setup
feature/pathshala-registry
feature/teacher-assignment
feature/task-date-filter
fix/attendance-record-duplicate
docs/api-design-update
refactor/supabase-auth-client
chore/add-lint-rules
```

Bad examples:

```bash
my-work
new_changes
Feature/Login
fix bug
studentAdmissionFlow
feature/filter_tasks_by_date
final-code
```

Why bad:

- They are unclear.
- They are inconsistent.
- They are hard to search.
- They do not tell reviewers what kind of work is inside.
- They use mixed casing, spaces, or underscores.

### How to Choose the Branch Type

Use `foundation` when the work creates a technical or domain base but does not yet deliver a complete user workflow.

Examples:

```bash
foundation/task-domain
foundation/admission-domain
foundation/supabase-auth-setup
foundation/attendance-table-design
```

Use `feature` when the work adds behavior that a user, admin, teacher, student, or system process can actually use.

Examples:

```bash
feature/task-crud
feature/task-date-filter
feature/student-admission-flow
feature/teacher-attendance-marking
```

Use `refactor` when the behavior should stay the same but the internal structure changes.

Examples:

```bash
refactor/task-repository
refactor/auth-state-management
refactor/attendance-service
```

Use `fix` when something is broken and the branch repairs it.

Examples:

```bash
fix/task-due-date-timezone
fix/admission-duplicate-person-search
fix/attendance-submit-double-tap
```

Decision rule:

If the branch prepares the system for a future feature, use `foundation`.

If the branch gives the user or system a usable behavior, use `feature`.

If the branch changes structure without changing behavior, use `refactor`.

If the branch repairs incorrect behavior, use `fix`.

### Domain Foundation Branches

Clean Architecture work often starts with the domain layer before UI, database calls, or full CRUD screens exist. This is normal and professional.

Use this naming pattern:

```bash
foundation/<domain>-domain
```

Examples:

```bash
foundation/task-domain
foundation/student-admission-domain
foundation/teacher-assignment-domain
foundation/attendance-domain
```

A domain foundation branch may include:

- Entity classes.
- Value objects.
- Enums.
- Repository contracts.
- Use case contracts or initial use cases.
- Failure/result types.
- Validation rules.
- Domain tests.

Example:

```text
Branch: foundation/task-domain

Expected work:
- Task entity
- TaskStatus enum
- TaskRepository interface
- CreateTaskUseCase
- UpdateTaskUseCase
- TaskFailure
- Basic task validation tests
```

Reasoning:

- This work is important, but it may not be user-visible yet.
- Calling it `feature/task` is too broad because it sounds like the whole task module.
- Calling it `feature/task-domain` is acceptable in some teams, but `foundation/task-domain` is clearer because it tells reviewers this pull request is architecture/domain groundwork.
- Later user-facing branches can build on this foundation.

Example follow-up branches:

```bash
feature/task-crud
feature/task-list
feature/task-date-filter
feature/task-status-filter
```

### Related Work Does Not Always Mean Same Branch

Do not keep all related work in one large branch.

Use one branch for one reviewable unit of work.

Example:

```bash
foundation/task-domain
feature/task-crud
feature/task-date-filter
feature/task-status-filter
```

These are all related to tasks, but they are different delivery units.

Use the same branch only when the new work is required to complete the current pull request.

Example:

If the original requirement is:

```text
Build task CRUD with date filtering.
```

Then this branch is acceptable:

```bash
feature/task-crud
```

If date filtering is requested later, use a separate branch:

```bash
feature/task-date-filter
```

Reasoning:

- Small branches are easier to review.
- Separate branches can be tested and merged independently.
- Delayed or changed requirements do not block unrelated completed work.
- Pull requests stay focused and understandable.
---

## 5. Staying Up to Date With `develop`

Developers must keep their branch updated with `develop`.

Do this at least once per working day, and always before opening a pull request.

### Option A: Merge `develop` into your branch

This is the safest and simplest option for most developers.

```bash
git checkout develop
git pull origin develop
git checkout feature/student-admission-flow
git merge develop
```

If there are conflicts:

1. Fix the conflict files.
2. Run the app/tests.
3. Add the fixed files.
4. Complete the merge.

```bash
git add .
git commit
```

### Option B: Rebase your branch on `develop`

Use this only if your team is comfortable with rebase.

```bash
git checkout develop
git pull origin develop
git checkout feature/student-admission-flow
git rebase develop
```

If there are conflicts:

```bash
git status
```

Fix the files, then run:

```bash
git add .
git rebase --continue
```

If you need to stop the rebase:

```bash
git rebase --abort
```

Important:

Do not rebase shared branches unless the team agrees. Rebasing rewrites commit history.

Recommended team default:

Use merge for normal feature branches.

---

## 6. Commit Message Rules

Use this format:

```bash
<type>: <short message>
```

Examples:

```bash
feature: add student admission form
fix: prevent duplicate attendance records
docs: add git branching guide
refactor: simplify auth repository
test: add teacher assignment tests
chore: update analysis options
```

Rules:

- Use present tense.
- Keep the first line short.
- Explain why in the commit body if the change is not obvious.
- Do not use vague messages.

Bad commit messages:

```bash
changes
final
work done
bug fixed
update code
```

Good commit with body:

```bash
git commit -m "fix: prevent duplicate attendance records" -m "Attendance records are unique per session and student enrollment. This prevents double submission when the teacher taps submit twice."
```

---

## 7. Pull Request Rules

Every branch must be merged through a pull request.

Before opening a pull request:

```bash
git checkout develop
git pull origin develop
git checkout feature/student-admission-flow
git merge develop
```

Then run checks:

```bash
flutter analyze
flutter test
```

If this is a web app, also run:

```bash
flutter build web
```

Push your branch:

```bash
git push origin feature/student-admission-flow
```

Open a pull request into:

```text
develop
```

Not into:

```text
main
```

### Pull Request Title

Use the same style as commits:

```text
feature: add student admission flow
fix: prevent duplicate attendance records
docs: add Git branching guide
```

### Pull Request Description

Use this template:

```markdown
## Summary

- What changed?
- Why was it needed?

## Testing

- [ ] Ran `flutter analyze`
- [ ] Ran `flutter test`
- [ ] Ran `flutter build web` if relevant

## Notes

Mention anything reviewers should know.
```

---

## 8. Review Rules

Reviewers must check:

- The branch is up to date with `develop`.
- The change is focused.
- The code follows project patterns.
- The UI works on required screen sizes.
- Supabase access is secure and does not bypass RLS.
- Tests or manual verification are included.
- No secrets are committed.
- No generated build files are committed unless required.

Developers must not merge their own pull request unless the team explicitly allows it.

---

## 9. Conflict Rules

When Git shows conflicts, do not guess.

Run:

```bash
git status
```

Open each conflict file and look for:

```text
<<<<<<< HEAD
your branch changes
=======
develop branch changes
>>>>>>> develop
```

Choose the correct final code.

Then remove the conflict markers.

After fixing:

```bash
git add .
git commit
```

Then run:

```bash
flutter analyze
flutter test
```

Rule:

Never commit conflict markers.

---

## 10. Keeping Work Small

A pull request should normally be small enough to review in 15 to 30 minutes.

Good pull requests:

- Add one feature.
- Fix one bug.
- Refactor one area.
- Update one document.

Bad pull requests:

- Mix feature work, formatting, refactoring, and bug fixes.
- Change many unrelated files.
- Include temporary debugging code.
- Include commented-out old code.

Examples:

Good:

```text
feature: add Pathshala list screen
```

Bad:

```text
feature: add Pathshala list, update auth, refactor theme, fix attendance, change docs
```

---

## 11. Protected Files and Sensitive Data

Never commit:

- `.env`
- Supabase service role keys
- Private API keys
- Local passwords
- Local database dumps with real data
- Personal test files
- Build output folders unless the project specifically requires them

Before committing, check:

```bash
git status
git diff
```

If a secret was committed, tell the team immediately. Do not only delete it in a later commit. The secret must be rotated.

---

## 12. Recommended Daily Workflow

Start your day:

```bash
git checkout develop
git pull origin develop
```

Create or continue your branch:

```bash
git checkout feature/student-admission-flow
git merge develop
```

Work normally.

Check your changes:

```bash
git status
git diff
```

Commit:

```bash
git add .
git commit -m "feature: add student admission form"
```

Push:

```bash
git push origin feature/student-admission-flow
```

Before pull request:

```bash
git checkout develop
git pull origin develop
git checkout feature/student-admission-flow
git merge develop
flutter analyze
flutter test
git push origin feature/student-admission-flow
```

---

## 13. Complete Example

Task:

Add student admission flow.

Commands:

```bash
git checkout develop
git pull origin develop
git checkout -b feature/student-admission-flow
```

After coding:

```bash
flutter analyze
flutter test
git status
git diff
git add .
git commit -m "feature: add student admission flow"
git push origin feature/student-admission-flow
```

Before opening PR:

```bash
git checkout develop
git pull origin develop
git checkout feature/student-admission-flow
git merge develop
flutter analyze
flutter test
git push origin feature/student-admission-flow
```

Open PR:

```text
feature/student-admission-flow -> develop
```

---

## 14. Agent-Assisted Development Rules

AI-assisted or agent-assisted code must follow the same Git rules as human-written code.

The branch, commit, and pull request should describe the work, not the tool that helped create it.

Rules:

- Do not use any agent name in branch names.
- Do not use any agent prefix in branch names.
- Do not use any agent name in commit messages.
- Do not use any agent name in pull request titles.
- Do not create separate branch naming rules for agent-assisted work.
- Use the same branch types already defined in this document.

Correct examples:

```bash
foundation/task-domain
feature/task-date-filter
fix/attendance-submit-double-tap
docs/git-branching-rules
```

Correct commit messages:

```bash
docs: update branching rules
feature: add task date filter
fix: prevent duplicate attendance submit
foundation: add task domain model
```

Reasoning:

- The repository history should describe product and engineering changes, not which tool created them.
- Reviewers care about the change, scope, risk, and tests.
- Agent-specific prefixes make branch history inconsistent.
- Agent-specific names can confuse ownership and long-term maintenance.
- The team should be able to read Git history without knowing how the work was produced.

If an AI agent helps with a change, mention that only in team communication when useful. Do not encode it into branch names, commit messages, or pull request titles.

---

## 15. Final Rules

Every developer must follow these rules:

- Start from latest `develop`.
- Work on a named branch.
- Do not use agent names or agent prefixes in branches, commits, or pull request titles.
- Keep the branch focused.
- Use clear commit messages.
- Update from `develop` before opening a pull request.
- Run checks before requesting review.
- Merge only through pull requests.
- Never commit secrets.
- Never rewrite shared history without team agreement.

When unsure, ask before pushing.

