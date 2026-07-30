/// Lifecycle state for the central governing organization.
enum OrganizationStatus { active, inactive, archived }

/// Lifecycle state for a registered human identity.
enum PersonStatus { active, inactive, merged, deceased, archived }

/// Supported contact channels attached to a person.
enum ContactType { phone, email, address, emergency, other }

/// Relationship types between two registered people.
enum PersonRelationshipType { parent, guardian, sibling, spouse, other }

/// Operational lifecycle state for a registered Pathshala.
enum PathshalaStatus { draft, active, paused, closed, archived }

/// Governance grouping type for central or local committees.
enum CommitteeType { central, pathshala, advisory, other }

/// Lifecycle state for a committee registry record.
enum CommitteeStatus { active, inactive, archived }

/// Lifecycle state for a person's committee participation.
enum CommitteeMembershipStatus { active, ended }
