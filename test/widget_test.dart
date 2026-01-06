import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Импортируем НАШЕ приложение
import 'package:life_os/app.dart';

void main() {
  testWidgets('LifeOS app builds without crashing', (
    WidgetTester tester,
  ) async {
    // Оборачиваем в ProviderScope, как в main.dart
    await tester.pumpWidget(const ProviderScope(child: LifeOSApp()));

    // Проверяем, что приложение запустилось
    expect(find.text('Today'), findsOneWidget);
  });
}
