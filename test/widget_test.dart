import 'package:flutter_test/flutter_test.dart';
import 'package:nantli/main.dart';

void main() {
  testWidgets('Nantli welcome screen smoke test', (WidgetTester tester) async {
    // Construye la app usando el nombre correcto: NantliApp
    await tester.pumpWidget(const NantliApp());

    // Verifica que el nombre de la app aparezca en pantalla
    expect(find.text('Nantli'), findsOneWidget);
    
    // Verifica que el botón principal esté presente
    expect(find.text('Iniciar Sesión'), findsOneWidget);
  });
}
