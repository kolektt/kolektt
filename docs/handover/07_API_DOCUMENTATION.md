# API Documentation

## External APIs

### 1. Discogs API

#### Authentication
```dart
final client = DiscogsClient(
  consumerKey: 'YOUR_CONSUMER_KEY',
  consumerSecret: 'YOUR_CONSUMER_SECRET',
);
```

#### Search Albums
```dart
Future<List<Album>> searchAlbums(String query) async {
  final response = await client.database.search(
    query: query,
    type: 'release',
    perPage: 50,
  );
  return response.results.map((item) => Album.fromJson(item)).toList();
}
```

#### Get Album Details
```dart
Future<AlbumDetails> getAlbumDetails(int id) async {
  final response = await client.database.getRelease(id);
  return AlbumDetails.fromJson(response);
}
```

### 2. Supabase API

#### Authentication
```dart
final supabase = SupabaseClient(
  'YOUR_SUPABASE_URL',
  'YOUR_SUPABASE_ANON_KEY',
);
```

#### User Authentication
```dart
Future<User> signIn(String email, String password) async {
  final response = await supabase.auth.signIn(
    email: email,
    password: password,
  );
  return User.fromJson(response.user);
}
```

#### Collection Management
```dart
Future<List<CollectionItem>> getCollection() async {
  final response = await supabase
    .from('collections')
    .select()
    .eq('user_id', userId);
  return response.map((item) => CollectionItem.fromJson(item)).toList();
}
```

### 3. Google ML Kit

#### Image Labeling
```dart
Future<List<Label>> labelImage(File image) async {
  final inputImage = InputImage.fromFile(image);
  final imageLabeler = ImageLabeler(options: ImageLabelerOptions());
  final labels = await imageLabeler.processImage(inputImage);
  return labels.map((label) => Label(
    text: label.label,
    confidence: label.confidence,
  )).toList();
}
```

## Internal APIs

### 1. Collection Service

#### Add Album
```dart
Future<void> addAlbum(Album album) async {
  await collectionRepository.addAlbum(album);
  await syncService.sync();
}
```

#### Remove Album
```dart
Future<void> removeAlbum(String albumId) async {
  await collectionRepository.removeAlbum(albumId);
  await syncService.sync();
}
```

### 2. Recognition Service

#### Process Image
```dart
Future<RecognitionResult> processImage(File image) async {
  final labels = await mlKitService.labelImage(image);
  final albums = await discogsService.searchByLabels(labels);
  return RecognitionResult(
    labels: labels,
    suggestedAlbums: albums,
  );
}
```

### 3. Sync Service

#### Sync Collection
```dart
Future<void> sync() async {
  final localChanges = await localStorage.getPendingChanges();
  await supabaseService.uploadChanges(localChanges);
  final remoteChanges = await supabaseService.getChanges();
  await localStorage.applyChanges(remoteChanges);
}
```

## Error Handling

### API Errors
```dart
class ApiException implements Exception {
  final String message;
  final int statusCode;
  
  ApiException(this.message, this.statusCode);
  
  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}
```

### Error Response Format
```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Error message",
    "details": {
      "field": "Additional information"
    }
  }
}
```

## Rate Limiting

### Discogs API
- 60 requests per minute
- 1000 requests per day

### Supabase
- 100 requests per second
- 1 million requests per month

### ML Kit
- 1000 requests per day
- 100 requests per minute

## Security

### API Key Management
```dart
class ApiKeyManager {
  static const String _keyPrefix = 'encrypted_';
  
  Future<String> getApiKey(String service) async {
    final encryptedKey = await secureStorage.read(key: _keyPrefix + service);
    return _decrypt(encryptedKey);
  }
}
```

### Data Encryption
```dart
class DataEncryption {
  static Future<String> encrypt(String data) async {
    final key = await getEncryptionKey();
    return encryptAES(data, key);
  }
}
```

## Monitoring

### API Calls Logging
```dart
class ApiLogger {
  static void logApiCall(String endpoint, Map<String, dynamic> params) {
    logger.info('API Call: $endpoint', params);
  }
}
```

### Performance Monitoring
```dart
class ApiPerformance {
  static Future<T> measure<T>(Future<T> Function() operation) async {
    final stopwatch = Stopwatch()..start();
    final result = await operation();
    stopwatch.stop();
    logger.info('Operation took ${stopwatch.elapsedMilliseconds}ms');
    return result;
  }
}
```

## Testing

### API Mocking
```dart
class MockDiscogsClient extends Mock implements DiscogsClient {
  @override
  Future<SearchResponse> search({String query}) async {
    return SearchResponse.fromJson(mockSearchResponse);
  }
}
```

### Integration Tests
```dart
void main() {
  test('search albums', () async {
    final client = DiscogsClient();
    final results = await client.searchAlbums('test');
    expect(results, isNotEmpty);
  });
} 