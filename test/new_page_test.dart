import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_tutorial/article.dart';
import 'package:flutter_testing_tutorial/news_change_notifier.dart';
import 'package:flutter_testing_tutorial/news_page.dart';
import 'package:flutter_testing_tutorial/news_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockNewsService extends Mock implements NewsService {}

void main() {
  late MockNewsService mockNewsService;

  final articlesFromService = [
    Article(content: 'Content 1', title: 'Title 1'),
    Article(content: 'Content 2', title: 'Title 2'),
    Article(content: 'Content 3', title: 'Title 3'),
  ];

  setUp(() {
    mockNewsService = MockNewsService();
  });

  void arrangeNewsServiceReturns3Articles() {
    when(() => mockNewsService.getArticles()).thenAnswer(
      (_) async => articlesFromService,
    );
  }

  void arrangeNewsServiceReturns3ArticlesAfter2SecondsWait() {
    when(() => mockNewsService.getArticles()).thenAnswer(
      (_) async => await Future.delayed(Duration(seconds: 2), () => articlesFromService),
    );
  }

  Widget createWidgetUnderTest() {
    return MaterialApp(
      title: 'News App',
      home: ChangeNotifierProvider(
        create: (_) => NewsChangeNotifier(mockNewsService),
        child: NewsPage(),
      ),
    );
  }

  // Test Text widget on Scaffold
  testWidgets('Title is displayed ', (WidgetTester tester) async {
    arrangeNewsServiceReturns3Articles();
    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.text('News'), findsOneWidget);
  });

  // Test Loading indicator
  testWidgets('Loader indicator is displayed while is waiting for articles ',
      (WidgetTester tester) async {
    arrangeNewsServiceReturns3ArticlesAfter2SecondsWait();

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
  });
}
