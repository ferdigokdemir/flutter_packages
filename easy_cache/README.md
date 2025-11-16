# Easy Cache 💾

Simple, efficient cache service with TTL support, bulk operations, and automatic expiry management using SharedPreferences.

## Features ✨

- ⏰ **TTL Support** - Automatic time-based expiration
- 📦 **JSON Serialization** - Easy data storage and retrieval
- 🚀 **Bulk Operations** - Set, get, and remove multiple items at once
- 🧹 **Auto Cleanup** - Automatic expired cache removal
- 📊 **Cache Statistics** - Monitor cache usage and performance
- ⚡ **Performance Optimized** - Parallel operations and efficient storage

## Installation 📦

Add to your `pubspec.yaml`:

```yaml
dependencies:
  easy_cache:
    path: ../packages/easy_cache
```

## Usage 🔧

### Initialize

```dart
import 'package:easy_cache/easy_cache.dart';

// Initialize service
await EasyCacheService.instance.init();
```

### Basic Operations

```dart
// Save data with 7 days TTL
await EasyCacheService.instance.set(
  key: 'user_123',
  data: {'name': 'John', 'age': 30},
  duration: Duration(days: 7).inSeconds,
);

// Get data
final userData = await EasyCacheService.instance.get(key: 'user_123');
if (userData != null) {
  print('Cached user: $userData');
}

// Check if exists
final exists = await EasyCacheService.instance.exists(key: 'user_123');

// Remove
await EasyCacheService.instance.remove(key: 'user_123');
```

### Bulk Operations

```dart
// Set multiple items
await EasyCacheService.instance.setMultiple(
  items: {
    'user_1': {'name': 'Alice'},
    'user_2': {'name': 'Bob'},
    'user_3': {'name': 'Charlie'},
  },
  duration: Duration(hours: 24).inSeconds,
);

// Get multiple items
final users = await EasyCacheService.instance.getMultiple(
  keys: ['user_1', 'user_2', 'user_3'],
);

// Remove multiple items
await EasyCacheService.instance.removeMultiple(
  keys: ['user_1', 'user_2'],
);
```

### Cache Management

```dart
// Get statistics
final stats = await EasyCacheService.instance.getStats();
print('Total items: ${stats['totalItems']}');
print('Valid items: ${stats['validItems']}');
print('Cache size: ${stats['totalSizeKB']} KB');

// Clear expired items
final removedCount = await EasyCacheService.instance.clearExpired();
print('Removed $removedCount expired items');

// Clear all cache
await EasyCacheService.instance.clearAll();
```

### TTL Management

```dart
// Update expiry time
await EasyCacheService.instance.updateExpiry(
  key: 'user_123',
  duration: Duration(days: 14).inSeconds,
);

// Get remaining time
final remainingSeconds = await EasyCacheService.instance.getRemainingTime(key: 'user_123');
if (remainingSeconds != null) {
  print('Expires in $remainingSeconds seconds');
}
```

## Best Practices 💡

1. **Use Key Prefixes**: Organize cache with prefixes like `user_`, `fortune_`, etc.
2. **Don't Cache Sensitive Data**: Avoid caching auth tokens or critical data
3. **Periodic Cleanup**: Call `clearExpired()` periodically to free space
4. **Monitor Cache Size**: Use `getStats()` to monitor cache usage

## License

MIT License
