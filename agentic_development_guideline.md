# Gita Pathshala Management Platform - Agentic Development Guidelines

## Architectural Principles & Feature Isolation Rules

### 1. Strict Feature Isolation
- **Zero Cross-Feature Imports**: No feature in `lib/src/features/<feature_name>` may import entities, use cases, repositories, models, or data sources from any other feature in `lib/src/features/<other_feature>`.
- **App-Level Orchestration**: If a workflow requires combining multiple features (e.g. associating IAM credentials with a Person Registry record or linking Education Admissions with Person identities), the orchestration interface, composite use case, or facade **must live at the app level** (under `lib/src/app/` or `lib/src/core/`).

---

## Clean Architecture Structure per Feature

Each feature directory in `lib/src/features/<feature_name>/` follows this structure:

```
lib/src/features/<feature_name>/
├── domain/
│   ├── entities/        # Pure domain entities (abstract classes/data classes)
│   ├── params/          # Input parameter objects for use cases
│   ├── repositories/    # Abstract repository interfaces returning AsyncRequest<T>
│   ├── usecases/        # Single-responsibility use case classes inheriting BaseUseCase
│   └── <feature>_domain.dart
├── data/
│   ├── models/          # Data transfer objects using Freezed & JsonSerializable
│   ├── datasources/     # Abstract Datasource & Implementations (Mock, Supabase)
│   ├── repositories/    # Repository implementations mapping models <-> entities
│   └── <feature>_data.dart
```

---

## Coding & Data Conventions

1. **Async Error Handling**:
   - Repository methods and use cases return `AsyncRequest<T>` (`Future<RepoResponse<T>>`).
   - Use `ErrorHandler.asyncTryCatch` in repository implementations to safely handle exceptions.

2. **Immutability & Model Serialization**:
   - Models use `@freezed` and `@JsonSerializable` for immutability and JSON mapping.
   - Run `dart run build_runner build --delete-conflicting-outputs` whenever models are modified.

3. **Dependency Injection**:
   - Repositories and datasources are registered in `get_it` service locator.

4. **Testing Standards**:
   - Every domain repository implementation and datasource must have accompanying unit tests under `test/<feature_name>/`.
