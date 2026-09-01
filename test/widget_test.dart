import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dormly_owner_mobile/main.dart';
import 'package:dormly_owner_mobile/data/services/storage_service.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await StorageService.init();
  });

  testWidgets('DormlyOwnerApp smoke test launches splash and navigates to login', (WidgetTester tester) async {
    await tester.pumpWidget(const DormlyOwnerApp());
    expect(find.text('DORMLY OWNER'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 2000));
    await tester.pumpAndSettle();

    expect(find.text('Dormly'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
  });
}
