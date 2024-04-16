import 'dart:convert';
import 'dart:typed_data';

import 'package:chaleno/chaleno.dart';
import 'package:dart_rss/dart_rss.dart';
import 'package:http/http.dart';

/// A class that represents the TIB RSS feed.
/// The feed has a list of items.
/// Each item is a warning or news article.
/// The [getWarningFeed] method returns the warning feed.
/// The [getNewsFeed] method returns the news feed.
class TibRss {
  /// Get the warning feed from the TIB RSS.
  /// Returns a [RssFeed] object with the warning feed.
  static Future<RssFeed> getWarningFeed() async {
    final request = await get(Uri.parse(
        "https://www.tib.org/es/avisos/-/asset_publisher/MvaiWwqbYsHv/rss"));
    return RssFeed.parse(utf8.decode(request.bodyBytes));
  }

  /// Get the news feed from the TIB RSS.
  /// Returns a [RssFeed] object with the news feed.
  static Future<RssFeed> getNewsFeed() async {
    final request = await get(Uri.parse(
        "https://www.tib.org/es/noticias/-/asset_publisher/NIwXxcBhaMlh/rss"));
    return RssFeed.parse(utf8.decode(request.bodyBytes));
  }
}

/// A class that scrapes the warning feed.
/// The [scrapeWarningDescription] method scrapes the warning description.
/// The [scrapeAffectedLines] method scrapes the affected lines.
class TibWarningScraper {
  /// Scrape the warning description from a warning item.
  /// The [rssItem] parameter is the warning item to scrape.
  /// Returns a string with the warning description.
  static Future<String?> scrapeWarningDescription(RssItem rssItem) async {
    try {
      final parser = await Chaleno().load(rssItem.link!);
      List<Result> results =
          parser!.getElementsByClassName('avisos-container-content-body');
      return results[0].text!.trim();
    } catch (e) {
      throw Exception('Failed to scrape warning description');
    }
  }

  /// Scrape the affected lines from a warning item.
  /// The [rssItem] parameter is the warning item to scrape.
  /// Returns a list of strings with the affected lines.
  static Future<List<String?>> scrapeAffectedLines(RssItem rssItem) async {
    try {
      final parser = await Chaleno().load(rssItem.link!);
      List<Result> results =
          parser!.getElementsByClassName('avisos-container-lines-body');
      List<String> lines = [];
      for (var value in results) {
        for (var element in Parser(value.html).getElementsByTagName('a')!) {
          if (element.text!.isNotEmpty) {
            lines.add(element.text!.trim());
          }
        }
      }

      return lines;
    } catch (e) {
      throw Exception('Failed to scrape affected lines');
    }
  }
}

/// A class that scrapes the news feed.
/// The [scrapeNewsDescription] method scrapes the news description.
/// The [scrapeNewsImage] method scrapes the news image.
class TibNewsScraper {
  /// Scrape the news description from a news item.
  /// The [rssItem] parameter is the news item to scrape.
  /// Returns a list of strings with the news description.
  static Future<List<String>?> scrapeNewsDescription(RssItem rssItem) async {
    try {
      final parser = await Chaleno().load(rssItem.link!);
      List<String> bodyText = [];
      Result div =
          parser!.getElementsByClassName('news-container-content-body').first;
      List<Result> results = div.querySelectorAll('p')!;
      for (var value in results) {
        bodyText.add(value.text!.trim());
      }
      return bodyText;
    } catch (e) {
      throw Exception('Failed to scrape news description');
    }
  }

  /// Scrape the news image from a news item.
  /// The [rssItem] parameter is the news item to scrape.
  /// Returns a [Uint8List] with the news image.
  /// Throws an exception if the image cannot be scraped.
  static Future<Uint8List> scrapeNewsImage(RssItem rssItem) async {
    try {
      final parser = await Chaleno().load(rssItem.link!);
      List<Result> results = parser!.getElementsByClassName('portada');
      final imageLink =
          await get(Uri.parse("https://tib.org/${results.first.src!}"));
      return imageLink.bodyBytes;
    } catch (e) {
      throw Exception('Failed to scrape news image');
    }
  }
}
