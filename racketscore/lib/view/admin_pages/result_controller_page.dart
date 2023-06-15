import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:racketscore/config/api_config.dart';
import 'package:racketscore/config/colors.dart';
import '../../config/strings.dart';
import '../../data/appwrite_service.dart';
import '../../model/models.dart';
import '../base_page.dart';

class ResultControllerPage extends StatefulWidget {
  final MatchDto match;

  const ResultControllerPage({super.key, required this.match});

  @override
  State<ResultControllerPage> createState() => _ResultControllerPageState();
}

class _ResultControllerPageState extends BasePageState<ResultControllerPage> {
  late final AppwriteService _appwrite;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _appwrite = context.read<AppwriteService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildResultController(),
                    SizedBox(height: 20),
                    _buildResultOptions()
                  ],
                ),
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
          widget.match.matchName,
          style: TextStyle(
              fontSize: isMobile ? 20 : 50,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark),
        ),
        const SizedBox(height: 10),
        Visibility(
            visible: widget.match.hasFinished,
            child: const Text(
              Strings.eventFinished,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.darkGray),
            )),
        const SizedBox(height: 10),
        Visibility(
          visible: !isDesktop,
          child: Text(
            widget.match.teamAName,
            style: TextStyle(
                fontSize: isMobile ? 20 : 50, color: AppColors.primaryDark),
          ),
        ),
        const SizedBox(height: 12),
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
                        teamA: widget.match.teamAName,
                        teamB: widget.match.teamBName),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Row(
                    children:
                        List.generate(widget.match.teamAGames.length, (index) {
                      return _buildSetComponent(index,
                          resultTeamA: widget.match.teamAGames[index],
                          resultTeamB: widget.match.teamBGames[index]);
                    }),
                  ),
                  _buildGameComponent(
                      resultTeamA: widget.match.teamAPoints,
                      resultTeamB: widget.match.teamBPoints),
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: !isDesktop,
          child: Text(
            widget.match.teamBName,
            style: TextStyle(
                fontSize: isMobile ? 20 : 50, color: AppColors.primaryDark),
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
                fontSize: isMobile ? 20 : 50, color: AppColors.primaryDark),
          ),
          SizedBox(height: 40),
          Text(teamB,
              style: TextStyle(
                  fontSize: isMobile ? 20 : 50, color: AppColors.primaryDark))
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
                IconButton(
                  icon: const Icon(Icons.arrow_drop_up),
                  onPressed: () {
                    setState(() {
                      widget.match.incrementAGames(index);
                      _appwrite.updateMatch(match: widget.match);
                    });
                  },
                ),
                Text(
                  resultTeamA.toString(),
                  style: TextStyle(
                      fontSize: isMobile ? 20 : 50,
                      color: AppColors.primaryDark),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_drop_down),
                  onPressed: () {
                    setState(() {
                      widget.match.decrementAGames(index);
                      _appwrite.updateMatch(match: widget.match);
                    });
                  },
                ),
                SizedBox(height: 14),
                IconButton(
                  icon: Icon(Icons.arrow_drop_up),
                  onPressed: () {
                    setState(() {
                      widget.match.incrementBGames(index);
                      _appwrite.updateMatch(match: widget.match);
                    });
                  },
                ),
                Text(resultTeamB.toString(),
                    style: TextStyle(
                        fontSize: isMobile ? 20 : 50,
                        color: AppColors.primaryDark)),
                IconButton(
                  icon: Icon(Icons.arrow_drop_down),
                  onPressed: () {
                    setState(() {
                      widget.match.decrementBGames(index);
                      _appwrite.updateMatch(match: widget.match);
                    });
                  },
                ),
              ],
            ),
          )),
    );
  }

  Widget _buildGameComponent(
      {required int resultTeamA, required int resultTeamB}) {
    return Container(
        decoration: BoxDecoration(
            color: AppColors.primaryLightBold,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_drop_up),
                onPressed: () {
                  setState(() {
                    widget.match.incrementAPoints();
                    _appwrite.updateMatch(match: widget.match);
                  });
                },
              ),
              Text(resultTeamA.toString(),
                  style: TextStyle(
                      fontSize: isMobile ? 20 : 50,
                      color: AppColors.primaryDark)),
              IconButton(
                icon: Icon(Icons.arrow_drop_down),
                onPressed: () {
                  setState(() {
                    widget.match.decrementAPoints();
                    _appwrite.updateMatch(match: widget.match);
                  });
                },
              ),
              SizedBox(height: 14),
              IconButton(
                icon: Icon(Icons.arrow_drop_up),
                onPressed: () {
                  setState(() {
                    widget.match.incrementBPoints();
                    _appwrite.updateMatch(match: widget.match);
                  });
                },
              ),
              Text(
                resultTeamB.toString(),
                style: TextStyle(
                    fontSize: isMobile ? 20 : 50,
                    color: AppColors.primaryDarkBold),
              ),
              IconButton(
                icon: Icon(Icons.arrow_drop_down),
                onPressed: () {
                  setState(() {
                    widget.match.decrementBPoints();
                    _appwrite.updateMatch(match: widget.match);
                  });
                },
              ),
            ],
          ),
        ));
  }

  ///Result Options
  Widget _buildResultOptions() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                window.open(ApiConfig.appUrl + '?event=${widget.match.id}',
                    Strings.newTabTitle);
              },
              child: Text(
                Strings.previewInNewTab,
              ),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(
                    text: ApiConfig.appUrl + '?event=${widget.match.id}'));
                showSnackBar(Strings.linkCopied, context);
              },
              child: Text(
                Strings.copyLink,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
