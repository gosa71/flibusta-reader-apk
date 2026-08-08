import 'package:flutter/material.dart';
import 'package:flibusta/pages/book_reader/book_reader_page.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/Home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Флибуста'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Главная', style: Theme.of(context).textTheme.headline5),
            SizedBox(height: 24),
            Text('Откройте FB2 файл через читалку'),
            SizedBox(height: 16),
            ElevatedButton(
              child: Text('Тест читалки (укажите путь к .fb2)'),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  BookReaderPage.routeName,
                  arguments: BookReaderPageArguments(
                    filePath: '/sdcard/Download/test.fb2',
                    bookTitle: 'Тест',
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Книги'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
        ],
      ),
    );
  }
}
