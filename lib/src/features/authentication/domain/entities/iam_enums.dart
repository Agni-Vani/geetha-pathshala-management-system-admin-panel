/// Lifecycle state for an application user account.
enum AccountStatus { pending, active, suspended, deactivated }

/// Target scope boundary for an assigned role.
enum RoleScopeType { global, organization, pathshala }

/// Lifecycle state for a user's role assignment.
enum UserRoleStatus { active, revoked, expired }
