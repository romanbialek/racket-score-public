import 'package:flutter/material.dart';
import 'package:racketscore/view/guest_pages/sign_in_page.dart';
import '../../config/colors.dart';
import '../../config/strings.dart';
import '../base_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends BasePageState<WelcomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: null,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => SignInPage()));
                  },
                  child: Text(
                    "Sign in",
                    style: TextStyle(fontSize: 22),
                  ),
                ),
              ),
            ),
            Expanded(
                child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.sports_baseball_rounded, color: AppColors.primary, size: 30),
                    SizedBox(width: 12),
                    Text(Strings.appTitle, style: TextStyle(color: AppColors.primary, fontSize: 30)),
                  ],
                ),
                const SizedBox(height: 30),
                const Text("1. Sign in",
                    style: TextStyle(fontSize: 22, color: AppColors.darkGray)),
                const Text("2. Create a match",
                    style: TextStyle(fontSize: 22, color: AppColors.darkGray)),
                const Text("3. Share the real-time result!",
                    style: TextStyle(fontSize: 22, color: AppColors.darkGray)),
                const SizedBox(height: 30),
                _buildResultController(),
              ],
            )),
          ],
        ),
      ),
    );
  }

  ///Result Controller
  _buildResultController() {
    return Container(
        decoration: BoxDecoration(
            color: Color(0xffffffff),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  "Olympics Final",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDarkBold),
                ),
                SizedBox(height: 20),
                Visibility(
                  visible: !isDesktop,
                  child: const Text(
                    "Team A",
                    style: TextStyle(fontSize: 20, color: AppColors.primary),
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
                                teamA: "Team A", teamB: "Team B"),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Row(
                            children: List.generate(2, (index) {
                              return _buildSetComponent(index,
                                  resultTeamA: 0, resultTeamB: 0);
                            }),
                          ),
                          _buildGameComponent(resultTeamA: 15, resultTeamB: 30),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: !isDesktop,
                  child: const Text(
                    "Team B",
                    style: TextStyle(
                        fontSize: 20 , color: AppColors.primary),
                  ),
                ),
              ],
            )));
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
            style: const TextStyle(fontSize: 20, color: AppColors.primary),
          ),
          const SizedBox(height: 40),
          Text(teamB,
              style: const TextStyle(fontSize: 20, color: AppColors.primary))
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
                  style:
                      const TextStyle(fontSize: 20, color: AppColors.primary),
                ),
                SizedBox(height: 14),
                Text(resultTeamB.toString(),
                    style: const TextStyle(
                        fontSize: 20, color: AppColors.primary)),
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
                  style:
                      const TextStyle(fontSize: 20, color: AppColors.primary)),
              SizedBox(height: 14),
              Text(
                resultTeamB.toString(),
                style: const TextStyle(fontSize: 20, color: AppColors.primary),
              ),
            ],
          ),
        ));
  }
}
