import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

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
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'SecureVault'**
  String get appTitle;

  /// No description provided for @appSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Password Manager'**
  String get appSubtitle;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @myAccount.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get myAccount;

  /// No description provided for @mainCategory.
  ///
  /// In en, this message translates to:
  /// **'Main'**
  String get mainCategory;

  /// No description provided for @tags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tags;

  /// No description provided for @collapse.
  ///
  /// In en, this message translates to:
  /// **'Collapse'**
  String get collapse;

  /// No description provided for @expand.
  ///
  /// In en, this message translates to:
  /// **'Expand'**
  String get expand;

  /// No description provided for @allItems.
  ///
  /// In en, this message translates to:
  /// **'All Items'**
  String get allItems;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @loginInfo.
  ///
  /// In en, this message translates to:
  /// **'Login Info'**
  String get loginInfo;

  /// No description provided for @creditCard.
  ///
  /// In en, this message translates to:
  /// **'Credit Card'**
  String get creditCard;

  /// No description provided for @identity.
  ///
  /// In en, this message translates to:
  /// **'Identity'**
  String get identity;

  /// No description provided for @server.
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get server;

  /// No description provided for @database.
  ///
  /// In en, this message translates to:
  /// **'Database'**
  String get database;

  /// No description provided for @secureDevice.
  ///
  /// In en, this message translates to:
  /// **'Secure Device'**
  String get secureDevice;

  /// No description provided for @wifiPassword.
  ///
  /// In en, this message translates to:
  /// **'WiFi Password'**
  String get wifiPassword;

  /// No description provided for @secureNote.
  ///
  /// In en, this message translates to:
  /// **'Secure Note'**
  String get secureNote;

  /// No description provided for @softwareLicense.
  ///
  /// In en, this message translates to:
  /// **'Software License'**
  String get softwareLicense;

  /// No description provided for @securitySettings.
  ///
  /// In en, this message translates to:
  /// **'Security Settings'**
  String get securitySettings;

  /// No description provided for @autoLockTime.
  ///
  /// In en, this message translates to:
  /// **'Auto Lock Time'**
  String get autoLockTime;

  /// No description provided for @autoLockSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Lock automatically after {minutes} minutes of inactivity'**
  String autoLockSubtitle(int minutes);

  /// No description provided for @biometricAuth.
  ///
  /// In en, this message translates to:
  /// **'Biometric Authentication'**
  String get biometricAuth;

  /// No description provided for @biometricAuthSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use fingerprint or face recognition to unlock the app'**
  String get biometricAuthSubtitle;

  /// No description provided for @biometricNotSupported.
  ///
  /// In en, this message translates to:
  /// **'Device does not support biometric authentication'**
  String get biometricNotSupported;

  /// No description provided for @interfaceSettings.
  ///
  /// In en, this message translates to:
  /// **'Interface Settings'**
  String get interfaceSettings;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @passwordListView.
  ///
  /// In en, this message translates to:
  /// **'Password List View'**
  String get passwordListView;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// No description provided for @chinese.
  ///
  /// In en, this message translates to:
  /// **'中文'**
  String get chinese;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @listView.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get listView;

  /// No description provided for @gridView.
  ///
  /// In en, this message translates to:
  /// **'Grid'**
  String get gridView;

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettings;

  /// No description provided for @passwordExpiryReminder.
  ///
  /// In en, this message translates to:
  /// **'Password Expiry Reminder'**
  String get passwordExpiryReminder;

  /// No description provided for @passwordExpirySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Regularly remind you to update important passwords'**
  String get passwordExpirySubtitle;

  /// No description provided for @securityAlerts.
  ///
  /// In en, this message translates to:
  /// **'Security Alerts'**
  String get securityAlerts;

  /// No description provided for @securityAlertsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Receive security-related notifications and suggestions'**
  String get securityAlertsSubtitle;

  /// No description provided for @dataManagement.
  ///
  /// In en, this message translates to:
  /// **'Data Management'**
  String get dataManagement;

  /// No description provided for @dataBackup.
  ///
  /// In en, this message translates to:
  /// **'Data Backup'**
  String get dataBackup;

  /// No description provided for @dataBackupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create local backup files'**
  String get dataBackupSubtitle;

  /// No description provided for @dataRestore.
  ///
  /// In en, this message translates to:
  /// **'Data Restore'**
  String get dataRestore;

  /// No description provided for @dataRestoreSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Restore data from backup files'**
  String get dataRestoreSubtitle;

  /// No description provided for @dataExport.
  ///
  /// In en, this message translates to:
  /// **'Data Export'**
  String get dataExport;

  /// No description provided for @dataExportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Export as encrypted file'**
  String get dataExportSubtitle;

  /// No description provided for @dataImport.
  ///
  /// In en, this message translates to:
  /// **'Data Import'**
  String get dataImport;

  /// No description provided for @dataImportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Import password data from file'**
  String get dataImportSubtitle;

  /// No description provided for @backupFeatureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Backup feature will be implemented in future versions'**
  String get backupFeatureComingSoon;

  /// No description provided for @restoreFeatureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Restore feature will be implemented in future versions'**
  String get restoreFeatureComingSoon;

  /// No description provided for @exportFeatureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Export feature will be implemented in future versions'**
  String get exportFeatureComingSoon;

  /// No description provided for @importFeatureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Import feature will be implemented in future versions'**
  String get importFeatureComingSoon;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @versionInfo.
  ///
  /// In en, this message translates to:
  /// **'Version Info'**
  String get versionInfo;

  /// No description provided for @versionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'SecureVault v1.0.0'**
  String get versionSubtitle;

  /// No description provided for @aboutSecureVault.
  ///
  /// In en, this message translates to:
  /// **'About SecureVault'**
  String get aboutSecureVault;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @developer.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get developer;

  /// No description provided for @author.
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get author;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

  /// No description provided for @copyrightInfo.
  ///
  /// In en, this message translates to:
  /// **'Copyright © 2024 V8EN'**
  String get copyrightInfo;

  /// No description provided for @allRightsReserved.
  ///
  /// In en, this message translates to:
  /// **'All rights reserved'**
  String get allRightsReserved;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'🔍 Search passwords, usernames or websites...'**
  String get searchPlaceholder;

  /// No description provided for @addPassword.
  ///
  /// In en, this message translates to:
  /// **'Add Password'**
  String get addPassword;

  /// No description provided for @noPasswordSelected.
  ///
  /// In en, this message translates to:
  /// **'Please select a password entry to view details'**
  String get noPasswordSelected;

  /// No description provided for @noPasswords.
  ///
  /// In en, this message translates to:
  /// **'No password entries yet'**
  String get noPasswords;

  /// No description provided for @noPasswordsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Click the blue \"Add Password\" button above to create your first password entry'**
  String get noPasswordsSubtitle;

  /// No description provided for @noSearchResults.
  ///
  /// In en, this message translates to:
  /// **'No matching passwords found'**
  String get noSearchResults;

  /// No description provided for @noSearchResultsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try using different keywords or check if the spelling is correct'**
  String get noSearchResultsSubtitle;

  /// No description provided for @foundResults.
  ///
  /// In en, this message translates to:
  /// **'Found {count} results'**
  String foundResults(int count);

  /// No description provided for @tagItems.
  ///
  /// In en, this message translates to:
  /// **'Tag \"{tag}\": {count} items'**
  String tagItems(String tag, int count);

  /// No description provided for @categoryItems.
  ///
  /// In en, this message translates to:
  /// **'{category}: {count} items'**
  String categoryItems(String category, int count);

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @passwordGenerator.
  ///
  /// In en, this message translates to:
  /// **'Password Generator'**
  String get passwordGenerator;

  /// No description provided for @basicInfo.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInfo;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @titleRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter title'**
  String get titleRequired;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @notesPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Add additional information (such as security question answers)'**
  String get notesPlaceholder;

  /// No description provided for @addTag.
  ///
  /// In en, this message translates to:
  /// **'Add tag...'**
  String get addTag;

  /// No description provided for @addToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Add to Favorites'**
  String get addToFavorites;

  /// No description provided for @removeFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Remove from Favorites'**
  String get removeFromFavorites;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @deletePassword.
  ///
  /// In en, this message translates to:
  /// **'Delete Password'**
  String get deletePassword;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// No description provided for @deleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this password entry? This action cannot be undone.'**
  String get deleteConfirmMessage;

  /// No description provided for @passwordSaved.
  ///
  /// In en, this message translates to:
  /// **'Password saved'**
  String get passwordSaved;

  /// No description provided for @passwordDeleted.
  ///
  /// In en, this message translates to:
  /// **'Password deleted'**
  String get passwordDeleted;

  /// No description provided for @addedToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Added to favorites'**
  String get addedToFavorites;

  /// No description provided for @removedFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Removed from favorites'**
  String get removedFromFavorites;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @url.
  ///
  /// In en, this message translates to:
  /// **'URL'**
  String get url;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @cardNumber.
  ///
  /// In en, this message translates to:
  /// **'Card Number'**
  String get cardNumber;

  /// No description provided for @serverAddress.
  ///
  /// In en, this message translates to:
  /// **'Server Address'**
  String get serverAddress;

  /// No description provided for @databaseName.
  ///
  /// In en, this message translates to:
  /// **'Database Name'**
  String get databaseName;

  /// No description provided for @deviceName.
  ///
  /// In en, this message translates to:
  /// **'Device Name'**
  String get deviceName;

  /// No description provided for @ssid.
  ///
  /// In en, this message translates to:
  /// **'SSID'**
  String get ssid;

  /// No description provided for @productName.
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get productName;

  /// No description provided for @noUsername.
  ///
  /// In en, this message translates to:
  /// **'No username'**
  String get noUsername;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'{field} copied to clipboard'**
  String copied(String field);

  /// No description provided for @lock.
  ///
  /// In en, this message translates to:
  /// **'Lock'**
  String get lock;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @openSecureVault.
  ///
  /// In en, this message translates to:
  /// **'Open Secure Vault'**
  String get openSecureVault;

  /// No description provided for @aboutV8EN.
  ///
  /// In en, this message translates to:
  /// **'About V8EN'**
  String get aboutV8EN;

  /// No description provided for @completeExit.
  ///
  /// In en, this message translates to:
  /// **'Complete Exit'**
  String get completeExit;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// No description provided for @minute.
  ///
  /// In en, this message translates to:
  /// **'minute'**
  String get minute;

  /// No description provided for @minutesShort.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String minutesShort(int count);

  /// No description provided for @pleaseEnter.
  ///
  /// In en, this message translates to:
  /// **'Please enter {field}'**
  String pleaseEnter(String field);

  /// No description provided for @pleaseSelect.
  ///
  /// In en, this message translates to:
  /// **'Please select {field}'**
  String pleaseSelect(String field);

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @passwordGeneratorTitle.
  ///
  /// In en, this message translates to:
  /// **'Password Generator'**
  String get passwordGeneratorTitle;

  /// No description provided for @passwordLength.
  ///
  /// In en, this message translates to:
  /// **'Password Length'**
  String get passwordLength;

  /// No description provided for @includeUppercase.
  ///
  /// In en, this message translates to:
  /// **'Include Uppercase Letters (A-Z)'**
  String get includeUppercase;

  /// No description provided for @includeLowercase.
  ///
  /// In en, this message translates to:
  /// **'Include Lowercase Letters (a-z)'**
  String get includeLowercase;

  /// No description provided for @includeNumbers.
  ///
  /// In en, this message translates to:
  /// **'Include Numbers (0-9)'**
  String get includeNumbers;

  /// No description provided for @includeSymbols.
  ///
  /// In en, this message translates to:
  /// **'Include Special Characters (!@#\$ etc.)'**
  String get includeSymbols;

  /// No description provided for @regenerate.
  ///
  /// In en, this message translates to:
  /// **'Regenerate'**
  String get regenerate;

  /// No description provided for @usePassword.
  ///
  /// In en, this message translates to:
  /// **'Use This Password'**
  String get usePassword;

  /// No description provided for @passwordCopied.
  ///
  /// In en, this message translates to:
  /// **'Password copied to clipboard'**
  String get passwordCopied;

  /// No description provided for @addPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Add {type}'**
  String addPasswordTitle(String type);

  /// No description provided for @selectType.
  ///
  /// In en, this message translates to:
  /// **'Select Type'**
  String get selectType;

  /// No description provided for @contentCopied.
  ///
  /// In en, this message translates to:
  /// **'Content copied to clipboard'**
  String get contentCopied;

  /// No description provided for @newPasswordAdded.
  ///
  /// In en, this message translates to:
  /// **'New password added'**
  String get newPasswordAdded;

  /// No description provided for @helpTitleExample.
  ///
  /// In en, this message translates to:
  /// **'e.g.: GitHub, NetEase Email, Company Server'**
  String get helpTitleExample;

  /// No description provided for @helpEmailExample.
  ///
  /// In en, this message translates to:
  /// **'e.g.: user@example.com'**
  String get helpEmailExample;

  /// No description provided for @helpUrlExample.
  ///
  /// In en, this message translates to:
  /// **'e.g.: https://example.com'**
  String get helpUrlExample;

  /// No description provided for @helpPhoneExample.
  ///
  /// In en, this message translates to:
  /// **'e.g.: 138-0013-8000 or 13800138000'**
  String get helpPhoneExample;

  /// No description provided for @helpDateFormat.
  ///
  /// In en, this message translates to:
  /// **'Format: YYYY-MM-DD'**
  String get helpDateFormat;

  /// No description provided for @helpPasswordLength.
  ///
  /// In en, this message translates to:
  /// **'Password length at least 4 characters'**
  String get helpPasswordLength;

  /// No description provided for @helpTagInput.
  ///
  /// In en, this message translates to:
  /// **'Enter tag name'**
  String get helpTagInput;

  /// No description provided for @helpPortNumber.
  ///
  /// In en, this message translates to:
  /// **'Port: 1-65535'**
  String get helpPortNumber;

  /// No description provided for @helpSecurityCode.
  ///
  /// In en, this message translates to:
  /// **'Credit card security code: 3-4 digits'**
  String get helpSecurityCode;

  /// No description provided for @helpPinCode.
  ///
  /// In en, this message translates to:
  /// **'PIN: usually 4-8 digits'**
  String get helpPinCode;

  /// No description provided for @helpPostalCode.
  ///
  /// In en, this message translates to:
  /// **'Postal code: e.g. 100000'**
  String get helpPostalCode;

  /// No description provided for @helpExpiryMonth.
  ///
  /// In en, this message translates to:
  /// **'Expiry month: 1-12'**
  String get helpExpiryMonth;

  /// No description provided for @helpExpiryYear.
  ///
  /// In en, this message translates to:
  /// **'Expiry year: e.g. 2025'**
  String get helpExpiryYear;

  /// No description provided for @helpEnterNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a number'**
  String get helpEnterNumber;

  /// No description provided for @helpCardNumber.
  ///
  /// In en, this message translates to:
  /// **'Card number: spaces allowed'**
  String get helpCardNumber;

  /// No description provided for @helpIdNumber.
  ///
  /// In en, this message translates to:
  /// **'ID number: 15 or 18 digits'**
  String get helpIdNumber;

  /// No description provided for @helpLicenseKey.
  ///
  /// In en, this message translates to:
  /// **'License/Serial number: at least 8 characters'**
  String get helpLicenseKey;

  /// No description provided for @helpUsername.
  ///
  /// In en, this message translates to:
  /// **'Username: 2-50 characters'**
  String get helpUsername;

  /// No description provided for @helpSsid.
  ///
  /// In en, this message translates to:
  /// **'WiFi network name'**
  String get helpSsid;

  /// No description provided for @helpServerAddress.
  ///
  /// In en, this message translates to:
  /// **'Server address or IP'**
  String get helpServerAddress;

  /// No description provided for @helpDatabaseName.
  ///
  /// In en, this message translates to:
  /// **'Database name'**
  String get helpDatabaseName;

  /// No description provided for @helpDeviceName.
  ///
  /// In en, this message translates to:
  /// **'Device name or model'**
  String get helpDeviceName;

  /// No description provided for @helpProductName.
  ///
  /// In en, this message translates to:
  /// **'Software/Product name'**
  String get helpProductName;

  /// No description provided for @helpCompanyName.
  ///
  /// In en, this message translates to:
  /// **'Company or organization name'**
  String get helpCompanyName;

  /// No description provided for @helpHolderName.
  ///
  /// In en, this message translates to:
  /// **'Cardholder name'**
  String get helpHolderName;

  /// No description provided for @validationPasswordLength.
  ///
  /// In en, this message translates to:
  /// **'Password length cannot be less than 4 characters'**
  String get validationPasswordLength;

  /// No description provided for @validationEmailFormat.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get validationEmailFormat;

  /// No description provided for @validationUrlFormat.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid URL (starting with http:// or https://)'**
  String get validationUrlFormat;

  /// No description provided for @validationPhoneFormat.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number (7-15 digits)'**
  String get validationPhoneFormat;

  /// No description provided for @validationChinesePhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid Chinese mobile number'**
  String get validationChinesePhone;

  /// No description provided for @validationNumberFormat.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get validationNumberFormat;

  /// No description provided for @validationPortRange.
  ///
  /// In en, this message translates to:
  /// **'Port number must be between 1-65535'**
  String get validationPortRange;

  /// No description provided for @validationSecurityCodeLength.
  ///
  /// In en, this message translates to:
  /// **'Security code must be 3-4 digits'**
  String get validationSecurityCodeLength;

  /// No description provided for @validationPinLength.
  ///
  /// In en, this message translates to:
  /// **'PIN is usually 4-8 digits'**
  String get validationPinLength;

  /// No description provided for @validationPostalCodeLength.
  ///
  /// In en, this message translates to:
  /// **'Postal code is usually 5-10 digits'**
  String get validationPostalCodeLength;

  /// No description provided for @validationDateFormat.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid date format (YYYY-MM-DD)'**
  String get validationDateFormat;

  /// No description provided for @validationCardNumberLength.
  ///
  /// In en, this message translates to:
  /// **'Card number is usually 13-19 digits'**
  String get validationCardNumberLength;

  /// No description provided for @validationIdNumberLength.
  ///
  /// In en, this message translates to:
  /// **'ID number should be 15 or 18 digits'**
  String get validationIdNumberLength;

  /// No description provided for @validationLicenseKeyLength.
  ///
  /// In en, this message translates to:
  /// **'{field} length cannot be less than 8 characters'**
  String validationLicenseKeyLength(String field);

  /// No description provided for @validationUsernameLength.
  ///
  /// In en, this message translates to:
  /// **'Username length cannot be less than 2 characters'**
  String get validationUsernameLength;

  /// No description provided for @validationUsernameMaxLength.
  ///
  /// In en, this message translates to:
  /// **'Username length cannot exceed 50 characters'**
  String get validationUsernameMaxLength;

  /// No description provided for @validationSsidMaxLength.
  ///
  /// In en, this message translates to:
  /// **'WiFi name length cannot exceed 32 characters'**
  String get validationSsidMaxLength;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait'**
  String get pleaseWait;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// No description provided for @backupCompleted.
  ///
  /// In en, this message translates to:
  /// **'Backup completed'**
  String get backupCompleted;

  /// No description provided for @openBackupLocation.
  ///
  /// In en, this message translates to:
  /// **'Do you want to open the backup file location?'**
  String get openBackupLocation;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @restoreWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning: This operation will replace all your current password data. Please ensure you have backed up important data.'**
  String get restoreWarning;

  /// No description provided for @encryptedFile.
  ///
  /// In en, this message translates to:
  /// **'Encrypted file'**
  String get encryptedFile;
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
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
