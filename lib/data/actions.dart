import 'dart:io';
import 'package:krarkulator/everything.dart';
import 'package:url_launcher/url_launcher.dart';

class KRActions{

  static void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  } 
  static void reviewCounterSpell() async {
    _launchUrl(Platform.isAndroid 
      ? KRUris.counterSpellPlayStore : KRUris.counterSpellAppStore
    );
  }
  static void mailMe([String body = ""]) async {
    _launchUrl(KRUris.mailAction + "&body=$body");
  }
  static void chatWithMe() async {
    _launchUrl(KRUris.telegramGroup);
  }
  static void openDiscordInvite() async {
    _launchUrl(KRUris.discordInvite);
  }
  static void githubPage() async {
    _launchUrl(KRUris.githubPage);
  }

}