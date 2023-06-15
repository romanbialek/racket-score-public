import 'dart:html';

import 'package:flutter/material.dart';
import 'package:racketscore/view/guest_pages/sign_in_page.dart';

import '../base_page.dart';

class OpenSourceLibrariesPage extends StatefulWidget {
  const OpenSourceLibrariesPage({super.key});

  @override
  State<OpenSourceLibrariesPage> createState() =>
      _OpenSourceLibrariesPageState();
}

class _OpenSourceLibrariesPageState
    extends BasePageState<OpenSourceLibrariesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: null,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  )),
            ),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: Text("Flutter Appwrite"),
                    onTap: () {
                      window.open("https://pub.dev/packages/appwrite", "");
                    },
                  ),
                  ListTile(
                    title: Text("Flutter Provider"),
                    onTap: () {
                      window.open("https://pub.dev/packages/provider", "");
                    },
                  ),
                  ListTile(
                    title: Text("Flutter Collection"),
                    onTap: () {
                      window.open("https://pub.dev/packages/collection", "");
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
