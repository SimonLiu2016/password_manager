/*
 * Password Manager - App Theme Configuration
 * 
 * Copyright (c) 2024 V8EN (https://v8en.com)
 * Author: Simon <582883825@qq.com>
 * 
 * This file contains the theme configuration for the Password Manager application.
 * Developed by V8EN organization.
 * 
 * Contact: 582883825@qq.com
 * Website: https://v8en.com
 */
import 'package:flutter/material.dart';
import 'package:password_manager/data/models/password_entry.dart';
import 'package:password_manager/presentation/providers/password_provider.dart';
import 'package:provider/provider.dart';
import 'package:password_manager/l10n/app_localizations.dart';

// 为了实现国际化，我们需要直接访问既有的本地化类

// 将本地化的分类名称映射回密码类型
PasswordEntryType? _getPasswordTypeFromLocalizedName(
  String localizedName,
  AppLocalizations l10n,
) {
  if (localizedName == l10n.loginInfo) {
    return PasswordEntryType.login;
  } else if (localizedName == l10n.creditCard) {
    return PasswordEntryType.creditCard;
  } else if (localizedName == l10n.identity) {
    return PasswordEntryType.identity;
  } else if (localizedName == l10n.server) {
    return PasswordEntryType.server;
  } else if (localizedName == l10n.database) {
    return PasswordEntryType.database;
  } else if (localizedName == l10n.secureDevice) {
    return PasswordEntryType.device;
  } else if (localizedName == l10n.wifiPassword) {
    return PasswordEntryType.wifi;
  } else if (localizedName == l10n.secureNote) {
    return PasswordEntryType.secureNote;
  } else if (localizedName == l10n.softwareLicense) {
    return PasswordEntryType.license;
  }
  return null;
}

// 定义颜色数组 - 更现代化的色彩搭配
const List<Color> titleBoxColors = [
  Color(0xFF2196F3), // 蓝色
  Color(0xFF4CAF50), // 绿色
  Color(0xFFFF9800), // 橙色
  Color(0xFF9C27B0), // 紫色
  Color(0xFFF44336), // 红色
  Color(0xFF00BCD4), // 青色
  Color(0xFF795548), // 棕色
  Color(0xFF607D8B), // 蓝灰色
];

class VaultList extends StatefulWidget {
  final Function(PasswordEntry) onPasswordSelected; // 选中回调
  final String searchQuery;
  final String selectedCategory; // 添加分类筛选参数
  final String? selectedTag; // 添加标签筛选参数

  const VaultList({
    super.key,
    required this.onPasswordSelected,
    required this.searchQuery,
    required this.selectedCategory, // 添加必需参数
    this.selectedTag, // 添加可选参数
  });

  @override
  State<VaultList> createState() => _VaultListState();
}

class _VaultListState extends State<VaultList> {
  // 选中的索引
  List<PasswordEntry> _passwords = [];

  @override
  void initState() {
    super.initState();
    _loadPasswords();
  }

  // 加载密码数据
  void _loadPasswords() {
    final provider = Provider.of<PasswordProvider>(context, listen: false);
    provider.getAllDecryptedPasswords().then((passwords) {
      setState(() {
        _passwords = passwords;
      });

      // 延迟设置选中状态，确保在构建完成后执行
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_passwords.isNotEmpty && mounted) {
          // 设置第一个密码为选中状态
          provider.selectedPasswordId = _passwords[0].id;
          widget.onPasswordSelected(_passwords[0]);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final passwordProvider = Provider.of<PasswordProvider>(context);
    final passwords = passwordProvider.passwords;

    // 应用搜索和分类过滤
    List<PasswordEntry> filteredPasswords = passwords;

    // 按标签筛选（优先级最高）
    if (widget.selectedTag != null && widget.selectedTag!.isNotEmpty) {
      filteredPasswords = passwordProvider.getPasswordsByTag(
        widget.selectedTag ?? "",
      );
    }
    // 按分类筛选
    else if (widget.selectedCategory ==
        AppLocalizations.of(context)!.favorites) {
      // 收藏分类筛选
      filteredPasswords = passwords
          .where((password) => password.isFavorite)
          .toList();
    } else if (widget.selectedCategory !=
        AppLocalizations.of(context)!.allItems) {
      // 其他分类筛选 - 使用类型匹配而不是名称匹配
      final targetType = _getPasswordTypeFromLocalizedName(
        widget.selectedCategory,
        AppLocalizations.of(context)!,
      );
      if (targetType != null) {
        filteredPasswords = passwords
            .where((password) => password.type == targetType)
            .toList();
      } else {
        // 如果找不到对应的类型，返回空列表
        filteredPasswords = [];
      }
    }

    // 再按搜索关键词筛选
    if (widget.searchQuery.isNotEmpty) {
      filteredPasswords = filteredPasswords
          .where(
            (password) =>
                password.title.toLowerCase().contains(
                  widget.searchQuery.toLowerCase(),
                ) ||
                password.username.toLowerCase().contains(
                  widget.searchQuery.toLowerCase(),
                ),
          )
          .toList();
    }

    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // 搜索结果统计
          if (widget.searchQuery.isNotEmpty ||
              widget.selectedCategory !=
                  AppLocalizations.of(context)!.allItems ||
              (widget.selectedTag != null && widget.selectedTag!.isNotEmpty))
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  Icon(
                    widget.searchQuery.isNotEmpty
                        ? Icons.search_rounded
                        : (widget.selectedTag != null &&
                                  widget.selectedTag!.isNotEmpty
                              ? Icons.label_rounded
                              : Icons.filter_list_rounded),
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 16,
                  ),
                  SizedBox(width: 8),
                  Text(
                    widget.searchQuery.isNotEmpty
                        ? AppLocalizations.of(
                            context,
                          )!.foundResults(filteredPasswords.length)
                        : (widget.selectedTag != null &&
                                  widget.selectedTag!.isNotEmpty
                              ? AppLocalizations.of(context)!.tagItems(
                                  widget.selectedTag ?? "",
                                  filteredPasswords.length,
                                )
                              : AppLocalizations.of(context)!.categoryItems(
                                  widget.selectedCategory,
                                  filteredPasswords.length,
                                )),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

          // 密码列表
          Expanded(
            child: filteredPasswords.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    itemCount: filteredPasswords.length,
                    itemBuilder: (context, index) {
                      final password = filteredPasswords[index];
                      final isSelected =
                          password.id ==
                          context.watch<PasswordProvider>().selectedPasswordId;

                      return _buildPasswordCard(
                        password: password,
                        isSelected: isSelected,
                        onTap: () {
                          widget.onPasswordSelected(password);
                          context.read<PasswordProvider>().selectedPasswordId =
                              password.id;
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordCard({
    required PasswordEntry password,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    // 根据标题的hashCode获取颜色索引
    int colorIndex = password.title.hashCode % titleBoxColors.length;
    Color boxColor = titleBoxColors[colorIndex];

    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.08)
                  : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.3)
                    : Colors.transparent,
                width: 2,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.15),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: Offset(0, 1),
                      ),
                    ],
            ),
            child: Row(
              children: [
                // 图标
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? boxColor
                        : boxColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      password.title.isNotEmpty
                          ? password.title[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        color: isSelected ? Colors.white : boxColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 16),

                // 信息
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        password.title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        password.username.isNotEmpty
                            ? password.username
                            : AppLocalizations.of(context)!.noUsername,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (password.url.isNotEmpty) ...[
                        SizedBox(height: 2),
                        Text(
                          password.url,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant
                                    .withValues(alpha: 0.7),
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),

                // 箭头指示器
                AnimatedRotation(
                  turns: isSelected ? 0.5 : 0,
                  duration: Duration(milliseconds: 200),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(
                    context,
                  ).colorScheme.onSurfaceVariant.withValues(alpha: 0.1),
                  Theme.of(
                    context,
                  ).colorScheme.onSurfaceVariant.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(60),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 背景光效
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurfaceVariant.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                // 主图标
                Icon(
                  Icons.security_rounded,
                  size: 48,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                ),
                // 装饰性加号
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.3),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32),
          Text(
            widget.searchQuery.isNotEmpty
                ? AppLocalizations.of(context)!.noSearchResults
                : AppLocalizations.of(context)!.noPasswords,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12),
          Container(
            constraints: BoxConstraints(maxWidth: 280),
            child: Text(
              widget.searchQuery.isNotEmpty
                  ? AppLocalizations.of(context)!.noSearchResultsSubtitle
                  : AppLocalizations.of(context)!.noPasswordsSubtitle,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
