// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'SecureVault';

  @override
  String get appSubtitle => '密码管理器';

  @override
  String get settings => '设置';

  @override
  String get myAccount => '我的账户';

  @override
  String get mainCategory => '主要';

  @override
  String get tags => '标签';

  @override
  String get collapse => '收起';

  @override
  String get expand => '展开';

  @override
  String get allItems => '所有项目';

  @override
  String get favorites => '收藏';

  @override
  String get loginInfo => '登录信息';

  @override
  String get creditCard => '信用卡';

  @override
  String get identity => '身份标识';

  @override
  String get server => '服务器';

  @override
  String get database => '数据库';

  @override
  String get secureDevice => '安全设备';

  @override
  String get wifiPassword => 'WiFi密码';

  @override
  String get secureNote => '安全笔记';

  @override
  String get softwareLicense => '软件许可证';

  @override
  String get securitySettings => '安全设置';

  @override
  String get autoLockTime => '自动锁定时间';

  @override
  String autoLockSubtitle(int minutes) {
    return '$minutes 分钟无操作后自动锁定';
  }

  @override
  String get biometricAuth => '生物识别认证';

  @override
  String get biometricAuthSubtitle => '使用指纹或面部识别解锁应用';

  @override
  String get biometricNotSupported => '设备不支持生物识别认证';

  @override
  String get interfaceSettings => '界面设置';

  @override
  String get theme => '主题';

  @override
  String get language => '语言';

  @override
  String get passwordListView => '密码列表视图';

  @override
  String get lightTheme => '浅色';

  @override
  String get darkTheme => '深色';

  @override
  String get chinese => '中文';

  @override
  String get english => 'English';

  @override
  String get listView => '列表';

  @override
  String get gridView => '网格';

  @override
  String get notificationSettings => '通知设置';

  @override
  String get passwordExpiryReminder => '密码到期提醒';

  @override
  String get passwordExpirySubtitle => '定期提醒您更新重要密码';

  @override
  String get securityAlerts => '安全提醒';

  @override
  String get securityAlertsSubtitle => '接收安全相关的通知和建议';

  @override
  String get dataManagement => '数据管理';

  @override
  String get dataBackup => '数据备份';

  @override
  String get dataBackupSubtitle => '创建本地备份文件';

  @override
  String get dataRestore => '数据恢复';

  @override
  String get dataRestoreSubtitle => '从备份文件恢复数据';

  @override
  String get dataExport => '导出数据';

  @override
  String get dataExportSubtitle => '导出为加密文件';

  @override
  String get dataImport => '导入数据';

  @override
  String get dataImportSubtitle => '从文件导入密码数据';

  @override
  String get backupFeatureComingSoon => '备份功能将在后续版本中实现';

  @override
  String get restoreFeatureComingSoon => '恢复功能将在后续版本中实现';

  @override
  String get exportFeatureComingSoon => '导出功能将在后续版本中实现';

  @override
  String get importFeatureComingSoon => '导入功能将在后续版本中实现';

  @override
  String get about => '关于';

  @override
  String get versionInfo => '版本信息';

  @override
  String get versionSubtitle => 'SecureVault v1.0.0';

  @override
  String get aboutSecureVault => '关于 SecureVault';

  @override
  String get version => '版本';

  @override
  String get developer => '开发者';

  @override
  String get author => '作者';

  @override
  String get contact => '联系方式';

  @override
  String get website => '官方网站';

  @override
  String get copyrightInfo => 'Copyright © 2024 V8EN';

  @override
  String get allRightsReserved => '保留所有权利';

  @override
  String get ok => '确定';

  @override
  String get cancel => '取消';

  @override
  String get delete => '删除';

  @override
  String get save => '保存';

  @override
  String get confirm => '确认';

  @override
  String get searchPlaceholder => '🔍 搜索密码、用户名或网站...';

  @override
  String get addPassword => '添加密码';

  @override
  String get noPasswordSelected => '请选择一个密码条目查看详情';

  @override
  String get noPasswords => '还没有密码条目';

  @override
  String get noPasswordsSubtitle => '点击上方的蓝色\"添加密码\"按钮来创建你的第一个密码条目';

  @override
  String get noSearchResults => '未找到匹配的密码';

  @override
  String get noSearchResultsSubtitle => '试试使用不同的关键词搜索，或检查拼写是否正确';

  @override
  String foundResults(int count) {
    return '找到 $count 个结果';
  }

  @override
  String tagItems(String tag, int count) {
    return '标签 \"$tag\": $count 个项目';
  }

  @override
  String categoryItems(String category, int count) {
    return '$category: $count 个项目';
  }

  @override
  String get details => '详情';

  @override
  String get passwordGenerator => '密码生成器';

  @override
  String get basicInfo => '基本信息';

  @override
  String get title => '标题';

  @override
  String get titleRequired => '请输入标题';

  @override
  String get notes => '备注';

  @override
  String get notesPlaceholder => '添加额外信息（如安全问题答案）';

  @override
  String get addTag => '添加标签...';

  @override
  String get addToFavorites => '添加到收藏';

  @override
  String get removeFromFavorites => '取消收藏';

  @override
  String get saveChanges => '保存更改';

  @override
  String get deletePassword => '删除密码';

  @override
  String get confirmDelete => '确认删除';

  @override
  String get deleteConfirmMessage => '您确定要删除这个密码条目吗？此操作不可撤销。';

  @override
  String get passwordSaved => '密码已保存';

  @override
  String get passwordDeleted => '密码已删除';

  @override
  String get addedToFavorites => '已添加到收藏';

  @override
  String get removedFromFavorites => '已取消收藏';

  @override
  String get username => '用户名';

  @override
  String get password => '密码';

  @override
  String get email => '邮箱';

  @override
  String get url => '网址';

  @override
  String get phone => '电话';

  @override
  String get cardNumber => '卡号';

  @override
  String get serverAddress => '服务器地址';

  @override
  String get databaseName => '数据库名';

  @override
  String get deviceName => '设备名';

  @override
  String get ssid => '网络名称';

  @override
  String get productName => '产品名称';

  @override
  String get noUsername => '无用户名';

  @override
  String copied(String field) {
    return '$field 已复制到剪贴板';
  }

  @override
  String get lock => '锁定';

  @override
  String get preferences => '偏好设置';

  @override
  String get openSecureVault => '打开 Secure Vault';

  @override
  String get aboutV8EN => '关于 V8EN';

  @override
  String get completeExit => '完全退出';

  @override
  String get minutes => '分钟';

  @override
  String get minute => '分钟';

  @override
  String minutesShort(int count) {
    return '$count 分钟';
  }

  @override
  String pleaseEnter(String field) {
    return '请输入$field';
  }

  @override
  String pleaseSelect(String field) {
    return '请选择$field';
  }

  @override
  String get categories => '分类';

  @override
  String get passwordGeneratorTitle => '密码生成器';

  @override
  String get passwordLength => '密码长度';

  @override
  String get includeUppercase => '包含大写字母 (A-Z)';

  @override
  String get includeLowercase => '包含小写字母 (a-z)';

  @override
  String get includeNumbers => '包含数字 (0-9)';

  @override
  String get includeSymbols => '包含特殊字符 (!@#\$等)';

  @override
  String get regenerate => '重新生成';

  @override
  String get usePassword => '使用此密码';

  @override
  String get passwordCopied => '密码已复制到剪贴板';

  @override
  String addPasswordTitle(String type) {
    return '添加$type';
  }

  @override
  String get selectType => '选择类型';

  @override
  String get contentCopied => '内容已复制到剪贴板';

  @override
  String get newPasswordAdded => '新密码已添加';

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
}
