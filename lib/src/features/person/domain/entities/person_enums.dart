/// Lifecycle state for a registered human identity.
enum PersonStatus { active, inactive, merged, deceased, archived }

/// Supported contact channels attached to a person.
enum ContactType { phone, email, address, emergency, other }

/// Relationship types between two registered people.
enum PersonRelationshipType { parent, guardian, sibling, spouse, other }
