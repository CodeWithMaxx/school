import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  launchURL(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      launchUrl(Uri.parse(RedirectURl.toString()));
    });
    getApiData();
    super.initState();
  }

  String? RedirectURl;
  String? logoURL;

  Future<String> getApiData() async {
    final client = http.Client();

    var response = await client
        .post(Uri.parse("http://students.wissenerp.com/Login/get_logo"));

    if (response.statusCode == 200) {
      Map apiResponseData = jsonDecode(response.body);

      logoURL = apiResponseData['logo_url'];

      RedirectURl = apiResponseData["redirect_url"];

      return logoURL.toString();
    }

    return RedirectURl.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getApiData(),
          builder: (context, snapshot) {
            return Center(
              child: CachedNetworkImage(
                imageUrl: logoURL.toString(),
                height: 300,
                width: 300,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            );
          }),
    );
  }
}
