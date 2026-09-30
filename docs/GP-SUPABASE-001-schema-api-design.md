# Gita Pathshala Management Platform

# Supabase Database and API Design

**Document ID:** GP-SUPABASE-001  
**Version:** 0.1  
**Status:** Draft  
**Date:** 2026-07-29  
**Prepared For:** Product, Flutter, Backend, QA, and Implementation Teams  
**Source Foundation:** GP-VAP-001 Product Vision and Architecture Principles

---

## 1. Design Intent

This design uses Supabase as the backend platform, PostgreSQL as the system of record, Supabase Auth for authentication, Row Level Security for data access control, PostgreSQL functions for transactional domain workflows, and Edge Functions only when the workflow needs server-only logic, external integrations, webhooks, or orchestration that should not live in the database.

The design follows the foundation principles:

| Principle | Database and API Consequence |
| --- | --- |
| Govern Centrally. Operate Locally. | Every operational record is scoped to organization and usually Pathshala. |
| One Person. One Identity. Many Journeys. | `people` is the root human registry. Student, teacher, admin, and committee are linked journeys, not duplicate persons. |
| Registration is Not Admission. | `people` and `student_admissions` are separate tables and separate workflows. |
| Teacher Profile is Not Teacher Assignment. | `teacher_profiles` stores teacher eligibility; `teacher_assignments` stores local teaching work. |
| Registries Store Truth. Operational Records Store Activities. | Registry tables are stable; operational tables hold lifecycle and activity history. |
| History Should Never Be Destroyed. | Business tables use statuses, effective dates, events, and correction workflows instead of destructive overwrites. |
| Authorization Must Be Explicit. | Effective access is calculated from role, permission, scope, and approved overrides. |

---

## 2. Supabase Architecture Decisions

### Decision 1: Use Supabase Auth only for authentication, not as the full identity model

`auth.users` identifies login accounts. It should not be treated as the person registry because many people, especially young students, may exist without login access.

Application identity lives in `iam.user_accounts`, linked one-to-one to `registry.people`.

Reasoning:

- A person can be registered before they need an account.
- Account suspension must not delete or damage person history.
- The same person may later receive login access without creating a second human record.
- Supabase Auth remains cleanly responsible for sign-in, passwordless auth, tokens, and session lifecycle.

### Decision 2: Use PostgreSQL schemas to express module boundaries

Recommended schemas:

| Schema | Purpose | Exposed to Supabase API |
| --- | --- | --- |
| `registry` | Authoritative master data: people, Pathshalas, committees | Yes, with strict RLS |
| `iam` | Roles, permissions, scopes, user accounts | Partially. Admin views/functions only |
| `education` | Admissions, groups, schedules, assignments, attendance | Yes, with strict RLS |
| `communication` | Notices, targets, read receipts | Yes, with strict RLS |
| `audit` | Audit events and immutable logs | No direct client write access |
| `reporting` | Views/materialized views for dashboards | Yes, read-only with RLS/security invoker |

Reasoning:

- Supabase can expose selected schemas through its API settings.
- Schema separation keeps the modular-monolith boundary visible from day one.
- Internal tables such as audit logs can remain unexposed to normal clients.

### Decision 3: Use direct Supabase table access for simple reads, but RPC/Edge Functions for business workflows

Flutter clients may read RLS-protected tables and views directly where the operation is simple. Business actions should use RPC or Edge Functions.

Use RPC for:

- Create person with duplicate checks.
- Admit student.
- Transfer student.
- Create teacher assignment with conflict checks.
- Open, submit, approve, and correct attendance.
- Grant role or permission override.

Use Edge Functions for:

- Invitations and account provisioning.
- Push notifications.
- Scheduled jobs.
- Integrations with SMS/email/payment providers.
- Workflows requiring service-role access and external calls.

Reasoning:

- Multi-step client-side writes are fragile and easy to partially complete.
- Domain workflows need transactions, validation, audit, and consistent authorization.
- RLS protects rows, but it does not replace workflow-level rules.

### Decision 4: Deny by default with RLS

Every table in an exposed schema must have RLS enabled. Policies should call stable helper functions such as:

```sql
iam.has_permission(permission_code text, scope_type text, scope_id uuid)
iam.can_access_pathshala(pathshala_id uuid)
iam.current_person_id()
```

Reasoning:

- Flutter web and mobile clients are public clients.
- The anon key is not a secret.
- Database-enforced authorization protects the system even if a frontend bug exposes an action.
- Permission logic must be centralized and explainable.

---

## 3. Core Enumerations

Use PostgreSQL enum types only for stable, low-cardinality values. Use lookup tables when business users may manage the list.

Recommended enum types:

```sql
person_status: active, inactive, merged, deceased, archived
account_status: invited, active, suspended, disabled
pathshala_status: draft, active, paused, closed, archived
admission_status: pending, active, transferred, completed, withdrawn, cancelled
teacher_status: pending, approved, suspended, retired, archived
assignment_status: planned, active, ended, cancelled
attendance_session_status: draft, open, submitted, approved, corrected, cancelled
attendance_mark: present, absent, late, excused
notice_status: draft, published, archived
scope_type: organization, pathshala, committee, self
override_effect: allow, deny
```

Reasoning:

- Status values drive lifecycle behavior and reporting.
- Enum values prevent accidental spelling differences.
- Business-adjustable classifications, such as class level names, should be normal tables instead.

---

## 4. Registry Tables

### `registry.organizations`

Central governing organization table. Initial release may have exactly one row.

| Column | Type | Notes |
| --- | --- | --- |
| `id` | uuid pk | Generated by database |
| `official_name` | text | Legal or approved organization name |
| `display_name` | text | UI-friendly name |
| `status` | text/enum | Usually active |
| `created_at`, `updated_at` | timestamptz | Audit metadata |

Decision:

Include `organization_id` even though the product may initially operate under one central organization.

Reasoning:

- Low cost now, high value later if multi-tenant or regional governance is needed.
- Makes reporting and RLS functions consistent.
- Allows future sandbox/demo organizations without redesign.

### `registry.people`

Root human identity.

| Column | Type | Notes |
| --- | --- | --- |
| `id` | uuid pk | Person ID |
| `organization_id` | uuid fk | Owning governing organization |
| `legal_name` | text | Required where known |
| `preferred_name` | text nullable | Display name |
| `date_of_birth` | date nullable | Needed for duplicate detection but may be unavailable |
| `gender` | text nullable | Optional and policy-driven |
| `primary_phone` | text nullable | Normalized format where possible |
| `primary_email` | text nullable | Lowercase normalized |
| `status` | person_status | Default active |
| `created_by_user_id` | uuid | References `iam.user_accounts` |
| `created_at`, `updated_at` | timestamptz | Metadata |

Indexes:

- `(organization_id, lower(legal_name))`
- `(organization_id, date_of_birth)`
- `(organization_id, primary_phone)`
- `(organization_id, primary_email)`

Decision:

Do not enforce global uniqueness on name, phone, or email.

Reasoning:

- Families may share phone/email.
- Names are not unique.
- Some students may not have direct contact details.
- Duplicate prevention should use search and review workflows, not naive unique constraints.

### `registry.person_contacts`

Multiple contact methods and emergency contacts for a person.

| Column | Type | Notes |
| --- | --- | --- |
| `id` | uuid pk | Contact ID |
| `person_id` | uuid fk | Owner person |
| `contact_type` | text | phone, email, address, emergency |
| `label` | text | home, father, mother, guardian |
| `value` | text | Phone/email/address line |
| `is_primary` | boolean | One primary per type enforced by partial unique index if needed |
| `verified_at` | timestamptz nullable | Verification timestamp |

Decision:

Keep contacts separate from `people` while retaining primary fields on `people`.

Reasoning:

- Primary fields support search performance and common UI.
- Separate contacts support real family/emergency structures without bloating the person table.

### `registry.person_relationships`

Guardian, parent, sibling, and family relationships.

| Column | Type | Notes |
| --- | --- | --- |
| `id` | uuid pk | Relationship ID |
| `person_id` | uuid fk | Subject person |
| `related_person_id` | uuid fk | Related person |
| `relationship_type` | text | parent, guardian, sibling, spouse, other |
| `is_primary_guardian` | boolean | Useful for students |
| `effective_from`, `effective_to` | date | Historical support |

Decision:

Model guardians as people when possible, not as unstructured text only.

Reasoning:

- A guardian may also be a committee member, teacher, admin, or parent of multiple students.
- This preserves the person-centric model.

### `registry.pathshalas`

Authoritative Pathshala registry.

| Column | Type | Notes |
| --- | --- | --- |
| `id` | uuid pk | Pathshala ID |
| `organization_id` | uuid fk | Governing organization |
| `code` | text | Unique within organization |
| `name` | text | Official name |
| `status` | pathshala_status | draft/active/paused/closed |
| `address_line1`, `address_line2`, `city`, `region`, `country`, `postal_code` | text | Structured address |
| `latitude`, `longitude` | numeric nullable | Optional mapping/reporting |
| `started_on` | date nullable | Historical context |
| `closed_on` | date nullable | Required if status closed |
| `created_at`, `updated_at` | timestamptz | Metadata |

Constraints:

- unique `(organization_id, code)`

Decision:

Never delete a Pathshala after operational use. Change status instead.

Reasoning:

- Admissions, attendance, assignments, notices, and reports must remain historically meaningful.

### `registry.committees`

Governance committees or local committees.

| Column | Type | Notes |
| --- | --- | --- |
| `id` | uuid pk | Committee ID |
| `organization_id` | uuid fk | Organization |
| `pathshala_id` | uuid nullable | Null for central committees |
| `name` | text | Committee name |
| `committee_type` | text | central, pathshala, advisory |
| `status` | text | active/inactive |

### `registry.committee_memberships`

Person participation in committees.

| Column | Type | Notes |
| --- | --- | --- |
| `id` | uuid pk | Membership ID |
| `committee_id` | uuid fk | Committee |
| `person_id` | uuid fk | Member |
| `title` | text | Chair, secretary, member |
| `effective_from`, `effective_to` | date | History |
| `status` | text | active/ended |

Decision:

Committee membership is a governance journey, not a login role by itself.

Reasoning:

- A committee member may or may not need portal access.
- Visibility permissions should be granted through IAM scope, not implied only by membership.

---

## 5. IAM Tables

### `iam.user_accounts`

Application account linked to Supabase Auth.

| Column | Type | Notes |
| --- | --- | --- |
| `id` | uuid pk | Same value as `auth.users.id` |
| `person_id` | uuid unique fk | One active account per person |
| `status` | account_status | invited/active/suspended/disabled |
| `invited_by_user_id` | uuid nullable | Audit |
| `invited_at`, `activated_at`, `disabled_at` | timestamptz nullable | Lifecycle |
| `created_at`, `updated_at` | timestamptz | Metadata |

Decision:

Use `auth.users.id` as `iam.user_accounts.id`.

Reasoning:

- RLS can use `(select auth.uid())` directly.
- There is no mapping ambiguity between Supabase sessions and application accounts.

### `iam.roles`

Named responsibility bundles.

Initial roles:

- `super_admin`
- `operations_member`
- `pathshala_admin`
- `committee_member`
- `teacher`
- `student`

Columns:

| Column | Type | Notes |
| --- | --- | --- |
| `id` | uuid pk | Role ID |
| `code` | text unique | Machine code |
| `name` | text | Display name |
| `description` | text | Governance explanation |
| `is_system_role` | boolean | Protect built-in roles |

Decision:

Roles should be few and understandable.

Reasoning:

- Over-fragmented roles become unmanageable.
- Fine-grained access belongs in permissions and scopes.

### `iam.permissions`

Atomic action permissions.

Example permission codes:

| Module | Permission Codes |
| --- | --- |
| People | `people.read`, `people.create`, `people.update`, `people.merge`, `people.view_sensitive` |
| Pathshalas | `pathshala.read`, `pathshala.create`, `pathshala.update`, `pathshala.close` |
| Admissions | `admission.read`, `admission.create`, `admission.transfer`, `admission.complete`, `admission.withdraw`, `admission.correct` |
| Teachers | `teacher_profile.read`, `teacher_profile.approve`, `teacher_assignment.create`, `teacher_assignment.end` |
| Attendance | `attendance.read`, `attendance.open`, `attendance.mark`, `attendance.submit`, `attendance.approve`, `attendance.correct` |
| Notices | `notice.read`, `notice.publish`, `notice.archive` |
| IAM | `iam.read`, `iam.assign_role`, `iam.override_permission` |
| Reports | `reports.local.read`, `reports.organization.read` |

### `iam.role_permissions`

Many-to-many grant table.

| Column | Type | Notes |
| --- | --- | --- |
| `role_id` | uuid fk | Role |
| `permission_id` | uuid fk | Permission |

Primary key: `(role_id, permission_id)`

### `iam.role_assignments`

Assigns a role to an account within a scope.

| Column | Type | Notes |
| --- | --- | --- |
| `id` | uuid pk | Assignment ID |
| `user_account_id` | uuid fk | Login account |
| `role_id` | uuid fk | Role |
| `scope_type` | scope_type | organization/pathshala/committee/self |
| `scope_id` | uuid nullable | Null only when scope is self and derived, or organization if there is one org |
| `effective_from`, `effective_to` | timestamptz | Lifecycle |
| `status` | text | active/ended/revoked |
| `granted_by_user_id` | uuid | Audit |
| `grant_reason` | text | Governance reason |

Constraints:

- No overlapping active role assignment for the same user, role, scope type, and scope ID.

Decision:

Scope is stored on assignment, not hard-coded into role.

Reasoning:

- The same Pathshala Admin role can apply to one or multiple Pathshalas.
- Operations members can have organization scope without inventing separate role variants.

### `iam.permission_overrides`

Approved exceptions.

| Column | Type | Notes |
| --- | --- | --- |
| `id` | uuid pk | Override ID |
| `user_account_id` | uuid fk | Grantee |
| `permission_id` | uuid fk | Permission |
| `effect` | override_effect | allow or deny |
| `scope_type` | scope_type | Boundary |
| `scope_id` | uuid nullable | Boundary ID |
| `effective_from`, `effective_to` | timestamptz | Must expire unless permanent approval is explicit |
| `reason` | text | Required |
| `approved_by_user_id` | uuid | Required |
| `status` | text | active/revoked/expired |

Decision:

Allow overrides, but require reason, approver, scope, and audit.

Reasoning:

- Real organizations need exceptions.
- Exceptions are dangerous if invisible or permanent by accident.

---

## 6. Education Tables

### `education.academic_years`

| Column | Type | Notes |
| --- | --- | --- |
| `id` | uuid pk | Academic year ID |
| `organization_id` | uuid fk | Organization |
| `name` | text | Example: 2026 |
| `starts_on`, `ends_on` | date | Reporting range |
| `status` | text | planned/active/closed |

### `education.class_levels`

Governed class/level taxonomy.

| Column | Type | Notes |
| --- | --- | --- |
| `id` | uuid pk | Level ID |
| `organization_id` | uuid fk | Organization |
| `code` | text | Unique code |
| `name` | text | Display name |
| `sort_order` | integer | UI/reporting order |
| `status` | text | active/inactive |

Decision:

Class levels are lookup rows, not enums.

Reasoning:

- The organization may rename, add, or reorder levels.
- This is domain policy, not database infrastructure.

### `education.student_admissions`

Connects a person to a Pathshala as a student for a lifecycle period.

| Column | Type | Notes |
| --- | --- | --- |
| `id` | uuid pk | Admission ID |
| `organization_id` | uuid fk | Organization |
| `person_id` | uuid fk | Student person |
| `pathshala_id` | uuid fk | Responsible Pathshala |
| `admission_number` | text | Unique within Pathshala or organization policy |
| `admitted_on` | date | Effective start |
| `ended_on` | date nullable | Effective end |
| `status` | admission_status | Current lifecycle state |
| `previous_admission_id` | uuid nullable | For transfer continuity |
| `created_by_user_id` | uuid | Audit |
| `created_at`, `updated_at` | timestamptz | Metadata |

Constraints:

- unique `(pathshala_id, admission_number)`
- partial unique active admission per person/pathshala: `(person_id, pathshala_id) where status = 'active'`

Decision:

Do not enforce one active admission per person across the whole organization until policy confirms it.

Reasoning:

- Some organizations may allow concurrent learning participation.
- If policy later requires one active admission globally, add a partial unique index on `(organization_id, person_id) where status = 'active'`.

### `education.student_admission_events`

Immutable lifecycle event log for admissions.

| Column | Type | Notes |
| --- | --- | --- |
| `id` | uuid pk | Event ID |
| `admission_id` | uuid fk | Admission |
| `event_type` | text | admitted, transferred_out, completed, withdrawn, corrected |
| `effective_on` | date | Business date |
| `reason` | text nullable | Required for sensitive events |
| `metadata` | jsonb | Structured details |
| `created_by_user_id` | uuid | Actor |
| `created_at` | timestamptz | Event time |

Decision:

Use event records in addition to current status.

Reasoning:

- Status answers current-state questions quickly.
- Events preserve the story of how the status changed.

### `education.student_transfers`

Explicit transfer workflow.

| Column | Type | Notes |
| --- | --- | --- |
| `id` | uuid pk | Transfer ID |
| `person_id` | uuid fk | Student person |
| `from_admission_id` | uuid fk | Current or previous admission |
| `to_pathshala_id` | uuid fk | Destination |
| `to_admission_id` | uuid nullable | Created when approved/completed |
| `requested_by_user_id` | uuid | Actor |
| `approved_by_user_id` | uuid nullable | Central/local approval |
| `requested_at`, `approved_at`, `completed_at` | timestamptz nullable | Workflow dates |
| `status` | text | requested/approved/completed/rejected/cancelled |
| `reason` | text nullable | Transfer reason |

### `education.learning_groups`

Class/batch/group within a Pathshala.

| Column | Type | Notes |
| --- | --- | --- |
| `id` | uuid pk | Group ID |
| `organization_id` | uuid fk | Organization |
| `pathshala_id` | uuid fk | Pathshala |
| `academic_year_id` | uuid fk | Academic year |
| `class_level_id` | uuid fk | Level |
| `name` | text | Example: Level 1 Saturday A |
| `status` | text | planned/active/closed |

Decision:

Use `learning_groups` between admission and attendance.

Reasoning:

- Admission answers "which Pathshala is responsible for the student."
- Learning group answers "which class/batch is the student currently attending."
- This prevents class movement from corrupting admission history.

### `education.group_enrollments`

Places admitted students into a learning group.

| Column | Type | Notes |
| --- | --- | --- |
| `id` | uuid pk | Enrollment ID |
| `admission_id` | uuid fk | Student admission |
| `learning_group_id` | uuid fk | Group |
| `effective_from`, `effective_to` | date | History |
| `status` | text | active/ended |

### `education.teacher_profiles`

Approved teacher journey attached to a person.

| Column | Type | Notes |
| --- | --- | --- |
| `id` | uuid pk | Teacher profile ID |
| `organization_id` | uuid fk | Organization |
| `person_id` | uuid unique fk | Teacher person |
| `status` | teacher_status | pending/approved/suspended/retired |
| `approved_by_user_id` | uuid nullable | Approver |
| `approved_at` | timestamptz nullable | Approval time |
| `skills` | jsonb | Optional tags/capabilities |
| `notes` | text nullable | Internal notes |

Decision:

One teacher profile per person per organization.

Reasoning:

- Teacher identity/eligibility is stable.
- Local teaching work belongs in assignments.

### `education.teacher_assignments`

Where, what, and when a teacher teaches.

| Column | Type | Notes |
| --- | --- | --- |
| `id` | uuid pk | Assignment ID |
| `teacher_profile_id` | uuid fk | Teacher |
| `pathshala_id` | uuid fk | Pathshala |
| `learning_group_id` | uuid nullable fk | Group |
| `class_level_id` | uuid nullable fk | Level |
| `role_label` | text | lead teacher, assistant |
| `effective_from`, `effective_to` | date | History |
| `status` | assignment_status | planned/active/ended/cancelled |
| `created_by_user_id` | uuid | Audit |

Decision:

Assignments may point to a group or level.

Reasoning:

- Some assignments are group-specific.
- Early rollout may only know that a teacher covers a level at a Pathshala.

### `education.class_schedules`

Recurring schedule template.

| Column | Type | Notes |
| --- | --- | --- |
| `id` | uuid pk | Schedule ID |
| `pathshala_id` | uuid fk | Pathshala |
| `learning_group_id` | uuid fk | Group |
| `teacher_assignment_id` | uuid nullable fk | Responsible assignment |
| `day_of_week` | smallint | 0-6 or ISO 1-7, document clearly |
| `starts_at`, `ends_at` | time | Local Pathshala time |
| `timezone` | text | Example: Asia/Dhaka |
| `effective_from`, `effective_to` | date | Schedule lifecycle |
| `status` | text | active/inactive |

Decision:

Store timezone explicitly.

Reasoning:

- Current deployment may be local, but explicit timezone prevents future report and notification errors.

### `education.attendance_sessions`

Actual class occurrence.

| Column | Type | Notes |
| --- | --- | --- |
| `id` | uuid pk | Session ID |
| `pathshala_id` | uuid fk | Pathshala scope |
| `learning_group_id` | uuid fk | Group |
| `class_schedule_id` | uuid nullable fk | Schedule source |
| `session_date` | date | Class date |
| `starts_at`, `ends_at` | timestamptz nullable | Actual timing |
| `status` | attendance_session_status | draft/open/submitted/approved/corrected/cancelled |
| `opened_by_user_id` | uuid nullable | Actor |
| `submitted_by_user_id` | uuid nullable | Actor |
| `approved_by_user_id` | uuid nullable | Actor |
| `created_at`, `updated_at` | timestamptz | Metadata |

Constraints:

- unique `(learning_group_id, session_date, class_schedule_id)` where not cancelled

Decision:

Attendance is recorded against actual sessions, not only schedules.

Reasoning:

- Holidays, cancellations, extra classes, and make-up classes are real operational events.
- Reports need actual occurrence, not only planned schedule.

### `education.attendance_records`

Student-level attendance marks.

| Column | Type | Notes |
| --- | --- | --- |
| `id` | uuid pk | Record ID |
| `attendance_session_id` | uuid fk | Session |
| `group_enrollment_id` | uuid fk | Enrollment at the time |
| `admission_id` | uuid fk | Denormalized for reporting and integrity |
| `person_id` | uuid fk | Denormalized for fast self-service |
| `mark` | attendance_mark | present/absent/late/excused |
| `note` | text nullable | Optional |
| `marked_by_user_id` | uuid | Actor |
| `marked_at` | timestamptz | Timestamp |
| `corrected_from_record_id` | uuid nullable | Correction chain |

Constraints:

- unique `(attendance_session_id, group_enrollment_id)`

Decision:

Denormalize `admission_id` and `person_id` onto attendance records.

Reasoning:

- Attendance reports are high-volume.
- Denormalization makes self-service and reports faster.
- The RPC that creates records must validate consistency so denormalization does not become corruption.

### `education.attendance_corrections`

Sensitive correction workflow.

| Column | Type | Notes |
| --- | --- | --- |
| `id` | uuid pk | Correction ID |
| `attendance_record_id` | uuid fk | Corrected record |
| `old_mark`, `new_mark` | attendance_mark | Change |
| `reason` | text | Required |
| `requested_by_user_id` | uuid | Actor |
| `approved_by_user_id` | uuid nullable | If policy requires |
| `status` | text | requested/approved/rejected/applied |
| `created_at`, `applied_at` | timestamptz nullable | Timestamps |

---

## 7. Communication Tables

### `communication.notices`

| Column | Type | Notes |
| --- | --- | --- |
| `id` | uuid pk | Notice ID |
| `organization_id` | uuid fk | Organization |
| `pathshala_id` | uuid nullable fk | Null for central notice |
| `title` | text | Required |
| `body` | text | Required |
| `status` | notice_status | draft/published/archived |
| `published_at` | timestamptz nullable | Visible time |
| `expires_at` | timestamptz nullable | Optional |
| `created_by_user_id` | uuid | Actor |

### `communication.notice_targets`

| Column | Type | Notes |
| --- | --- | --- |
| `id` | uuid pk | Target ID |
| `notice_id` | uuid fk | Notice |
| `target_type` | text | organization, pathshala, role, learning_group, person |
| `target_id` | uuid nullable | Depends on type |

### `communication.notice_read_receipts`

| Column | Type | Notes |
| --- | --- | --- |
| `notice_id` | uuid fk | Notice |
| `person_id` | uuid fk | Reader |
| `read_at` | timestamptz | Timestamp |

Primary key: `(notice_id, person_id)`

Decision:

Target notices separately instead of putting audience columns on `notices`.

Reasoning:

- A notice may target multiple groups, roles, or persons.
- This supports both central and local communication cleanly.

---

## 8. Audit and Reporting

### `audit.audit_events`

| Column | Type | Notes |
| --- | --- | --- |
| `id` | uuid pk | Event ID |
| `occurred_at` | timestamptz | Timestamp |
| `actor_user_id` | uuid nullable | Supabase user/account |
| `actor_person_id` | uuid nullable | Person |
| `action` | text | Example: admission.create |
| `entity_schema` | text | Table schema |
| `entity_table` | text | Table name |
| `entity_id` | uuid nullable | Row ID |
| `scope_type` | scope_type nullable | Authorization scope |
| `scope_id` | uuid nullable | Scope ID |
| `before_data` | jsonb nullable | Sensitive, restrict access |
| `after_data` | jsonb nullable | Sensitive, restrict access |
| `reason` | text nullable | Required for corrections/overrides |
| `request_id` | text nullable | Traceability |

Decision:

Audit logs should be append-only and not directly writable from clients.

Reasoning:

- Audit is only useful if users cannot rewrite it.
- Workflow functions should insert audit events in the same transaction as business changes.

### Reporting views

Recommended read models:

| View | Purpose |
| --- | --- |
| `reporting.current_students_by_pathshala` | Active admissions count by Pathshala |
| `reporting.attendance_summary_by_group` | Attendance rate by session/group/date range |
| `reporting.teacher_assignment_coverage` | Groups without active teacher assignment |
| `reporting.pathshala_operational_health` | Activity indicators for central monitoring |
| `reporting.my_student_profile` | Student self-service profile |
| `reporting.my_teacher_schedule` | Teacher schedule and attendance tasks |

Decision:

Use reporting views for common dashboards, not repeated complex queries in Flutter.

Reasoning:

- Keeps clients simple.
- Gives QA stable contract points.
- Allows query optimization without changing UI code.

---

## 9. API Design

Supabase gives three API styles:

1. Auto-generated table/view APIs through PostgREST.
2. RPC APIs through PostgreSQL functions.
3. Edge Functions for TypeScript server-side workflows.

The professional rule for this platform:

- Reads can use tables or views when RLS is enough.
- Writes that express business meaning should use RPC or Edge Functions.
- Administrative and correction workflows should not be implemented as loose client-side table updates.

### 9.1 Auth APIs

Use Supabase Auth SDK from Flutter:

| Capability | API Style | Notes |
| --- | --- | --- |
| Sign in | Supabase Auth | Email/password or OTP based on policy |
| Invite user | Edge Function `invite-user` | Creates `auth.users`, `iam.user_accounts`, and role assignment transactionally |
| Disable account | RPC `iam.disable_user_account` or Edge Function | Requires `iam.assign_role` or higher |
| Current profile | View/RPC `registry.get_my_profile` | Joins auth user to person |

### 9.2 Registry APIs

| Capability | API Style | Contract |
| --- | --- | --- |
| Search people | RPC `registry.search_people` | Input: name/phone/email/dob. Output: candidate list with match score |
| Create person | RPC `registry.create_person` | Runs duplicate checks, creates person, contacts, audit event |
| Update person | RPC `registry.update_person` | Sensitive fields require permission and audit reason |
| Merge duplicate people | RPC `registry.merge_people` | Central-only, high-risk, creates audit and redirect/merge record |
| List Pathshalas | View/table | RLS filters by scope |
| Create Pathshala | RPC `registry.create_pathshala` | Central governance only |
| Update Pathshala status | RPC `registry.change_pathshala_status` | Preserves history |

### 9.3 Admission APIs

| Capability | API Style | Contract |
| --- | --- | --- |
| Create admission | RPC `education.admit_student` | `person_id`, `pathshala_id`, admission details |
| Transfer student | RPC `education.request_student_transfer`, `approve_student_transfer` | Creates transfer record and new admission when completed |
| Withdraw student | RPC `education.withdraw_student` | Requires reason and effective date |
| Complete student | RPC `education.complete_student` | Ends active admission |
| List current students | View `reporting.current_students` | Pathshala-scoped |
| Student history | View/RPC `education.get_student_journey` | Authorized central/local/self access |

### 9.4 Teacher APIs

| Capability | API Style | Contract |
| --- | --- | --- |
| Create teacher profile | RPC `education.create_teacher_profile` | Person must exist |
| Approve/suspend teacher | RPC `education.change_teacher_status` | Central or authorized operations |
| Assign teacher | RPC `education.assign_teacher` | Checks Pathshala scope and schedule conflicts |
| End assignment | RPC `education.end_teacher_assignment` | Preserves history |
| Teacher schedule | View `reporting.my_teacher_schedule` | Teacher self-service |

### 9.5 Attendance APIs

| Capability | API Style | Contract |
| --- | --- | --- |
| Open attendance session | RPC `education.open_attendance_session` | Creates actual class occurrence |
| Mark attendance | RPC `education.mark_attendance` | Upserts marks only while session open |
| Submit attendance | RPC `education.submit_attendance_session` | Locks teacher editing |
| Approve attendance | RPC `education.approve_attendance_session` | Admin/ops permission |
| Correct attendance | RPC `education.request_attendance_correction`, `apply_attendance_correction` | Audited and optionally approved |
| Teacher today tasks | View `reporting.my_teacher_attendance_tasks` | Mobile optimized |
| Student attendance view | View `reporting.my_attendance` | Self only |

### 9.6 Notice APIs

| Capability | API Style | Contract |
| --- | --- | --- |
| Create draft notice | RPC/table | Author must have publish or draft permission |
| Publish notice | RPC `communication.publish_notice` | Validates target scope |
| Read notices | View `communication.visible_notices` | RLS filters audience |
| Mark read | RPC/table insert | Person can mark own receipt |

### 9.7 Reporting APIs

| Capability | API Style | Contract |
| --- | --- | --- |
| Local dashboard | Views | Pathshala scoped |
| Central dashboard | Views/materialized views | Organization scoped |
| Export report | Edge Function | Generates CSV/PDF when needed |

Decision:

Reports should be authorized separately from underlying table permissions.

Reasoning:

- A committee member may view summarized reports without seeing sensitive person details.
- Reporting access is a governance capability, not an accidental side effect of table reads.

---

## 10. RLS Policy Model

### Baseline policies

Every exposed table should follow one of these policy patterns:

1. Self access: person can view their own records.
2. Pathshala scoped access: user can access rows for Pathshalas in their active role assignment scope.
3. Organization scoped access: central users can access cross-Pathshala rows.
4. Assignment based access: teachers can access sessions linked to their active assignments.
5. Target based access: notice readers can access notices targeted to them.

Example pattern:

```sql
create policy "pathshala scoped admission read"
on education.student_admissions
for select
to authenticated
using (
  iam.has_permission('admission.read', 'pathshala', pathshala_id)
  or iam.has_permission('admission.read', 'organization', organization_id)
  or person_id = iam.current_person_id()
);
```

Decision:

Use helper functions for policy readability.

Reasoning:

- Policies repeated across many tables become hard to maintain if each one joins IAM tables directly.
- Helper functions centralize effective permission calculation.
- Policies remain explainable during security review.

Performance requirements:

- Index every column used in RLS checks: `organization_id`, `pathshala_id`, `person_id`, `user_account_id`, `role_id`, `permission_id`, `scope_type`, `scope_id`.
- Avoid unbounded JSON checks in hot RLS paths.
- Use views for mobile read models to reduce query complexity.

---

## 11. Flutter Client Guidance

Use `supabase_flutter` for:

- Auth session management.
- Direct reads from RLS-protected views.
- Realtime subscriptions where useful, such as notices or attendance session status.
- RPC calls for domain workflows.

Recommended Flutter modules:

| Flutter Layer | Responsibility |
| --- | --- |
| `AuthRepository` | Supabase Auth and current account bootstrap |
| `ProfileRepository` | Current person/profile |
| `RegistryRepository` | People and Pathshala search/listing |
| `AdmissionRepository` | Admission workflows |
| `TeacherRepository` | Teacher profile/assignment workflows |
| `AttendanceRepository` | Attendance session and marks |
| `NoticeRepository` | Notices and read receipts |
| `ReportRepository` | Dashboard/reporting views |

Decision:

Flutter should consume stable backend contracts, not encode organizational rules deeply in widgets.

Reasoning:

- The same domain rules must apply to web and mobile.
- Backend authorization remains authoritative.
- UI can adapt by reading available roles, permissions, and scopes.

---

## 12. Minimum Viable Release Table Set

For the first professional release, do not build everything at once. Build the smallest set that preserves the architecture.

Phase 1 foundation:

- `registry.organizations`
- `registry.people`
- `registry.person_contacts`
- `registry.pathshalas`
- `iam.user_accounts`
- `iam.roles`
- `iam.permissions`
- `iam.role_permissions`
- `iam.role_assignments`
- `iam.permission_overrides`
- `audit.audit_events`

Phase 2 education operations:

- `education.academic_years`
- `education.class_levels`
- `education.student_admissions`
- `education.student_admission_events`
- `education.learning_groups`
- `education.group_enrollments`
- `education.teacher_profiles`
- `education.teacher_assignments`
- `education.class_schedules`
- `education.attendance_sessions`
- `education.attendance_records`

Phase 3 communication and governance visibility:

- `communication.notices`
- `communication.notice_targets`
- `communication.notice_read_receipts`
- reporting views/materialized views
- transfer and correction workflow tables if not included in phase 2

Decision:

Phase by dependency, not by screen.

Reasoning:

- IAM and registry integrity must exist before local operations are safe.
- Attendance without admissions and assignments will collapse into an attendance-only app, which the product vision rejects.

---

## 13. Open Questions Before SQL Finalization

| Question | Why It Matters |
| --- | --- |
| Can one student have active admissions at multiple Pathshalas? | Determines unique indexes and transfer rules. |
| Is guardian access required in the first release? | Adds guardian login roles and student visibility policies. |
| Which fields are mandatory for person creation? | Affects duplicate detection and admission UX. |
| Which admission changes require central approval? | Affects workflow tables and status transitions. |
| Should attendance corrections require approval? | Affects correction RPC and admin workload. |
| What reports are mandatory at launch? | Determines which reporting views/materialized views are created first. |
| Will the Management Portal also be Flutter web? | Affects API ergonomics but not the database model. |

---

## 14. Official Supabase References Used

- Supabase Row Level Security documentation: https://supabase.com/docs/guides/database/postgres/row-level-security
- Supabase Auth documentation: https://supabase.com/docs/guides/auth
- Supabase Edge Functions documentation: https://supabase.com/docs/guides/functions
- Supabase Edge Function authentication documentation: https://supabase.com/docs/guides/functions/auth

