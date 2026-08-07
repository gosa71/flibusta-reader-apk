import 'package:flibusta/pages/book/book_page.dart';
import 'package:flibusta/pages/book_reader/book_reader_page.dart';
import 'package:flibusta/pages/favorites/favorites_page.dart';
import 'package:flibusta/pages/genre/genre_page.dart';
import 'package:flibusta/pages/home/home_page.dart';
import 'package:flibusta/pages/intro.dart';
import 'package:flibusta/pages/login_page/login_page.dart';
import 'package:flibusta/pages/sequence/sequence_page.dart';
import 'package:flibusta/pages/splash_screen.dart';
import 'package:flutter/material.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/intro':
        return MaterialPageRoute(builder: (_) => IntroPage());
      case '/home':
        return MaterialPageRoute(builder: (_) => HomePage());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/book':
        return MaterialPageRoute(
          builder: (_) => BookPage(bookCard: settings.arguments),
        );
      case BookReaderPage.routeName:
        final args = settings.arguments;
        if (args is BookReaderPageArguments) {
          return MaterialPageRoute(
            builder: (_) => BookReaderPage(
              filePath: args.filePath,
              bookTitle: args.bookTitle,
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => BookReaderPage(filePath: args as String),
        );
      case '/favorites':
        return MaterialPageRoute(builder: (_) => FavoritesPage());
      case '/genre':
        return MaterialPageRoute(
          builder: (_) => GenrePage(genre: settings.arguments),
        );
      case '/sequence':
        return MaterialPageRoute(
          builder: (_) => SequencePage(sequence: settings.arguments),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
