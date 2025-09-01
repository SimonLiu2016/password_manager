// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'SecureVault';

  @override
  String get appSubtitle => 'Password Manager';

  @override
  String get settings => 'Settings';

  @override
  String get myAccount => 'My Account';

  @override
  String get mainCategory => 'Main';

  @override
  String get tags => 'Tags';

  @override
  String get collapse => 'Collapse';

  @override
  String get expand => 'Expand';

  @override
  String get allItems => 'All Items';

  @override
  String get favorites => 'Favorites';

  @override
  String get loginInfo => 'Login Info';

  @override
  String get creditCard => 'Credit Card';

  @override
  String get identity => 'Identity';

  @override
  String get server => 'Server';

  @override
  String get database => 'Database';

  @override
  String get secureDevice => 'Secure Device';

  @override
  String get wifiPassword => 'WiFi Password';

  @override
  String get secureNote => 'Secure Note';

  @override
  String get softwareLicense => 'Software License';

  @override
  String get securitySettings => 'Security Settings';

  @override
  String get autoLockTime => 'Auto Lock Time';

  @override
  String autoLockSubtitle(int minutes) {
    return 'Lock automatically after $minutes minutes of inactivity';
  }

  @override
  String get biometricAuth => 'Biometric Authentication';

  @override
  String get biometricAuthSubtitle =>
      'Use fingerprint or face recognition to unlock the app';

  @override
  String get biometricNotSupported =>
      'Device does not support biometric authentication';

  @override
  String get interfaceSettings => 'Interface Settings';

  @override
  String get theme => 'Theme';

  @override
  String get language => 'Language';

  @override
  String get passwordListView => 'Password List View';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get chinese => '中文';

  @override
  String get english => 'English';

  @override
  String get listView => 'List';

  @override
  String get gridView => 'Grid';

  @override
  String get notificationSettings => 'Notification Settings';

  @override
  String get passwordExpiryReminder => 'Password Expiry Reminder';

  @override
  String get passwordExpirySubtitle =>
      'Regularly remind you to update important passwords';

  @override
  String get securityAlerts => 'Security Alerts';

  @override
  String get securityAlertsSubtitle =>
      'Receive security-related notifications and suggestions';

  @override
  String get dataManagement => 'Data Management';

  @override
  String get dataBackup => 'Data Backup';

  @override
  String get dataBackupSubtitle => 'Create local backup files';

  @override
  String get dataRestore => 'Data Restore';

  @override
  String get dataRestoreSubtitle => 'Restore data from backup files';

  @override
  String get dataExport => 'Data Export';

  @override
  String get dataExportSubtitle => 'Export as encrypted file';

  @override
  String get dataImport => 'Data Import';

  @override
  String get dataImportSubtitle => 'Import password data from file';

  @override
  String get backupFeatureComingSoon =>
      'Backup feature will be implemented in future versions';

  @override
  String get restoreFeatureComingSoon =>
      'Restore feature will be implemented in future versions';

  @override
  String get exportFeatureComingSoon =>
      'Export feature will be implemented in future versions';

  @override
  String get importFeatureComingSoon =>
      'Import feature will be implemented in future versions';

  @override
  String get about => 'About';

  @override
  String get versionInfo => 'Version Info';

  @override
  String get versionSubtitle => 'SecureVault v1.0.0';

  @override
  String get aboutSecureVault => 'About SecureVault';

  @override
  String get version => 'Version';

  @override
  String get developer => 'Developer';

  @override
  String get author => 'Author';

  @override
  String get contact => 'Contact';

  @override
  String get website => 'Website';

  @override
  String get copyrightInfo => 'Copyright © 2024 V8EN';

  @override
  String get allRightsReserved => 'All rights reserved';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get save => 'Save';

  @override
  String get confirm => 'Confirm';

  @override
  String get searchPlaceholder =>
      '🔍 Search passwords, usernames or websites...';

  @override
  String get addPassword => 'Add Password';

  @override
  String get noPasswordSelected =>
      'Please select a password entry to view details';

  @override
  String get noPasswords => 'No password entries yet';

  @override
  String get noPasswordsSubtitle =>
      'Click the blue \"Add Password\" button above to create your first password entry';

  @override
  String get noSearchResults => 'No matching passwords found';

  @override
  String get noSearchResultsSubtitle =>
      'Try using different keywords or check if the spelling is correct';

  @override
  String foundResults(int count) {
    return 'Found $count results';
  }

  @override
  String tagItems(String tag, int count) {
    return 'Tag \"$tag\": $count items';
  }

  @override
  String categoryItems(String category, int count) {
    return '$category: $count items';
  }

  @override
  String get details => 'Details';

  @override
  String get passwordGenerator => 'Password Generator';

  @override
  String get basicInfo => 'Basic Information';

  @override
  String get title => 'Title';

  @override
  String get titleRequired => 'Please enter title';

  @override
  String get notes => 'Notes';

  @override
  String get notesPlaceholder =>
      'Add additional information (such as security question answers)';

  @override
  String get addTag => 'Add tag...';

  @override
  String get addToFavorites => 'Add to Favorites';

  @override
  String get removeFromFavorites => 'Remove from Favorites';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get deletePassword => 'Delete Password';

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String get deleteConfirmMessage =>
      'Are you sure you want to delete this password entry? This action cannot be undone.';

  @override
  String get passwordSaved => 'Password saved';

  @override
  String get passwordDeleted => 'Password deleted';

  @override
  String get addedToFavorites => 'Added to favorites';

  @override
  String get removedFromFavorites => 'Removed from favorites';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get email => 'Email';

  @override
  String get url => 'URL';

  @override
  String get phone => 'Phone';

  @override
  String get cardNumber => 'Card Number';

  @override
  String get serverAddress => 'Server Address';

  @override
  String get databaseName => 'Database Name';

  @override
  String get deviceName => 'Device Name';

  @override
  String get ssid => 'SSID';

  @override
  String get productName => 'Product Name';

  @override
  String get noUsername => 'No username';

  @override
  String copied(String field) {
    return '$field copied to clipboard';
  }

  @override
  String get lock => 'Lock';

  @override
  String get preferences => 'Preferences';

  @override
  String get openSecureVault => 'Open Secure Vault';

  @override
  String get aboutV8EN => 'About V8EN';

  @override
  String get completeExit => 'Complete Exit';

  @override
  String get minutes => 'minutes';

  @override
  String get minute => 'minute';

  @override
  String minutesShort(int count) {
    return '$count min';
  }

  @override
  String pleaseEnter(String field) {
    return 'Please enter $field';
  }

  @override
  String pleaseSelect(String field) {
    return 'Please select $field';
  }

  @override
  String get categories => 'Categories';

  @override
  String get passwordGeneratorTitle => 'Password Generator';

  @override
  String get passwordLength => 'Password Length';

  @override
  String get includeUppercase => 'Include Uppercase Letters (A-Z)';

  @override
  String get includeLowercase => 'Include Lowercase Letters (a-z)';

  @override
  String get includeNumbers => 'Include Numbers (0-9)';

  @override
  String get includeSymbols => 'Include Special Characters (!@#\$ etc.)';

  @override
  String get regenerate => 'Regenerate';

  @override
  String get usePassword => 'Use This Password';

  @override
  String get passwordCopied => 'Password copied to clipboard';

  @override
  String addPasswordTitle(String type) {
    return 'Add $type';
  }

  @override
  String get selectType => 'Select Type';

  @override
  String get contentCopied => 'Content copied to clipboard';

  @override
  String get newPasswordAdded => 'New password added';

  @override
  String get helpTitleExample => 'e.g.: GitHub, NetEase Email, Company Server';

  @override
  String get helpEmailExample => 'e.g.: user@example.com';

  @override
  String get helpUrlExample => 'e.g.: https://example.com';

  @override
  String get helpPhoneExample => 'e.g.: 138-0013-8000 or 13800138000';

  @override
  String get helpDateFormat => 'Format: YYYY-MM-DD';

  @override
  String get helpPasswordLength => 'Password length at least 4 characters';

  @override
  String get helpTagInput => 'Enter tag name';

  @override
  String get helpPortNumber => 'Port: 1-65535';

  @override
  String get helpSecurityCode => 'Credit card security code: 3-4 digits';

  @override
  String get helpPinCode => 'PIN: usually 4-8 digits';

  @override
  String get helpPostalCode => 'Postal code: e.g. 100000';

  @override
  String get helpExpiryMonth => 'Expiry month: 1-12';

  @override
  String get helpExpiryYear => 'Expiry year: e.g. 2025';

  @override
  String get helpEnterNumber => 'Please enter a number';

  @override
  String get helpCardNumber => 'Card number: spaces allowed';

  @override
  String get helpIdNumber => 'ID number: 15 or 18 digits';

  @override
  String get helpLicenseKey => 'License/Serial number: at least 8 characters';

  @override
  String get helpUsername => 'Username: 2-50 characters';

  @override
  String get helpSsid => 'WiFi network name';

  @override
  String get helpServerAddress => 'Server address or IP';

  @override
  String get helpDatabaseName => 'Database name';

  @override
  String get helpDeviceName => 'Device name or model';

  @override
  String get helpProductName => 'Software/Product name';

  @override
  String get helpCompanyName => 'Company or organization name';

  @override
  String get helpHolderName => 'Cardholder name';

  @override
  String get validationPasswordLength =>
      'Password length cannot be less than 4 characters';

  @override
  String get validationEmailFormat => 'Please enter a valid email address';

  @override
  String get validationUrlFormat =>
      'Please enter a valid URL (starting with http:// or https://)';

  @override
  String get validationPhoneFormat =>
      'Please enter a valid phone number (7-15 digits)';

  @override
  String get validationChinesePhone =>
      'Please enter a valid Chinese mobile number';

  @override
  String get validationNumberFormat => 'Please enter a valid number';

  @override
  String get validationPortRange => 'Port number must be between 1-65535';

  @override
  String get validationSecurityCodeLength => 'Security code must be 3-4 digits';

  @override
  String get validationPinLength => 'PIN is usually 4-8 digits';

  @override
  String get validationPostalCodeLength => 'Postal code is usually 5-10 digits';

  @override
  String get validationDateFormat =>
      'Please enter a valid date format (YYYY-MM-DD)';

  @override
  String get validationCardNumberLength =>
      'Card number is usually 13-19 digits';

  @override
  String get validationIdNumberLength => 'ID number should be 15 or 18 digits';

  @override
  String validationLicenseKeyLength(String field) {
    return '$field length cannot be less than 8 characters';
  }

  @override
  String get validationUsernameLength =>
      'Username length cannot be less than 2 characters';

  @override
  String get validationUsernameMaxLength =>
      'Username length cannot exceed 50 characters';

  @override
  String get validationSsidMaxLength =>
      'WiFi name length cannot exceed 32 characters';

  @override
  String get pleaseWait => 'Please wait';

  @override
  String get failed => 'Failed';

  @override
  String get backupCompleted => 'Backup completed';

  @override
  String get openBackupLocation =>
      'Do you want to open the backup file location?';

  @override
  String get open => 'Open';

  @override
  String get restoreWarning =>
      'Warning: This operation will replace all your current password data. Please ensure you have backed up important data.';

  @override
  String get encryptedFile => 'Encrypted file';
}
