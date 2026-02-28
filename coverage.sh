#!/bin/bash
echo "🧪 Ejecutando pruebas con cobertura..."
flutter test --coverage

echo ""
echo "🧹 Filtrando archivos generados y no testeables..."
lcov --remove coverage/lcov.info \
  '**/*.g.dart' \
  '**/*.freezed.dart' \
  '**/*.gr.dart' \
  '**/*.config.dart' \
  '**/generated/**' \
  '**/.dart_tool/**' \
  '**/l10n/**' \
  '**/main.dart' \
  '**/di/**' \
  '**/constants/**' \
  '**/routes/**' \
  '**/entities/**' \
  '**/environment/**' \
  '**/network/**' \
  -o coverage/lcov_filtered.info

echo ""
echo "📊 Generando reporte HTML..."
genhtml coverage/lcov_filtered.info -o coverage/html

echo ""
echo "✅ Reporte generado en coverage/html/index.html"
open coverage/html/index.html