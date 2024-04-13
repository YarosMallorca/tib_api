import 'package:chaleno/chaleno.dart';
import 'package:dart_rss/dart_rss.dart';
import 'package:http/http.dart';

class TibRss {
  static Future<RssFeed> getWarningFeed() async {
    final request = await get(Uri.parse(
        "https://www.tib.org/es/avisos/-/asset_publisher/MvaiWwqbYsHv/rss"));
    return RssFeed.parse(request.body);
  }

  static Future<RssFeed> getNewsFeed() async {
    final request = await get(Uri.parse(
        "https://www.tib.org/es/noticias/-/asset_publisher/NIwXxcBhaMlh/rss"));
    return RssFeed.parse(request.body);
  }
}

class TibWarningScraper {
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
