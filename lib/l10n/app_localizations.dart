import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_cs.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('cs'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'EROS'**
  String get appTitle;

  /// No description provided for @newPartyGame.
  ///
  /// In en, this message translates to:
  /// **'🎉 New Party Game'**
  String get newPartyGame;

  /// No description provided for @continuePartyGame.
  ///
  /// In en, this message translates to:
  /// **'▶️ Continue Party Game'**
  String get continuePartyGame;

  /// No description provided for @taskManager.
  ///
  /// In en, this message translates to:
  /// **'🛠 Task Manager'**
  String get taskManager;

  /// No description provided for @partnerMode.
  ///
  /// In en, this message translates to:
  /// **'❤️ Partner Mode'**
  String get partnerMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @czech.
  ///
  /// In en, this message translates to:
  /// **'🇨🇿 Czech'**
  String get czech;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'🇺🇸 English'**
  String get english;

  /// No description provided for @newPartyGamePlayers.
  ///
  /// In en, this message translates to:
  /// **'New Party Game – Players'**
  String get newPartyGamePlayers;

  /// No description provided for @playerName.
  ///
  /// In en, this message translates to:
  /// **'Player Name'**
  String get playerName;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @addPlayer.
  ///
  /// In en, this message translates to:
  /// **'Add Player'**
  String get addPlayer;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @enterPlayerName.
  ///
  /// In en, this message translates to:
  /// **'Enter player name'**
  String get enterPlayerName;

  /// No description provided for @playerNotParticipating.
  ///
  /// In en, this message translates to:
  /// **'is not participating'**
  String get playerNotParticipating;

  /// No description provided for @partyConsentTitle.
  ///
  /// In en, this message translates to:
  /// **'Game Consent'**
  String get partyConsentTitle;

  /// No description provided for @partyConsentText.
  ///
  /// In en, this message translates to:
  /// **'this party game is intimate, voluntary and may contain erotic elements, undressing and physical closeness.\n\nYou can say NO at any time.\nDo you agree to participate?'**
  String get partyConsentText;

  /// No description provided for @agree.
  ///
  /// In en, this message translates to:
  /// **'Agree'**
  String get agree;

  /// No description provided for @disagree.
  ///
  /// In en, this message translates to:
  /// **'Disagree'**
  String get disagree;

  /// No description provided for @latestTasks.
  ///
  /// In en, this message translates to:
  /// **'Latest'**
  String get latestTasks;

  /// No description provided for @topTasks.
  ///
  /// In en, this message translates to:
  /// **'Top Rated'**
  String get topTasks;

  /// No description provided for @partyGame.
  ///
  /// In en, this message translates to:
  /// **'Party Game'**
  String get partyGame;

  /// No description provided for @currentTurn.
  ///
  /// In en, this message translates to:
  /// **'Current Turn'**
  String get currentTurn;

  /// No description provided for @naked.
  ///
  /// In en, this message translates to:
  /// **'naked'**
  String get naked;

  /// No description provided for @youRemove.
  ///
  /// In en, this message translates to:
  /// **'You remove:'**
  String get youRemove;

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// No description provided for @refuse.
  ///
  /// In en, this message translates to:
  /// **'Refuse'**
  String get refuse;

  /// No description provided for @saveAndExit.
  ///
  /// In en, this message translates to:
  /// **'Save and Exit'**
  String get saveAndExit;

  /// No description provided for @fullyNakedPlayers.
  ///
  /// In en, this message translates to:
  /// **'🔥 Completely Naked Players'**
  String get fullyNakedPlayers;

  /// No description provided for @rescueApproved.
  ///
  /// In en, this message translates to:
  /// **'Rescue approved!'**
  String get rescueApproved;

  /// No description provided for @rescueDenied.
  ///
  /// In en, this message translates to:
  /// **'Rescue denied!'**
  String get rescueDenied;

  /// No description provided for @rescueDeniedText.
  ///
  /// In en, this message translates to:
  /// **'Don\'t worry! There will be another vote in 5 rounds. Try to convince others next round!'**
  String get rescueDeniedText;

  /// No description provided for @rescueSelectFirst.
  ///
  /// In en, this message translates to:
  /// **'Rescue: Select 1st clothing'**
  String get rescueSelectFirst;

  /// No description provided for @chooseClothing.
  ///
  /// In en, this message translates to:
  /// **'Choose clothing'**
  String get chooseClothing;

  /// No description provided for @selectClothing.
  ///
  /// In en, this message translates to:
  /// **'Click clothing you want to wear:'**
  String get selectClothing;

  /// No description provided for @boxers.
  ///
  /// In en, this message translates to:
  /// **'Boxers'**
  String get boxers;

  /// No description provided for @bra.
  ///
  /// In en, this message translates to:
  /// **'Bra'**
  String get bra;

  /// No description provided for @pants.
  ///
  /// In en, this message translates to:
  /// **'Pants'**
  String get pants;

  /// No description provided for @shoes.
  ///
  /// In en, this message translates to:
  /// **'Shoes'**
  String get shoes;

  /// No description provided for @tshirt.
  ///
  /// In en, this message translates to:
  /// **'T-Shirt'**
  String get tshirt;

  /// No description provided for @hoodie.
  ///
  /// In en, this message translates to:
  /// **'Hoodie'**
  String get hoodie;

  /// No description provided for @socks.
  ///
  /// In en, this message translates to:
  /// **'Socks'**
  String get socks;

  /// No description provided for @panties.
  ///
  /// In en, this message translates to:
  /// **'Panties'**
  String get panties;

  /// No description provided for @sweater.
  ///
  /// In en, this message translates to:
  /// **'Sweater'**
  String get sweater;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @gameDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Game Difficulty'**
  String get gameDifficulty;

  /// No description provided for @difficultyEasy.
  ///
  /// In en, this message translates to:
  /// **'1 – Gentle'**
  String get difficultyEasy;

  /// No description provided for @difficultyMedium.
  ///
  /// In en, this message translates to:
  /// **'2 – Bold'**
  String get difficultyMedium;

  /// No description provided for @difficultyHard.
  ///
  /// In en, this message translates to:
  /// **'3 – No Limits'**
  String get difficultyHard;

  /// No description provided for @startGame.
  ///
  /// In en, this message translates to:
  /// **'Start Game'**
  String get startGame;

  /// No description provided for @partyConsentScreenText.
  ///
  /// In en, this message translates to:
  /// **'This party game is intimate, voluntary and may contain erotic elements, undressing and physical closeness.\n\nEvery player has the right to say NO at any time.\nRespect is more important than the game itself.\n\nContinue only if all participants agree.'**
  String get partyConsentScreenText;

  /// No description provided for @taskManagerTitle.
  ///
  /// In en, this message translates to:
  /// **'🛠️ Task Manager'**
  String get taskManagerTitle;

  /// No description provided for @noTasksYet.
  ///
  /// In en, this message translates to:
  /// **'There are no tasks yet'**
  String get noTasksYet;

  /// No description provided for @addTask.
  ///
  /// In en, this message translates to:
  /// **'➕ Add Task'**
  String get addTask;

  /// No description provided for @exportQr.
  ///
  /// In en, this message translates to:
  /// **'📤 Export to QR'**
  String get exportQr;

  /// No description provided for @lastClothing.
  ///
  /// In en, this message translates to:
  /// **'🔥 LAST CLOTHING 🔥'**
  String get lastClothing;

  /// No description provided for @nothingToHide.
  ///
  /// In en, this message translates to:
  /// **'has nothing left to hide'**
  String get nothingToHide;

  /// No description provided for @rescueTitle.
  ///
  /// In en, this message translates to:
  /// **'🛟 RESCUE'**
  String get rescueTitle;

  /// No description provided for @givePhoneToPlayer.
  ///
  /// In en, this message translates to:
  /// **'Give the phone to this player:'**
  String get givePhoneToPlayer;

  /// No description provided for @rescueQuestion.
  ///
  /// In en, this message translates to:
  /// **'Do you want to rescue the naked player?'**
  String get rescueQuestion;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'YES'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'NO'**
  String get no;

  /// No description provided for @rescuedPlayer.
  ///
  /// In en, this message translates to:
  /// **'Rescued player:'**
  String get rescuedPlayer;

  /// No description provided for @votingPlayer.
  ///
  /// In en, this message translates to:
  /// **'Voting player:'**
  String get votingPlayer;

  /// No description provided for @partnerModeTitle.
  ///
  /// In en, this message translates to:
  /// **'❤️ PARTNER MODE ❤️'**
  String get partnerModeTitle;

  /// No description provided for @writeScenario.
  ///
  /// In en, this message translates to:
  /// **'✍️ Write New Scenario'**
  String get writeScenario;

  /// No description provided for @readScenario.
  ///
  /// In en, this message translates to:
  /// **'📖 Read Scenario'**
  String get readScenario;

  /// No description provided for @scenarioHistory.
  ///
  /// In en, this message translates to:
  /// **'🕰️ Scenario History'**
  String get scenarioHistory;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'🔐 Connected'**
  String get connected;

  /// No description provided for @notConnected.
  ///
  /// In en, this message translates to:
  /// **'🔐 Not Connected'**
  String get notConnected;

  /// No description provided for @editScenario.
  ///
  /// In en, this message translates to:
  /// **'✏️ Edit Scenario'**
  String get editScenario;

  /// No description provided for @newScenario.
  ///
  /// In en, this message translates to:
  /// **'✍️ New Scenario'**
  String get newScenario;

  /// No description provided for @author.
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get author;

  /// No description provided for @forWho.
  ///
  /// In en, this message translates to:
  /// **'For Who'**
  String get forWho;

  /// No description provided for @scenarioTitle.
  ///
  /// In en, this message translates to:
  /// **'Scenario Title'**
  String get scenarioTitle;

  /// No description provided for @boundaries.
  ///
  /// In en, this message translates to:
  /// **'Boundaries'**
  String get boundaries;

  /// No description provided for @scenarioGoal.
  ///
  /// In en, this message translates to:
  /// **'🎯 Scenario Goal'**
  String get scenarioGoal;

  /// No description provided for @scenarioEmotions.
  ///
  /// In en, this message translates to:
  /// **'What emotions should the scenario evoke?'**
  String get scenarioEmotions;

  /// No description provided for @scenarioText.
  ///
  /// In en, this message translates to:
  /// **'Scenario Text'**
  String get scenarioText;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'💾 Save Changes'**
  String get saveChanges;

  /// No description provided for @generateCode.
  ///
  /// In en, this message translates to:
  /// **'🔐 Generate Code'**
  String get generateCode;

  /// No description provided for @copyCode.
  ///
  /// In en, this message translates to:
  /// **'📋 Copy Code'**
  String get copyCode;

  /// No description provided for @fillRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Fill in all required fields'**
  String get fillRequiredFields;

  /// No description provided for @emotionTenderness.
  ///
  /// In en, this message translates to:
  /// **'Tenderness'**
  String get emotionTenderness;

  /// No description provided for @emotionTrust.
  ///
  /// In en, this message translates to:
  /// **'Trust'**
  String get emotionTrust;

  /// No description provided for @emotionExcitement.
  ///
  /// In en, this message translates to:
  /// **'Excitement'**
  String get emotionExcitement;

  /// No description provided for @emotionPlayfulness.
  ///
  /// In en, this message translates to:
  /// **'Playfulness'**
  String get emotionPlayfulness;

  /// No description provided for @emotionDominance.
  ///
  /// In en, this message translates to:
  /// **'Dominance'**
  String get emotionDominance;

  /// No description provided for @emotionSubmission.
  ///
  /// In en, this message translates to:
  /// **'Submission'**
  String get emotionSubmission;

  /// No description provided for @emotionRomance.
  ///
  /// In en, this message translates to:
  /// **'Romance'**
  String get emotionRomance;

  /// No description provided for @emotionCuriosity.
  ///
  /// In en, this message translates to:
  /// **'Curiosity'**
  String get emotionCuriosity;

  /// No description provided for @openScenario.
  ///
  /// In en, this message translates to:
  /// **'Open Scenario'**
  String get openScenario;

  /// No description provided for @pasteScenarioCode.
  ///
  /// In en, this message translates to:
  /// **'Paste Scenario Code'**
  String get pasteScenarioCode;

  /// No description provided for @pasteFromClipboard.
  ///
  /// In en, this message translates to:
  /// **'📋 Paste From Clipboard'**
  String get pasteFromClipboard;

  /// No description provided for @invalidCode.
  ///
  /// In en, this message translates to:
  /// **'Code is invalid or corrupted'**
  String get invalidCode;

  /// No description provided for @howDoYouFeel.
  ///
  /// In en, this message translates to:
  /// **'How do you feel?'**
  String get howDoYouFeel;

  /// No description provided for @howDoYouDecide.
  ///
  /// In en, this message translates to:
  /// **'What is your decision?'**
  String get howDoYouDecide;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message:'**
  String get message;

  /// No description provided for @attachProof.
  ///
  /// In en, this message translates to:
  /// **'Attach Proof'**
  String get attachProof;

  /// No description provided for @sendReaction.
  ///
  /// In en, this message translates to:
  /// **'💌 Send Reaction'**
  String get sendReaction;

  /// No description provided for @emotionExcited.
  ///
  /// In en, this message translates to:
  /// **'❤️ Excited'**
  String get emotionExcited;

  /// No description provided for @emotionCalm.
  ///
  /// In en, this message translates to:
  /// **'😊 Calm'**
  String get emotionCalm;

  /// No description provided for @emotionTurnedOn.
  ///
  /// In en, this message translates to:
  /// **'🔥 Turned On'**
  String get emotionTurnedOn;

  /// No description provided for @emotionNervous.
  ///
  /// In en, this message translates to:
  /// **'😳 Nervous'**
  String get emotionNervous;

  /// No description provided for @emotionUnsure.
  ///
  /// In en, this message translates to:
  /// **'🤔 Unsure'**
  String get emotionUnsure;

  /// No description provided for @emotionThinking.
  ///
  /// In en, this message translates to:
  /// **'💭 Thinking'**
  String get emotionThinking;

  /// No description provided for @stateWillDo.
  ///
  /// In en, this message translates to:
  /// **'I will do it'**
  String get stateWillDo;

  /// No description provided for @stateMaybeLater.
  ///
  /// In en, this message translates to:
  /// **'maybe later'**
  String get stateMaybeLater;

  /// No description provided for @stateWillNotDo.
  ///
  /// In en, this message translates to:
  /// **'I will not do it'**
  String get stateWillNotDo;

  /// No description provided for @scenarioHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'📚 Scenario History'**
  String get scenarioHistoryTitle;

  /// No description provided for @noScenariosYet.
  ///
  /// In en, this message translates to:
  /// **'No scenarios yet'**
  String get noScenariosYet;

  /// No description provided for @reactions.
  ///
  /// In en, this message translates to:
  /// **'reactions'**
  String get reactions;

  /// No description provided for @partnerLink.
  ///
  /// In en, this message translates to:
  /// **'Partner Connection'**
  String get partnerLink;

  /// No description provided for @linkedSuccess.
  ///
  /// In en, this message translates to:
  /// **'✅ You are connected'**
  String get linkedSuccess;

  /// No description provided for @unlink.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get unlink;

  /// No description provided for @yourCode.
  ///
  /// In en, this message translates to:
  /// **'Your code:'**
  String get yourCode;

  /// No description provided for @enterPartnerCode.
  ///
  /// In en, this message translates to:
  /// **'Enter partner code:'**
  String get enterPartnerCode;

  /// No description provided for @link.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get link;

  /// No description provided for @shareToCommunity.
  ///
  /// In en, this message translates to:
  /// **'Share to community'**
  String get shareToCommunity;

  /// No description provided for @taskShared.
  ///
  /// In en, this message translates to:
  /// **'Task shared with community'**
  String get taskShared;

  /// No description provided for @taskShareFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to share task'**
  String get taskShareFailed;

  /// No description provided for @communityTasks.
  ///
  /// In en, this message translates to:
  /// **'Community Tasks'**
  String get communityTasks;

  /// No description provided for @noCommunityTasks.
  ///
  /// In en, this message translates to:
  /// **'No community tasks have been shared yet'**
  String get noCommunityTasks;

  /// No description provided for @communityLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load community tasks'**
  String get communityLoadError;

  /// No description provided for @likes.
  ///
  /// In en, this message translates to:
  /// **'Likes'**
  String get likes;

  /// No description provided for @importTask.
  ///
  /// In en, this message translates to:
  /// **'Import task'**
  String get importTask;

  /// No description provided for @taskImported.
  ///
  /// In en, this message translates to:
  /// **'Task imported'**
  String get taskImported;

  /// No description provided for @reportTask.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get reportTask;

  /// No description provided for @taskReported.
  ///
  /// In en, this message translates to:
  /// **'Task reported'**
  String get taskReported;

  /// No description provided for @reportTaskQuestion.
  ///
  /// In en, this message translates to:
  /// **'Do you want to report this task?'**
  String get reportTaskQuestion;

  /// No description provided for @taskAlreadyImported.
  ///
  /// In en, this message translates to:
  /// **'This task is already imported'**
  String get taskAlreadyImported;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['cs', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'cs':
      return AppLocalizationsCs();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
