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
import 'package:password_manager/app/app_theme.dart';
import 'package:password_manager/data/models/password_entry.dart';
import 'package:password_manager/presentation/providers/password_provider.dart';
import 'package:password_manager/presentation/screens/settings_screen.dart';
import 'package:password_manager/presentation/screens/account_screen.dart';
import 'package:password_manager/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class Sidebar extends StatefulWidget {
  final Function(String)? onCategoryChanged; // 添加分类变更回调
  final Function(String)? onTagSelected; // 添加标签选择回调

  const Sidebar({super.key, this.onCategoryChanged, this.onTagSelected});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  String selectedCategory = '所有项目'; // 这里暂时保持中文，后面会动态设置
  String? selectedTag; // 当前选中的标签
  bool _isCategoryExpanded = true; // 分类菜单展开状态
  bool _isTagExpanded = false; // 标签菜单展开状态（默认收起）

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 在这里设置默认值，确保本地化已加载
    final l10n = AppLocalizations.of(context);
    if (l10n != null && selectedCategory == '所有项目') {
      selectedCategory = l10n.allItems;
    }
  }

  // 计算各分类的密码数量
  Map<String, int> _calculateCounts(
    List<PasswordEntry> passwords,
    AppLocalizations l10n,
  ) {
    final counts = <String, int>{
      l10n.allItems: passwords.length,
      l10n.favorites: passwords.where((p) => p.isFavorite).length, // 实现收藏数量统计
      l10n.loginInfo: 0,
      l10n.creditCard: 0,
      l10n.identity: 0,
      l10n.server: 0,
      l10n.database: 0,
      l10n.secureDevice: 0, // 修正为正确的类型名称
      l10n.wifiPassword: 0, // 修正为正确的类型名称
      l10n.secureNote: 0,
      l10n.softwareLicense: 0,
    };

    for (final password in passwords) {
      final typeName = PasswordEntryTypeConfig.getName(password.type);
      // 根据类型名称映射到本地化的分类名称
      final localizedTypeName = _getLocalizedTypeName(typeName, l10n);
      counts[localizedTypeName] = (counts[localizedTypeName] ?? 0) + 1;
    }

    return counts;
  }

  // 将类型名称映射到本地化的分类名称
  String _getLocalizedTypeName(String typeName, AppLocalizations l10n) {
    switch (typeName) {
      case '登录信息':
        return l10n.loginInfo;
      case '信用卡':
        return l10n.creditCard;
      case '身份标识':
        return l10n.identity;
      case '服务器':
        return l10n.server;
      case '数据库':
        return l10n.database;
      case '安全设备':
        return l10n.secureDevice;
      case 'WiFi密码':
        return l10n.wifiPassword;
      case '安全笔记':
        return l10n.secureNote;
      case '软件许可证':
        return l10n.softwareLicense;
      default:
        return typeName; // 返回原始名称作为默认值
    }
  }

  // 获取菜单项目（动态数量）
  List<SidebarItem> _getMenuItems(
    Map<String, int> counts,
    AppLocalizations l10n,
  ) {
    return [
      SidebarItem(
        icon: Icons.all_inbox_rounded,
        title: l10n.allItems,
        count: counts[l10n.allItems] ?? 0,
        color: AppTheme.primaryBlue,
      ),
      SidebarItem(
        icon: Icons.star_rounded,
        title: l10n.favorites,
        count: counts[l10n.favorites] ?? 0,
        color: AppTheme.warning,
      ),
    ];
  }

  // 获取分类项目（动态数量）
  List<SidebarItem> _getCategoryItems(
    Map<String, int> counts,
    AppLocalizations l10n,
  ) {
    return [
      SidebarItem(
        icon: Icons.vpn_key_rounded,
        title: l10n.loginInfo,
        count: counts[l10n.loginInfo] ?? 0,
        color: Color(0xFF4CAF50),
      ),
      SidebarItem(
        icon: Icons.credit_card_rounded,
        title: l10n.creditCard,
        count: counts[l10n.creditCard] ?? 0,
        color: Color(0xFF9C27B0),
      ),
      SidebarItem(
        icon: Icons.badge_rounded,
        title: l10n.identity,
        count: counts[l10n.identity] ?? 0,
        color: Color(0xFF00BCD4),
      ),
      SidebarItem(
        icon: Icons.dns_rounded,
        title: l10n.server,
        count: counts[l10n.server] ?? 0,
        color: Color(0xFF795548),
      ),
      SidebarItem(
        icon: Icons.storage_rounded,
        title: l10n.database,
        count: counts[l10n.database] ?? 0,
        color: Color(0xFF607D8B),
      ),
      SidebarItem(
        icon: Icons.security_rounded,
        title: l10n.secureDevice,
        count: counts[l10n.secureDevice] ?? 0,
        color: Color(0xFF8BC34A),
      ),
      SidebarItem(
        icon: Icons.wifi_rounded,
        title: l10n.wifiPassword,
        count: counts[l10n.wifiPassword] ?? 0,
        color: Color(0xFF2196F3),
      ),
      SidebarItem(
        icon: Icons.sticky_note_2_rounded,
        title: l10n.secureNote,
        count: counts[l10n.secureNote] ?? 0,
        color: Color(0xFFFF9800),
      ),
      SidebarItem(
        icon: Icons.key_rounded,
        title: l10n.softwareLicense,
        count: counts[l10n.softwareLicense] ?? 0,
        color: Color(0xFF673AB7),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<PasswordProvider>(
      builder: (context, passwordProvider, child) {
        // 计算各分类数量
        final counts = _calculateCounts(passwordProvider.passwords, l10n);
        final menuItems = _getMenuItems(counts, l10n);
        final categoryItems = _getCategoryItems(counts, l10n);

        return Container(
          width: 280,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              right: BorderSide(
                color: Theme.of(context).dividerColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(2, 0),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 应用Logo和名称 - 现代化设计
              Container(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // 主锁图标
                          Container(
                            width: 24,
                            height: 24,
                            child: Image.asset(
                              'images/lock_modern.png',
                              width: 24,
                              height: 24,
                              color: Colors.white,
                              fit: BoxFit.contain,
                            ),
                          ),
                          // 装饰性密钥
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.appTitle,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                        Text(
                          l10n.appSubtitle,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                                letterSpacing: 0.5,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 分隔线
              Divider(
                height: 1,
                color: Theme.of(context).dividerColor.withOpacity(0.3),
              ),

              // 主要导航菜单
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  children: [
                    // 主要分类
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: Text(
                        l10n.mainCategory,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    ...menuItems.map((item) => _buildSidebarTile(item)),

                    const SizedBox(height: 16),

                    // 分类 - 可折叠标题
                    _buildCollapsibleHeader(
                      title: l10n.categories,
                      isExpanded: _isCategoryExpanded,
                      onToggle: () {
                        setState(() {
                          _isCategoryExpanded = !_isCategoryExpanded;
                        });
                      },
                      l10n: l10n,
                    ),

                    // 分类项目（只在展开状态下显示）
                    if (_isCategoryExpanded)
                      ...categoryItems.map((item) => _buildSidebarTile(item)),

                    const SizedBox(height: 16),

                    // 标签 - 可折叠标题
                    _buildCollapsibleHeader(
                      title: l10n.tags,
                      isExpanded: _isTagExpanded,
                      onToggle: () {
                        setState(() {
                          _isTagExpanded = !_isTagExpanded;
                        });
                      },
                      l10n: l10n,
                    ),

                    // 标签项目（只在展开状态下显示）
                    if (_isTagExpanded)
                      ..._buildTagItems(
                        passwordProvider.allTags,
                        passwordProvider.tagCounts,
                      ),
                  ],
                ),
              ),

              // 底部设置和账户
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Theme.of(context).dividerColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    _buildBottomTile(
                      icon: Icons.settings_rounded,
                      title: l10n.settings,
                      onTap: () {
                        // 导航到设置页面
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsScreen(),
                          ),
                        );
                      },
                    ),
                    _buildBottomTile(
                      icon: Icons.person_rounded,
                      title: l10n.myAccount,
                      onTap: () {
                        // 导航到账户页面
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AccountScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSidebarTile(SidebarItem item) {
    final isSelected = selectedCategory == item.title;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            setState(() {
              selectedCategory = item.title;
              selectedTag = null; // 清除标签选择
            });
            // 通知父组件分类变更
            if (widget.onCategoryChanged != null) {
              widget.onCategoryChanged!(item.title);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.3),
                    )
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? item.color
                        : item.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    item.icon,
                    color: isSelected ? Colors.white : item.color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  ),
                ),
                if (item.count > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${item.count}',
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Icon(
                icon,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: 22,
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 构建标签项列表
  List<Widget> _buildTagItems(List<String> tags, Map<String, int> tagCounts) {
    if (tags.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(
            '暂无标签', // 这个可以保持中文，或者后续添加到本地化文件
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
        ),
      ];
    }

    return tags.map((tag) => _buildTagTile(tag, tagCounts[tag] ?? 0)).toList();
  }

  // 构建单个标签项
  Widget _buildTagTile(String tag, int count) {
    final isSelected = selectedTag == tag;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            setState(() {
              // 如果点击已选中的标签，则取消选择
              selectedTag = selectedTag == tag ? null : tag;
              selectedCategory = AppLocalizations.of(
                context,
              )!.allItems; // 重置分类选择
            });

            // 通知父组件标签选择变更
            if (widget.onTagSelected != null) {
              widget.onTagSelected!(selectedTag ?? '');
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.3),
                    )
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(
                            context,
                          ).colorScheme.onSurfaceVariant.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.label_rounded,
                    color: isSelected
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    tag,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (count > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${count}',
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 构建可折叠的标题
  Widget _buildCollapsibleHeader({
    required String title,
    required bool isExpanded,
    required VoidCallback onToggle,
    AppLocalizations? l10n,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onToggle,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                AnimatedRotation(
                  turns: isExpanded ? 0.25 : 0.0, // 90度旋转
                  duration: Duration(milliseconds: 200),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                // 显示展开/收起状态的提示
                Text(
                  isExpanded
                      ? (l10n?.collapse ?? '收起')
                      : (l10n?.expand ?? '展开'),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurfaceVariant.withOpacity(0.7),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SidebarItem {
  final IconData icon;
  final String title;
  final int count;
  final Color color;

  SidebarItem({
    required this.icon,
    required this.title,
    required this.count,
    required this.color,
  });
}
