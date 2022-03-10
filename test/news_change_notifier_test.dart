import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_tutorial/article.dart';
import 'package:flutter_testing_tutorial/news_change_notifier.dart';
import 'package:flutter_testing_tutorial/news_service.dart';
import 'package:mocktail/mocktail.dart';

class MockNewsService extends Mock implements NewsService {}

void main() {
  late NewsChangeNotifier sut;
  late MockNewsService mockNewsService;

  final articlesFromService = [
    Article(content: 'Content 1', title: 'Title 1'),
    Article(content: 'Content 2', title: 'Title 2'),
    Article(content: 'Content 3', title: 'Title 3'),
  ];

  setUp(() {
    mockNewsService = MockNewsService();
    sut = NewsChangeNotifier(mockNewsService);
  });

  test('Initial values are correct', () {
    expect(sut.articles, []);
    expect(sut.isLoading, false);
  });

  group('getArticles', () {
    void arrangeNewsServiceReturns3Articles() {
      when(() => mockNewsService.getArticles()).thenAnswer(
        (_) async => articlesFromService,
      );
    }

    test('gets articles using the NewsService', () async {
      arrangeNewsServiceReturns3Articles();
      await sut.getArticles();
      verify(() => mockNewsService.getArticles()).called(1);
    });

    test('''indicates loading of data,
   sets articles to the ones from the services,
   indicates that data is not being loaded anymore ''', () async {
      arrangeNewsServiceReturns3Articles();
      final future = sut.getArticles();
      expect(sut.isLoading, true);
      await future;
      expect(
        sut.articles,
        articlesFromService,
      );
      expect(sut.isLoading, false);
    });
  });
}

/* ###### TEST EXAMPLE ######
void main() {
  late ClassName sut;

  setUp(() {
    sut = ClassName();
  });

  group('', () {});

  test('', () async {});
}
* */
