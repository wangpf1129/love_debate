class BaseResponse<T> {
  final int code;
  final String info;
  final T data;

  BaseResponse({
    required this.code,
    required this.info,
    required this.data,
  });

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJson,
  ) {
    return BaseResponse<T>(
      code: json['code'],
      info: json['info'],
      data: fromJson(json['data']),
    );
  }
}

class ListResponse<T> {
  final int code;
  final String info;
  final List<T> data;
  final int count;
  final bool next;
  final bool previous;

  ListResponse({
    required this.code,
    required this.info,
    required this.data,
    required this.count,
    required this.next,
    required this.previous,
  });

  factory ListResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJson,
  ) {
    return ListResponse<T>(
      code: json['code'],
      info: json['info'],
      data: (json['data'] as List).map(fromJson).toList(),
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
    );
  }
}

class Bot {
  final String botId;
  final String botName;
  final String botAvatar;
  final String botDescription;

  Bot({
    required this.botId,
    required this.botName,
    required this.botAvatar,
    required this.botDescription,
  });

  factory Bot.fromJson(Map<String, dynamic> json) {
    return Bot(
      botId: json['bot_id'],
      botName: json['bot_name'],
      botAvatar: json['bot_avatar'],
      botDescription: json['bot_description'],
    );
  }
}

class Judge extends Bot {
  final String content;

  Judge({
    required super.botId,
    required super.botName,
    required super.botAvatar,
    required super.botDescription,
    required this.content,
  });

  factory Judge.fromJson(Map<String, dynamic> json) {
    return Judge(
      botId: json['bot_id'],
      botName: json['bot_name'],
      botAvatar: json['bot_avatar'],
      botDescription: json['bot_description'],
      content: json['content'],
    );
  }
}

class Debater {
  final String id;
  final String? avatar;
  final String nickname;
  final String userId;
  final String standpoint;
  final String standpointView;
  final int isWinner;
  final int isEscape;
  final String createdAt;
  final int isReady;
  final List<Bot> bots;

  Debater({
    required this.id,
    this.avatar,
    required this.nickname,
    required this.userId,
    required this.standpoint,
    required this.standpointView,
    required this.isWinner,
    required this.isEscape,
    required this.createdAt,
    required this.isReady,
    List<Bot>? bots,
  }) : bots = bots ?? [];

  factory Debater.fromJson(Map<String, dynamic> json) {
    return Debater(
      id: json['id'],
      avatar: json['avatar'],
      nickname: json['nickname'],
      userId: json['user_id'],
      standpoint: json['standpoint'],
      standpointView: json['standpoint_view'],
      isWinner: json['is_winner'],
      isEscape: json['is_escape'],
      createdAt: json['created_at'],
      isReady: json['is_ready'],
      bots: json['bots'] != null
          ? (json['bots'] as List).map((b) => Bot.fromJson(b)).toList()
          : [],
    );
  }
}

class DebateItem {
  final String id;
  final String themeId;
  final String themeTitle;
  final String state;
  final String createdAt;
  final String winnerUserId;
  final int rounds;
  final List<Judge> judges;
  final Debater opponent;
  final Debater my;
  final int prosEnergies;
  final int consEnergies;
  final String resultText;
  final String result;

  DebateItem({
    required this.id,
    required this.themeId,
    required this.themeTitle,
    required this.state,
    required this.createdAt,
    required this.winnerUserId,
    required this.rounds,
    required this.judges,
    required this.opponent,
    required this.my,
    required this.prosEnergies,
    required this.consEnergies,
    required this.resultText,
    required this.result,
  });

  factory DebateItem.fromJson(Map<String, dynamic> json) {
    return DebateItem(
      id: json['id'],
      themeId: json['theme_id'],
      themeTitle: json['theme_title'],
      state: json['state'],
      createdAt: json['created_at'],
      winnerUserId: json['winner_user_id'],
      rounds: json['rounds'],
      judges: json['judges'],
      opponent: json['opponent'],
      my: json['my'],
      prosEnergies: json['pros_energies'],
      consEnergies: json['cons_energies'],
      resultText: json['result_text'],
      result: json['result'],
    );
  }
}

class DebateRecord {
  final String id;
  final String themeId;
  final String themeTitle;
  final String state;
  final String createdAt;
  final String? winnerUserId;
  final int rounds;
  final List<Judge> judges;
  final Debater opponent;
  final Debater my;
  final int prosEnergies;
  final int consEnergies;
  final String? resultText;
  final String result;

  DebateRecord({
    required this.id,
    required this.themeId,
    required this.themeTitle,
    required this.state,
    required this.createdAt,
    this.winnerUserId,
    required this.rounds,
    List<Judge>? judges,
    required this.opponent,
    required this.my,
    required this.prosEnergies,
    required this.consEnergies,
    this.resultText,
    required this.result,
  }) : judges = judges ?? [];

  factory DebateRecord.fromJson(Map<String, dynamic> json) {
    return DebateRecord(
      id: json['id'],
      themeId: json['theme_id'],
      themeTitle: json['theme_title'],
      state: json['state'],
      createdAt: json['created_at'],
      winnerUserId: json['winner_user_id'],
      rounds: json['rounds'],
      judges: json['judges'] != null
          ? (json['judges'] as List).map((j) => Judge.fromJson(j)).toList()
          : [],
      opponent: Debater.fromJson(json['opponent']),
      my: Debater.fromJson(json['my']),
      prosEnergies: json['pros_energies'],
      consEnergies: json['cons_energies'],
      resultText: json['result_text'],
      result: json['result'],
    );
  }
}
