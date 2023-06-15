import 'dart:html';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:racketscore/config/api_config.dart';
import 'package:racketscore/config/colors.dart';
import '../../config/strings.dart';
import '../../data/appwrite_service.dart';
import '../../model/models.dart';
import '../base_page.dart';

class ResultPage extends StatefulWidget {
  final String matchId;

  const ResultPage({super.key, required this.matchId});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends BasePageState<ResultPage> {
  late final AppwriteService _appwrite;
  final ScrollController _scrollController = ScrollController();
  late MatchDto _match = MatchDto(id: "", authorId: "", matchName: "");
  bool _isFullScreen = false;

  double _fullScreenSize = 0;

  @override
  void initState() {
    _appwrite = context.read<AppwriteService>();
    super.initState();
  }

  @override
  void loadData() async {
    Document? matchDoc = await _appwrite.getMatch(documentId: widget.matchId);
    if (matchDoc != null) {
      setState(() {
        _match = MatchDto.fromJson(matchDoc.data, matchDoc.$id);
      });
    } else {
      showSnackBar(Strings.eventNotFound, context);
    }
    final realtime = Realtime(_appwrite.client);
    final subscription = realtime.subscribe([
      'databases.${ApiConfig.databaseId}.collections.${ApiConfig.collectionId}.documents.${widget.matchId}'
    ]);
    subscription.stream.listen((response) {
      print(response.payload);
      setState(() {
        _match = MatchDto.fromJson(response.payload, response.payload['\$id']);
      });
    });
    super.loadData();
  }

  @override
  Widget build(BuildContext context) {
    if(_isFullScreen) {
      if (MediaQuery.of(context).size.width != _fullScreenSize) {
        _isFullScreen = false;
      }
    }
    return Scaffold(
      appBar: null,
      backgroundColor: AppColors.lightGray,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    Visibility(
                      visible: !_isFullScreen ?? true,
                      child: IconButton(
                        icon: Icon(Icons.fullscreen),
                        onPressed: () {
                          document.documentElement?.requestFullscreen();
                          _fullScreenSize = MediaQuery.of(context).size.width;
                        },
                      ),
                    ),
                  ],
                )),
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                  color: Color(0xffffffff),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: _buildResultController(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///Result Controller
  Widget _buildResultController() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          _match.matchName,
          style: TextStyle(
              fontSize: isMobile ? 20 : 50,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDarkBold),
        ),
        const SizedBox(height: 10),
        Visibility(
            visible: _match.hasFinished,
            child: const Text(
              Strings.eventFinished,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.darkGray),
            )),
        const SizedBox(height: 10),
        Visibility(
          visible: !isDesktop,
          child: Text(
            _match.teamAName,
            style: TextStyle(
                fontSize: isMobile ? 20 : 50, color: AppColors.primary),
          ),
        ),
        SizedBox(height: 12),
        Scrollbar(
          thumbVisibility: true,
          controller: _scrollController,
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(top: 18.0, bottom: 18),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Visibility(
                    visible: isDesktop,
                    child: _buildMobileTeamsComponent(
                        teamA: _match.teamAName, teamB: _match.teamBName),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Row(
                    children: List.generate(_match.teamAGames.length, (index) {
                      return _buildSetComponent(index,
                          resultTeamA: _match.teamAGames[index],
                          resultTeamB: _match.teamBGames[index]);
                    }),
                  ),
                  _buildGameComponent(
                      resultTeamA: _match.teamAPoints,
                      resultTeamB: _match.teamBPoints),
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: !isDesktop,
          child: Text(
            _match.teamBName,
            style: TextStyle(
                fontSize: isMobile ? 20 : 50, color: AppColors.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileTeamsComponent(
      {required String teamA, required String teamB}) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            teamA,
            style: TextStyle(
                fontSize: isMobile ? 20 : 50, color: AppColors.primary),
          ),
          SizedBox(height: 40),
          Text(teamB,
              style: TextStyle(
                  fontSize: isMobile ? 20 : 50, color: AppColors.primary))
        ],
      ),
    );
  }

  Widget _buildSetComponent(int index,
      {required int resultTeamA, required int resultTeamB}) {
    return Padding(
      padding: const EdgeInsets.only(right: 18.0),
      child: Container(
          decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Text(
                  resultTeamA.toString(),
                  style: TextStyle(
                      fontSize: isMobile ? 20 : 50, color: AppColors.primary),
                ),
                SizedBox(height: 14),
                Text(resultTeamB.toString(),
                    style: TextStyle(
                        fontSize: isMobile ? 20 : 50,
                        color: AppColors.primary)),
              ],
            ),
          )),
    );
  }

  Widget _buildGameComponent(
      {required int resultTeamA, required int resultTeamB}) {
    return Container(
        decoration: const BoxDecoration(
            color: AppColors.primaryLightBold,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Text(resultTeamA.toString(),
                  style: TextStyle(
                      fontSize: isMobile ? 20 : 50, color: AppColors.primary)),
              SizedBox(height: 14),
              Text(
                resultTeamB.toString(),
                style: TextStyle(
                    fontSize: isMobile ? 20 : 50, color: AppColors.primary),
              ),
            ],
          ),
        ));
  }
}
