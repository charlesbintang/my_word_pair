# Struktur MVVM untuk Flutter

## Struktur Folder yang Direkomendasikan untuk MVVM:

```
lib/
├── main.dart                    # Entry point aplikasi
│
├── models/                      # Data Models (Domain Layer)
│   └── word_pair_model.dart    # Model data
│
├── viewmodels/                  # ViewModels (Business Logic Layer)
│   ├── generator_viewmodel.dart
│   ├── favorites_viewmodel.dart
│   └── app_viewmodel.dart
│
├── views/ atau screens/         # Views (UI Layer)
│   ├── home_page.dart
│   ├── generator_page.dart
│   └── favorites_page.dart
│
├── widgets/                     # Reusable UI Components
│   ├── big_card.dart
│   └── history_list_view.dart
│
├── services/                    # Services (Data/API Layer)
│   └── word_service.dart       # Service untuk fetch data
│
├── repositories/                # Repositories (Data Access Layer)
│   └── word_repository.dart    # Repository pattern
│
└── providers/                   # Provider Setup (State Management)
    └── app_providers.dart      # Setup semua providers
```

## Penjelasan MVVM Pattern:

### 1. **Models** (Data Layer)
- Berisi data models/entities
- Pure Dart classes tanpa business logic
- Contoh: `WordPairModel`, `UserModel`, dll

### 2. **ViewModels** (Business Logic Layer)
- Berisi business logic dan state management
- Menggunakan `ChangeNotifier` atau state management lainnya
- Menghubungkan antara View dan Model
- Contoh: `GeneratorViewModel`, `FavoritesViewModel`

### 3. **Views/Screens** (UI Layer)
- Hanya berisi UI/widgets
- Tidak ada business logic
- Mendengarkan ViewModel untuk update UI
- Contoh: `GeneratorPage`, `FavoritesPage`

### 4. **Services** (External Data Layer)
- Berinteraksi dengan API, database, atau external services
- Contoh: `WordService`, `ApiService`

### 5. **Repositories** (Data Access Layer)
- Abstraction layer untuk data access
- Menggunakan services untuk fetch data
- Contoh: `WordRepository`

## Mapping Struktur Saat Ini ke MVVM:

| Struktur Saat Ini | MVVM Equivalent | Keterangan |
|-------------------|-----------------|------------|
| `providers/app_state.dart` | `viewmodels/app_viewmodel.dart` | Rename & refactor |
| `screens/` | `views/` atau tetap `screens/` | Sudah sesuai |
| `widgets/` | `widgets/` | Sudah sesuai |
| - | `models/` | Perlu ditambahkan |
| - | `services/` | Perlu ditambahkan |
| - | `repositories/` | Perlu ditambahkan |

## Contoh Implementasi MVVM:

### Model (models/word_pair_model.dart)
```dart
class WordPairModel {
  final String first;
  final String second;
  
  WordPairModel({required this.first, required this.second});
  
  String get asLowerCase => '$first $second'.toLowerCase();
}
```

### ViewModel (viewmodels/generator_viewmodel.dart)
```dart
class GeneratorViewModel extends ChangeNotifier {
  final WordRepository _repository;
  WordPairModel? _current;
  List<WordPairModel> _history = [];
  
  GeneratorViewModel(this._repository);
  
  WordPairModel? get current => _current;
  List<WordPairModel> get history => _history;
  
  Future<void> getNext() async {
    _current = await _repository.getRandomWord();
    _history.insert(0, _current!);
    notifyListeners();
  }
}
```

### View (screens/generator_page.dart)
```dart
class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GeneratorViewModel>(
      builder: (context, viewModel, child) {
        return Column(
          children: [
            Text(viewModel.current?.asLowerCase ?? 'Loading...'),
            ElevatedButton(
              onPressed: () => viewModel.getNext(),
              child: Text('Next'),
            ),
          ],
        );
      },
    );
  }
}
```

## Keuntungan Struktur MVVM:

✅ **Separation of Concerns** - Setiap layer punya tanggung jawab jelas
✅ **Testability** - Mudah di-test karena logic terpisah dari UI
✅ **Maintainability** - Mudah dirawat dan dikembangkan
✅ **Reusability** - ViewModels bisa digunakan di multiple views
✅ **Scalability** - Mudah menambah fitur baru

## Langkah Migrasi ke MVVM:

1. ✅ Struktur folder sudah dibuat
2. ⏭️ Buat models untuk data entities
3. ⏭️ Refactor `providers/` menjadi `viewmodels/`
4. ⏭️ Buat `services/` jika perlu API/database
5. ⏭️ Buat `repositories/` untuk data access layer
6. ⏭️ Update imports di semua file

Struktur saat ini sudah **80% siap** untuk MVVM! Tinggal menambahkan folder `models/`, `services/`, dan `repositories/`, serta refactor `providers/` menjadi `viewmodels/`.

