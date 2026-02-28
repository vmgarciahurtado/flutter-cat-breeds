# CatBreeds — Ejercicio Técnico

> Explora razas de gatos con información detallada, búsqueda en tiempo real y una experiencia visual cuidada.

---

## Demo

[![Demo en YouTube](https://img.shields.io/badge/▶%20Ver%20demo-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://youtube.com/shorts/jKidVsvg5so?feature=share)

---

## Instalación directa

Descarga e instala el APK 

[![Descargar APK](https://img.shields.io/badge/⬇%20Descargar%20APK-34A853?style=for-the-badge&logo=android&logoColor=white)](https://drive.google.com/file/d/1VdUW1KsTCvChsm977ivOJMyAwJLmlg_Y/view?usp=sharing)



---

## Pantallas

| Splash | Lista de razas | Detalle |
|--------|---------------|---------|
| Animación de carga | Listado con búsqueda | Información completa de la raza |

---

## Arquitectura

El proyecto sigue **Clean Architecture** con estructura modular por feature:

```
lib/
├── core/
│   ├── constants/
│   ├── environment/
│   ├── error/
│   ├── network/
│   ├── routes/
│   └── theme/
├── features/
│   ├── breeds/
│   │   ├── data/
│   │   │   ├── datasources/remote/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── pages/
│   │       ├── providers/
│   │       └── widgets/
│   └── splash/
│       └── presentation/pages/
└── main.dart
```

---


## Tests

```
test/
└── features/
    └── breeds/
        ├── data/
        │   └── repositories/
        │       └── breeds_repository_impl_test.dart
        ├── domain/
        │   └── usecases/
        │       └── get_breeds_usecase_test.dart
        └── presentation/
            ├── pages/
            │   ├── breeds_page_test.dart
            │   └── breed_detail_page_test.dart
            ├── providers/
            │   └── breeds_provider_test.dart
            └── widgets/
                ├── breed_card_test.dart
                ├── breed_model_test.dart
                ├── error_view_test.dart
                ├── info_section_test.dart
                └── star_rating_test.dart
```

Ejecutar todos los tests:

```bash
flutter test
```

Generar reporte de cobertura:

```bash
./coverage.sh
```

<img src="https://github.com/vmgarciahurtado/flutter-cat-breeds/blob/main/coverage_report/coverage.jpg?raw=true" alt="coverage" width="550"/>
---

## Cómo ejecutar el proyecto

### Prerrequisitos

- Flutter SDK `3.41.1` (stable)
- Dart SDK `^3.11.0`
- Una API key de [The Cat API](https://thecatapi.com/)

### Configuración del archivo `.env`

Este proyecto usa [envied](https://pub.dev/packages/envied) para manejar variables de entorno de forma segura. La API key se ofusca en tiempo de compilación y nunca queda expuesta en el binario.

1. Crea el archivo `.env` en la raíz del proyecto:

```bash
cp .env.example .env
```

2. Agrega tu API key:

```
API_KEY=tu_api_key_aqui
```

### Instalación

```bash
# Clonar el repositorio
git clone https://github.com/vmgarciahurtado/flutter-cat-breeds.git

# Entrar al proyecto
cd flutter-cat-breeds

# Instalar dependencias
flutter pub get

# Ejecutar generación de código
dart run build_runner build --delete-conflicting-outputs

# Correr la app
flutter run
```