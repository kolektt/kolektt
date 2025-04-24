# Project Structure

## Directory Organization

```
lib/
├── components/          # Reusable UI components
├── data/               # Data layer implementation
├── domain/             # Business logic and entities
├── exceptions/         # Custom exceptions
├── model/              # Data models
├── repository/         # Repository implementations
├── view/               # UI screens
└── view_models/        # State management
```

## Key Files

### Components
- `components/album_card.dart`: Album display component
- `components/collection_grid.dart`: Collection grid view
- `components/filter_options.dart`: Filtering options
- `components/recognition_result.dart`: Recognition results display

### Data Layer
- `data/discogs_api_client.dart`: Discogs API client
- `data/supabase_client.dart`: Supabase client
- `data/local_storage.dart`: Local storage implementation

### Domain
- `domain/entities/album.dart`: Album entity
- `domain/entities/collection.dart`: Collection entity
- `domain/use_cases/`: Business logic implementations

### Models
- `model/album_model.dart`: Album data model
- `model/collection_model.dart`: Collection data model
- `model/user_model.dart`: User data model

### Views
- `view/collection_screen.dart`: Collection view
- `view/recognition_screen.dart`: Recognition view
- `view/profile_screen.dart`: Profile view
- `view/settings_screen.dart`: Settings view

### ViewModels
- `view_models/collection_view_model.dart`: Collection state
- `view_models/recognition_view_model.dart`: Recognition state
- `view_models/profile_view_model.dart`: Profile state

## Architecture Overview

### Clean Architecture Layers

1. **Domain Layer**
   - Business logic
   - Entities
   - Use Cases
   - Repository interfaces

2. **Data Layer**
   - Repository implementations
   - Data sources
   - API clients
   - Data mapping

3. **Presentation Layer**
   - UI components
   - ViewModels
   - State management
   - Navigation

## Data Flow

### Album Recognition Flow
1. User uploads image
2. Image sent to ML Kit
3. Results processed
4. Discogs API search
5. Results displayed

### Collection Management Flow
1. User actions
2. ViewModel updates
3. Repository calls
4. Data source operations
5. UI updates

## Key Dependencies

### Internal Dependencies
- Domain → Data
- Presentation → Domain
- Components → ViewModels

### External Dependencies
- Discogs API
- Supabase
- Google ML Kit
- Image Picker

## State Management

### Provider Pattern
- ViewModels extend ChangeNotifier
- Provider for dependency injection
- State updates trigger UI rebuilds

### State Flow
1. User action
2. ViewModel update
3. Repository call
4. Data update
5. UI refresh

## Navigation

### Routes
- `/`: Collection screen
- `/recognition`: Recognition screen
- `/profile`: Profile screen
- `/settings`: Settings screen

### Navigation Flow
1. Route definition
2. Route generation
3. Screen display
4. State management
5. Back navigation

## Error Handling

### Exception Types
- Network exceptions
- Data exceptions
- Validation exceptions
- UI exceptions

### Error Flow
1. Exception thrown
2. Error caught
3. Error processed
4. User notified
5. Recovery attempted

## Testing Structure

### Test Directories
- `test/unit/`: Unit tests
- `test/widget/`: Widget tests
- `test/integration/`: Integration tests

### Test Coverage
- Domain layer: 80%
- Data layer: 75%
- Presentation layer: 70%

## Documentation

### Code Documentation
- Dartdoc comments
- README files
- Architecture docs
- API docs

### Documentation Standards
- Clear descriptions
- Examples provided
- Updates required
- Version tracking 