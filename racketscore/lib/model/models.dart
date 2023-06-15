class MatchDto {
  String id;
  String teamAName;
  String teamBName;
  List<int> teamAGames;
  List<int> teamBGames;
  int teamAPoints;
  int teamBPoints;
  int setsToWin;
  List<int> teamATieBreakPoints;
  List<int> teamBTieBreakPoints;
  String authorId;
  String matchName;
  bool hasFinished;


  MatchDto(
      {required this.id,
        this.teamAName = "Team A",
      this.teamBName = "Team B",
      this.teamAGames = const [0],
      this.teamBGames = const [0],
      this.teamAPoints = 0,
      this.teamBPoints = 0,
      this.setsToWin = 2,
      this.teamATieBreakPoints = const [0],
      this.teamBTieBreakPoints = const [0],
      required this.authorId,
      required this.matchName,
      this.hasFinished = false});

  void decrementAPoints() {
    switch (teamAPoints) {
      case 41:
        teamAPoints = 40;
        break;
      case 40:
        teamAPoints = 30;
        break;
      case 30:
        teamAPoints = 15;
        break;
      case 15:
        teamAPoints = 0;
        break;
      case 0:
        teamAPoints = 40;
        break;
      default:
        teamAPoints = 0;
        break;
    }
  }

  void decrementBPoints() {
    switch (teamBPoints) {
      case 41:
        teamBPoints = 40;
        break;
      case 40:
        teamBPoints = 30;
        break;
      case 30:
        teamBPoints = 15;
        break;
      case 15:
        teamBPoints = 0;
        break;
      case 0:
        teamBPoints = 40;
        break;
      default:
        teamBPoints = 0;
        break;
    }
  }

  void incrementAPoints() {
    switch (teamAPoints) {
      case 41:
        teamBPoints = 0;
        teamAPoints = 0;
        incrementAGames(teamAGames.length - 1);
        break;
      case 40:
        if (teamBPoints == 40) {
          teamAPoints = 41;
        } else if (teamBPoints == 41) {
          teamBPoints = 40;
        } else {
          teamBPoints = 0;
          teamAPoints = 0;
          incrementAGames(teamAGames.length - 1);
        }
        break;
      case 30:
        teamAPoints = 40;
        break;
      case 15:
        teamAPoints = 30;
        break;
      case 0:
        teamAPoints = 15;
        break;
      default:
        teamAPoints = 0;
        break;
    }
  }

  void incrementBPoints() {
    switch (teamBPoints) {
      case 41:
        incrementBGames(teamBGames.length - 1);
        teamBPoints = 0;
        teamAPoints = 0;
        break;
      case 40:
        if (teamAPoints == 40) {
          teamBPoints = 41;
        } else if (teamAPoints == 41) {
          teamAPoints = 40;
        } else {
          incrementBGames(teamBGames.length - 1);
          teamBPoints = 0;
          teamAPoints = 0;
        }
        break;
      case 30:
        teamBPoints = 40;
        break;
      case 15:
        teamBPoints = 30;
        break;
      case 0:
        teamBPoints = 15;
        break;
      default:
        teamBPoints = 0;
        break;
    }
  }

  void incrementAGames(int index) {
    teamAGames[index]++;
    hasFinished = hasTeamAWon() || hasTeamBWon();
    if (hasFinished) return;
    //start new set
    if (teamAGames[index] >= 6 &&
        teamAGames[index] - teamBGames[index] >= 2 &&
        teamAGames.length == index + 1) {
      teamAGames.add(0);
      teamBGames.add(0);
    }
    //start new after tie break
    if (teamAGames[index] == 7 &&
        teamBGames[index] == 6 &&
        teamAGames.length == index + 1) {
      teamAGames.add(0);
      teamBGames.add(0);
    }
  }

  void incrementBGames(int index) {
    teamBGames[index]++;
    hasFinished = hasTeamAWon() || hasTeamBWon();
    if (hasFinished) return;
    //start new set
    if (teamBGames[index] >= 6 &&
        teamBGames[index] - teamAGames[index] >= 2 &&
        teamBGames.length == index + 1) {
      teamAGames.add(0);
      teamBGames.add(0);
    }
    //start new after tie break
    if (teamBGames[index] == 7 &&
        teamAGames[index] == 6 &&
        teamAGames.length == index + 1) {
      teamAGames.add(0);
      teamBGames.add(0);
    }
  }

  void decrementAGames(int index) {
    if (teamAGames[index] != 0) {
      teamAGames[index]--;
    } else {
      teamAGames[index] = 6;
    }
    hasFinished = hasTeamAWon() || hasTeamBWon();
  }

  void decrementBGames(int index) {
    if (teamBGames[index] != 0) {
      teamBGames[index]--;
    } else {
      teamBGames[index] = 6;
    }
    hasFinished = hasTeamAWon() || hasTeamBWon();
  }

  bool hasTeamAWon() {
    int setsWon = 0;
    for (int index = 0; index < teamAGames.length; index++) {
      if (teamAGames[index] >= 6 &&
          teamAGames[index] - teamBGames[index] >= 2) {
        setsWon++;
      }
      if (teamAGames[index] == 7 && teamBGames[index] == 6) {
        setsWon++;
      }
    }
    if (setsWon >= setsToWin) {
      return true;
    }
    return false;
  }

  bool hasTeamBWon() {
    int setsWon = 0;
    for (int index = 0; index < teamBGames.length; index++) {
      if (teamBGames[index] >= 6 &&
          teamBGames[index] - teamAGames[index] >= 2) {
        setsWon++;
      }
      if (teamBGames[index] == 7 && teamAGames[index] == 6) {
        setsWon++;
      }
    }
    if (setsWon >= setsToWin) {
      return true;
    }
    return false;
  }

  toMap() {
    return {
      'team_a_name': teamAName,
      'team_b_name': teamBName,
      'team_a_games': teamAGames,
      'team_b_games': teamBGames,
      'team_a_points': teamAPoints,
      'team_b_points': teamBPoints,
      'sets_to_win': setsToWin,
      'team_a_tie_break_points': teamATieBreakPoints,
      'team_b_tie_break_points': teamBTieBreakPoints,
      'author_id': authorId,
      'match_name': matchName,
      'has_finished': hasFinished
    };
  }

  factory MatchDto.fromJson(Map<String, dynamic> json, String id) {
    return MatchDto(
      id: id,
      teamAName: json['team_a_name'],
      teamBName: json['team_b_name'],
      teamAGames: json['team_a_games'].cast<int>(),
      teamBGames: json['team_b_games'].cast<int>(),
      teamAPoints: json['team_a_points'],
      teamBPoints: json['team_b_points'],
      setsToWin: json['sets_to_win'],
      teamATieBreakPoints: json['team_a_tie_break_points'].cast<int>(),
      teamBTieBreakPoints: json['team_b_tie_break_points'].cast<int>(),
      authorId: json['author_id'],
      matchName: json['match_name'],
      hasFinished: json['has_finished'],
    );
  }
}

class MatchSetDto {
  int teamAGames;
  int teamBGames;

  MatchSetDto({required this.teamAGames, required this.teamBGames});
}
