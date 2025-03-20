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
    required String content,
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
    required String result,
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
    @JsonKey(name: 'result') required DebateResult result,
  }) = _DebateRecord;

  factory DebateRecord.fromJson(Map<String, dynamic> json) =>
      _$DebateRecordFromJson(json);
}
