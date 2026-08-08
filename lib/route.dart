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
      case SplashScreen.routeName:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/intro':
      case IntroPage.routeName:
        return MaterialPageRoute(builder: (_) => IntroPage());
      case '/home':
      case HomePage.routeName:
        return MaterialPageRoute(builder: (_) => HomePage());
      case '/login':
      case LoginPage.routeName:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/book':
      case BookPage.routeName:
        return MaterialPageRoute(
          builder: (_) => BookPage(bookCard: settings.arguments, bookId: settings.arguments),
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
          builder: (_) => BookReaderPage(filePath: args is String ? args : ''),
        );
      case '/favorites':
      case FavoritesPage.routeName:
        return MaterialPageRoute(builder: (_) => FavoritesPage());
      case '/genre':
      case GenrePage.routeName:
        return MaterialPageRoute(
          builder: (_) => GenrePage(genre: settings.arguments),
        );
      case '/sequence':
      case SequencePage.routeName:
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
