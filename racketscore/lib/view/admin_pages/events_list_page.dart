import 'dart:developer';

import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:racketscore/config/colors.dart';
import 'package:racketscore/model/models.dart';
import 'package:racketscore/view/admin_pages/opensource_libraries_page.dart';
import 'package:racketscore/view/admin_pages/result_controller_page.dart';
import '../../config/strings.dart';
import '../widgets/empty_list_widget.dart';
import '../../data/appwrite_service.dart';
import '../base_page.dart';
import '../widgets/new_match_dialog.dart';

class EventsListPage extends StatefulWidget {
  const EventsListPage({super.key});

  @override
  State<EventsListPage> createState() => _EventsListPageState();
}

class _EventsListPageState extends BasePageState<EventsListPage> {
  late final AppwriteService appwrite;
  List<MatchDto> _matches = [];

  @override
  void initState() {
    appwrite = context.read<AppwriteService>();
    super.initState();
  }

  @override
  void loadData() async {
    List<Document> matchesDocs = await appwrite.getMatches() ?? [];
    for (var element in matchesDocs) {
      _matches.add(MatchDto.fromJson(element.data, element.$id));
    }
    if (_matches.isNotEmpty) {
      setState(() {});
    }
    super.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: const Color(0xff00b382),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: AppColors.primary,
              ),
              child: Center(child: Row(
                children: [
                  Icon(Icons.sports_baseball_rounded, color: Colors.white, size: 30),
                  SizedBox(width: 12),
                  Text(Strings.appTitle, style: TextStyle(color: Colors.white, fontSize: 30)),
                ],
              )),
            ),
            ListTile(
              leading: Icon(
                Icons.my_library_books_sharp,
              ),
              title: const Text(Strings.openSourceLibraries),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        OpenSourceLibrariesPage()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
              ),
              title: const Text(Strings.signOut),
              onTap: () async {
                Navigator.pop(context);
                final AppwriteService appwrite =
                    context.read<AppwriteService>();
                await appwrite.signOut();
              },
            ),
          ],
        ),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.secondary,
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return CreateMatchDialog(
                onMatchCreated: (matchName, teamA, teamB, setsToWin) async {
                  Document? newMatchDoc = await appwrite.createMatch(
                      matchName: matchName,
                      teamA: teamA,
                      teamB: teamB,
                      setsToWin: setsToWin);
                  if (newMatchDoc != null) {
                    _matches.insert(0, MatchDto.fromJson(newMatchDoc.data, newMatchDoc.$id));
                    setState(() {});
                  } else {
                    log(Strings.errorCreatingMatch);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: _matches.isEmpty
          ? EmptyListWidget()
          : ListView.builder(
              itemCount: _matches.length, itemBuilder: _buildListItem),
    );
  }

  Widget _buildListItem(context, index) {
    return ListTile(
      title: Text(_matches[index].matchName),
      subtitle: Text("${_matches[index].teamAName} ${Strings.vs} ${_matches[index].teamBName}"),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                ResultControllerPage(match: _matches[index])));
      },
    );
  }
}
