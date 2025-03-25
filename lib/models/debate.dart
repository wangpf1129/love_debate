import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:love_debate/models/enums.dart';

part 'debate.freezed.dart';
part 'debate.g.dart';

@freezed
sealed class Bot with _$Bot {
  const factory Bot({
    @JsonKey(name: 'bot_id') required String botId,
    @JsonKey(name: 'bot_name') required String botName,
    @JsonKey(name: 'bot_avatar') required String botAvatar,
    @JsonKey(name: 'bot_description') required String botDescription,
  }) = _Bot;

  factory Bot.fromJson(Map<String, dynamic> json) => _$BotFromJson(json);

  factory Bot.empty() {
    return const Bot(
      botId: '',
      botName: '',
      botDescription: '',
      botAvatar: '',
    );
  }
}

@freezed
sealed class Judge with _$Judge {
  const factory Judge({
    @JsonKey(name: 'bot_id') required String botId,
    @JsonKey(name: 'bot_name') required String botName,
    @JsonKey(name: 'bot_avatar') required String botAvatar,
    @JsonKey(name: 'bot_description') required String botDescription,
    String? content,
  }) = _Judge;

  factory Judge.fromJson(Map<String, dynamic> json) => _$JudgeFromJson(json);
}

@freezed
sealed class Debater with _$Debater {
  @JsonSerializable(createToJson: true)
  const factory Debater({
    required String id,
    String? avatar,
    required String nickname,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'standpoint') required DebateStandpoint standpoint,
    @JsonKey(name: 'standpoint_view') required String standpointView,
    @JsonKey(name: 'is_winner') required int isWinner,
    @JsonKey(name: 'is_escape') required int isEscape,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'is_ready') required int isReady,
    @Default([]) List<Bot> bots,
  }) = _Debater;

  factory Debater.fromJson(Map<String, dynamic> json) =>
      _$DebaterFromJson(json);
}

@freezed
sealed class DebateItem with _$DebateItem {
  @JsonSerializable(createToJson: true)
  const factory DebateItem({
    required String id,
    @JsonKey(name: 'theme_id') required String themeId,
    @JsonKey(name: 'theme_title') required String themeTitle,
    @JsonKey(name: 'state') required DebateState state,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'winner_user_id') required String winnerUserId,
    required int rounds,
    required List<Judge> judges,
    required Debater opponent,
    required Debater my,
    @JsonKey(name: 'pros_energies') required int prosEnergies,
    @JsonKey(name: 'cons_energies') required int consEnergies,
    @JsonKey(name: 'result_text') required String resultText,
    required DebateResult result,
  }) = _DebateItem;

  factory DebateItem.fromJson(Map<String, dynamic> json) =>
      _$DebateItemFromJson(json);
}

@freezed
sealed class DebateRecord with _$DebateRecord {
  @JsonSerializable(createToJson: true)
  const factory DebateRecord({
    required String id,
    @JsonKey(name: 'theme_id') required String themeId,
    @JsonKey(name: 'theme_title') required String themeTitle,
    @JsonKey(name: 'state') required DebateState state,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'winner_user_id') String? winnerUserId,
    required int rounds,
    @Default([]) List<Judge> judges,
    required Debater opponent,
    required Debater my,
    @JsonKey(name: 'pros_energies') required int prosEnergies,
    @JsonKey(name: 'cons_energies') required int consEnergies,
    @JsonKey(name: 'result_text') String? resultText,
    required DebateResult result,
  }) = _DebateRecord;

  factory DebateRecord.fromJson(Map<String, dynamic> json) =>
      _$DebateRecordFromJson(json);
}

@freezed
sealed class MatchDebate with _$MatchDebate {
  const factory MatchDebate({
    required String id,
    @JsonKey(name: 'theme_id') required String themeId,
    @JsonKey(name: 'theme_title') required String themeTitle,
    @JsonKey(name: 'state') required DebateState state,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'finished_at') String? finishedAt,
    @JsonKey(name: 'standpoint') required DebateStandpoint standpoint,
    @JsonKey(name: 'standpoint_view') required String standpointView,
    required List<Judge> judges,
  }) = _MatchDebate;

  factory MatchDebate.fromJson(Map<String, dynamic> json) =>
      _$MatchDebateFromJson(json);
}

@freezed
sealed class BotWithSort with _$BotWithSort {
  const factory BotWithSort({
    required int sort,
    @JsonKey(name: 'bot_id') required String botId,
    @JsonKey(name: 'bot_name') required String botName,
    @JsonKey(name: 'bot_avatar') required String botAvatar,
    @JsonKey(name: 'bot_description') required String botDescription,
  }) = _BotWithSort;

  factory BotWithSort.fromJson(Map<String, dynamic> json) =>
      _$BotWithSortFromJson(json);

  factory BotWithSort.empty() {
    return const BotWithSort(
      sort: 0,
      botId: '',
      botName: '',
      botAvatar: '',
      botDescription: '',
    );
  }
}

@freezed
sealed class DebateRound with _$DebateRound {
  const factory DebateRound({
    required String id,
    @JsonKey(name: 'fight_id') required String fightId,
    @JsonKey(name: 'bot_id') required String botId,
    @JsonKey(name: 'content') required String content,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'rounds') required int rounds,
    @JsonKey(name: 'energies') required int energies,
    @JsonKey(name: 'standpoint') required DebateStandpoint standpoint,
    @JsonKey(name: 'bot') required BotWithSort bot,
  }) = _DebateRound;

  factory DebateRound.fromJson(Map<String, dynamic> json) =>
      _$DebateRoundFromJson(json);
}

@freezed
sealed class BotPayload with _$BotPayload {
  const factory BotPayload({
    @JsonKey(name: 'bot_id') required String botId,
    @JsonKey(name: 'bot_name') required String botName,
    required int sort,
  }) = _BotPayload;

  factory BotPayload.fromJson(Map<String, dynamic> json) =>
      _$BotPayloadFromJson(json);
}

@freezed
sealed class CreatePayload with _$CreatePayload {
  const factory CreatePayload({
    required String tactics,
    required List<BotPayload> bots,
  }) = _CreatePayload;

  factory CreatePayload.fromJson(Map<String, dynamic> json) =>
      _$CreatePayloadFromJson(json);
}
