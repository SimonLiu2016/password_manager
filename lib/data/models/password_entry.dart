/*
 * Password Manager - Password Entry Data Model
 * 
 * Copyright (c) 2024 V8EN (https://v8en.com)
 * Author: Simon <582883825@qq.com>
 * 
 * This file contains the data model for password entries supporting 9 different types.
 * Developed by V8EN organization.
 * 
 * Contact: 582883825@qq.com
 * Website: https://v8en.com
 */

class PasswordEntry {
  final String id;
  final String title;
  final PasswordEntryType type;
  final Map<String, dynamic> fields; // 通用字段存储
  final List<String> tags; // 标签
  final String? notes; // 备注
  final bool isFavorite; // 收藏状态
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PasswordEntry({
    required this.id,
    required this.title,
    required this.type,
    Map<String, dynamic>? fields,
    List<String>? tags,
    this.notes,
    this.isFavorite = false, // 默认不收藏
    this.createdAt,
    this.updatedAt,
  }) : fields = fields ?? {},
       tags = tags ?? [];

  // 便捷获取常用字段的方法
  String get username => fields['username'] ?? '';
  String get password => fields['password'] ?? '';
  String get url => fields['url'] ?? '';
  String get email => fields['email'] ?? '';

  // 信用卡特有字段
  String get cardNumber => fields['cardNumber'] ?? '';
  String get expiryDate => fields['expiryDate'] ?? '';
  String get cvv => fields['cvv'] ?? '';
  String get cardholderName => fields['cardholderName'] ?? '';

  // 服务器/数据库特有字段
  String get serverAddress => fields['serverAddress'] ?? '';
  String get port => fields['port'] ?? '';
  String get databaseName => fields['databaseName'] ?? '';
  String get connectionString => fields['connectionString'] ?? '';

  // 身份标识特有字段
  String get firstName => fields['firstName'] ?? '';
  String get lastName => fields['lastName'] ?? '';
  String get idNumber => fields['idNumber'] ?? '';
  String get phone => fields['phone'] ?? '';
  String get address => fields['address'] ?? '';

  // 设备特有字段
  String get deviceName => fields['deviceName'] ?? '';
  String get deviceType => fields['deviceType'] ?? '';
  String get serialNumber => fields['serialNumber'] ?? '';
  String get macAddress => fields['macAddress'] ?? '';

  // 复制方法（用于更新）
  PasswordEntry copyWith({
    String? id,
    String? title,
    PasswordEntryType? type,
    Map<String, dynamic>? fields,
    List<String>? tags,
    String? notes,
    bool? isFavorite,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PasswordEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      fields: fields ?? Map<String, dynamic>.from(this.fields),
      tags: tags ?? List<String>.from(this.tags),
      notes: notes ?? this.notes,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // 更新特定字段的方法
  PasswordEntry updateField(String key, dynamic value) {
    final newFields = Map<String, dynamic>.from(fields);
    if (value != null && value.toString().isNotEmpty) {
      newFields[key] = value;
    } else {
      newFields.remove(key);
    }
    return copyWith(fields: newFields);
  }

  // 转换为Map（用于存储）
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'type': type.toString(),
      'fields': fields,
      'tags': tags,
      'notes': notes,
      'isFavorite': isFavorite,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // 从Map解析
  static PasswordEntry fromMap(Map<String, dynamic> map) {
    return PasswordEntry(
      id: map['id'],
      title: map['title'],
      type: PasswordEntryType.values.firstWhere(
        (e) => e.toString() == map['type'],
        orElse: () => PasswordEntryType.login,
      ),
      fields: Map<String, dynamic>.from(map['fields'] ?? {}),
      tags: List<String>.from(map['tags'] ?? []),
      notes: map['notes'],
      isFavorite: map['isFavorite'] ?? false, // 向后兼容
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : null,
    );
  }

  @override
  String toString() {
    return 'PasswordEntry(id: $id, title: $title, type: $type, fields: $fields, tags: $tags, notes: $notes, isFavorite: $isFavorite, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PasswordEntry &&
        other.id == id &&
        other.title == title &&
        other.type == type &&
        other.fields.toString() == fields.toString() &&
        other.tags.toString() == tags.toString() &&
        other.notes == notes &&
        other.isFavorite == isFavorite &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        type.hashCode ^
        fields.hashCode ^
        tags.hashCode ^
        notes.hashCode ^
        isFavorite.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}

// 密码条目类型枚举
enum PasswordEntryType {
  login, // 登录信息
  creditCard, // 信用卡
  identity, // 身份标识
  secureNote, // 安全笔记
  server, // 服务器
  database, // 数据库
  device, // 安全设备
  wifi, // WiFi密码
  license, // 软件许可证
}

// 密码条目类型配置
class PasswordEntryTypeConfig {
  static const Map<PasswordEntryType, Map<String, dynamic>> configs = {
    PasswordEntryType.login: {
      'name': '登录信息',
      'icon': 'account_circle',
      'color': 0xFF2196F3,
      'fields': [
        {'key': 'username', 'label': '用户名', 'type': 'text', 'required': true},
        {
          'key': 'password',
          'label': '密码',
          'type': 'password',
          'required': true,
        },
        {'key': 'email', 'label': '邮箱', 'type': 'email', 'required': false},
        {'key': 'url', 'label': '网址', 'type': 'url', 'required': false},
      ],
    },
    PasswordEntryType.creditCard: {
      'name': '信用卡',
      'icon': 'credit_card',
      'color': 0xFF4CAF50,
      'fields': [
        {'key': 'cardNumber', 'label': '卡号', 'type': 'text', 'required': true},
        {
          'key': 'cardholderName',
          'label': '持卡人姓名',
          'type': 'text',
          'required': true,
        },
        {'key': 'expiryDate', 'label': '有效期', 'type': 'text', 'required': true},
        {'key': 'cvv', 'label': 'CVV', 'type': 'password', 'required': true},
        {'key': 'pin', 'label': 'PIN码', 'type': 'password', 'required': false},
      ],
    },
    PasswordEntryType.identity: {
      'name': '身份标识',
      'icon': 'person',
      'color': 0xFF9C27B0,
      'fields': [
        {'key': 'firstName', 'label': '名字', 'type': 'text', 'required': true},
        {'key': 'lastName', 'label': '姓氏', 'type': 'text', 'required': true},
        {'key': 'idNumber', 'label': '身份证号', 'type': 'text', 'required': false},
        {'key': 'phone', 'label': '电话', 'type': 'phone', 'required': false},
        {'key': 'email', 'label': '邮箱', 'type': 'email', 'required': false},
        {
          'key': 'address',
          'label': '地址',
          'type': 'textarea',
          'required': false,
        },
      ],
    },
    PasswordEntryType.server: {
      'name': '服务器',
      'icon': 'dns',
      'color': 0xFFFF9800,
      'fields': [
        {
          'key': 'serverAddress',
          'label': '服务器地址',
          'type': 'text',
          'required': true,
        },
        {'key': 'port', 'label': '端口', 'type': 'number', 'required': false},
        {'key': 'username', 'label': '用户名', 'type': 'text', 'required': true},
        {
          'key': 'password',
          'label': '密码',
          'type': 'password',
          'required': true,
        },
        {'key': 'protocol', 'label': '协议', 'type': 'text', 'required': false},
      ],
    },
    PasswordEntryType.database: {
      'name': '数据库',
      'icon': 'storage',
      'color': 0xFFF44336,
      'fields': [
        {
          'key': 'serverAddress',
          'label': '服务器地址',
          'type': 'text',
          'required': true,
        },
        {'key': 'port', 'label': '端口', 'type': 'number', 'required': false},
        {
          'key': 'databaseName',
          'label': '数据库名',
          'type': 'text',
          'required': true,
        },
        {'key': 'username', 'label': '用户名', 'type': 'text', 'required': true},
        {
          'key': 'password',
          'label': '密码',
          'type': 'password',
          'required': true,
        },
        {
          'key': 'connectionString',
          'label': '连接字符串',
          'type': 'textarea',
          'required': false,
        },
      ],
    },
    PasswordEntryType.device: {
      'name': '安全设备',
      'icon': 'security',
      'color': 0xFF00BCD4,
      'fields': [
        {
          'key': 'deviceName',
          'label': '设备名称',
          'type': 'text',
          'required': true,
        },
        {
          'key': 'deviceType',
          'label': '设备类型',
          'type': 'text',
          'required': false,
        },
        {'key': 'username', 'label': '用户名', 'type': 'text', 'required': false},
        {
          'key': 'password',
          'label': '密码',
          'type': 'password',
          'required': false,
        },
        {
          'key': 'serialNumber',
          'label': '序列号',
          'type': 'text',
          'required': false,
        },
        {
          'key': 'macAddress',
          'label': 'MAC地址',
          'type': 'text',
          'required': false,
        },
      ],
    },
    PasswordEntryType.wifi: {
      'name': 'WiFi密码',
      'icon': 'wifi',
      'color': 0xFF795548,
      'fields': [
        {
          'key': 'ssid',
          'label': 'WiFi名称(SSID)',
          'type': 'text',
          'required': true,
        },
        {
          'key': 'password',
          'label': 'WiFi密码',
          'type': 'password',
          'required': true,
        },
        {'key': 'security', 'label': '加密方式', 'type': 'text', 'required': false},
        {'key': 'frequency', 'label': '频段', 'type': 'text', 'required': false},
      ],
    },
    PasswordEntryType.secureNote: {
      'name': '安全笔记',
      'icon': 'note',
      'color': 0xFF607D8B,
      'fields': [
        {'key': 'content', 'label': '内容', 'type': 'textarea', 'required': true},
      ],
    },
    PasswordEntryType.license: {
      'name': '软件许可证',
      'icon': 'key',
      'color': 0xFF3F51B5,
      'fields': [
        {
          'key': 'productName',
          'label': '产品名称',
          'type': 'text',
          'required': true,
        },
        {
          'key': 'licenseKey',
          'label': '许可证密钥',
          'type': 'password',
          'required': true,
        },
        {'key': 'version', 'label': '版本', 'type': 'text', 'required': false},
        {'key': 'email', 'label': '注册邮箱', 'type': 'email', 'required': false},
        {
          'key': 'purchaseDate',
          'label': '购买日期',
          'type': 'date',
          'required': false,
        },
        {
          'key': 'expiryDate',
          'label': '到期日期',
          'type': 'date',
          'required': false,
        },
      ],
    },
  };

  static Map<String, dynamic> getConfig(PasswordEntryType type) {
    return configs[type] ?? configs[PasswordEntryType.login]!;
  }

  static String getName(PasswordEntryType type) {
    return getConfig(type)['name'];
  }

  static String getIcon(PasswordEntryType type) {
    return getConfig(type)['icon'];
  }

  static int getColor(PasswordEntryType type) {
    return getConfig(type)['color'];
  }

  static List<Map<String, dynamic>> getFields(PasswordEntryType type) {
    return List<Map<String, dynamic>>.from(getConfig(type)['fields']);
  }
}
