# Architecture Documentation

## Clean Architecture Layers

### Core Layer (`lib/core/`)

**Purpose**: Cross-cutting concerns and infrastructure components.

**Components**:
- **Constants**: App-wide constants (API config, storage keys, status values)
- **Network**: HTTP client with interceptors, error handling
- **Services**: Environment config, storage abstraction, socket service
- **Logging**: Centralized logging abstraction
- **Utils**: Reusable utilities (Result type, date formatting)

**Key Design Decisions**:
- Abstraction over concrete implementations (e.g., `AppLogger` interface)
- Environment-specific configuration without code changes
- Type-safe error handling with `Result<T>` type

### Domain Layer (`lib/domain/`)

**Purpose**: Pure business logic, independent of frameworks.

**Components**:
- **Entities**: Core business objects (User, Booking, AuthResponse)
- **Repositories**: Interfaces defining data contracts
- **Use Cases**: Business logic orchestration

**Key Design Decisions**:
- No dependencies on Flutter or external packages
- Business rules enforced in use cases
- Repository pattern for data abstraction

### Data Layer (`lib/data/`)

**Purpose**: Data access and external API communication.

**Components**:
- **Models**: Data transfer objects with JSON serialization
- **Data Sources**: Remote API clients
- **Repositories**: Implementation of domain repository interfaces

**Key Design Decisions**:
- Models extend entities (inheritance for serialization)
- Data sources handle HTTP communication
- Repositories transform data (Model → Entity)

### Presentation Layer (`lib/presentation/`)

**Purpose**: UI components and state management.

**Components**:
- **Controllers**: GetX controllers for state management
- **Screens**: UI screens organized by feature/role
- **Widgets**: Reusable UI components (if needed)

**Key Design Decisions**:
- GetX for reactive state management
- Controllers delegate to use cases
- Role-based screen organization

## Dependency Flow

```
Presentation → Domain ← Data
     ↓           ↑
    Core ────────┘
```

- Presentation depends on Domain (use cases)
- Data depends on Domain (implements repositories)
- Core is used by all layers
- Domain has no dependencies (pure Dart)

## Dependency Injection

Using **GetIt** for dependency injection:

1. **Core services** registered as singletons
2. **Repositories** registered as singletons
3. **Use cases** registered as singletons
4. **Controllers** registered as lazy singletons (GetX)

**Benefits**:
- Easy testing (swap implementations)
- Proper lifecycle management
- Single source of truth

## State Management

**GetX** provides:
- Reactive state management (`Rx` observables)
- Dependency injection
- Route management
- Built-in performance optimizations

**Pattern**:
- Controllers hold business state
- Use cases execute business logic
- UI observes controller state reactively

## Error Handling

**Result Type Pattern**:
```dart
Result<T> = Success<T> | Failure<T>
```

**Benefits**:
- Type-safe error handling
- No exception throwing in business logic
- Explicit error propagation

## Real-Time Updates

**Socket Service** (Mock in Phase 1):
- Abstract interface for WebSocket communication
- Subscription-based updates
- Easy to swap mock for real implementation

## Testing Strategy

**Unit Tests**:
- Use cases (pure business logic)
- Entities (business rules)
- Utils (pure functions)

**Widget Tests**:
- Screen components
- UI interactions

**Integration Tests**:
- Full booking flow
- Authentication flow

## Scalability Considerations

1. **Horizontal Scaling**: Stateless architecture
2. **Caching**: Easy to add caching layer in data sources
3. **Pagination**: Built into repository interfaces
4. **Offline Support**: Can add local data sources
5. **Microservices**: Domain layer ready for service boundaries
