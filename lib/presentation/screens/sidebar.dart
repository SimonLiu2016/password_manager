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
import 'package:provider/provider.dart';

class Sidebar extends StatefulWidget {
  final Function(String)? onCategoryChanged; // 添加分类变更回调
  final Function(String)? onTagSelected; // 添加标签选择回调

  const Sidebar({super.key, this.onCategoryChanged, this.onTagSelected});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  String selectedCategory = '所有项目';
  String? selectedTag; // 当前选中的标签
  bool _isCategoryExpanded = true; // 分类菜单展开状态
  bool _isTagExpanded = false; // 标签菜单展开状态（默认收起）

  // 计算各分类的密码数量
  Map<String, int> _calculateCounts(List<PasswordEntry> passwords) {
    final counts = <String, int>{
      '所有项目': passwords.length,
      '收藏': passwords.where((p) => p.isFavorite).length, // 实现收藏数量统计
      '登录信息': 0,
      '信用卡': 0,
      '身份标识': 0,
      '服务器': 0,
      '数据库': 0,
      '安全设备': 0, // 修正为正确的类型名称
      'WiFi密码': 0, // 修正为正确的类型名称
      '安全笔记': 0,
      '软件许可证': 0,
    };

    for (final password in passwords) {
      final typeName = PasswordEntryTypeConfig.getName(password.type);
      counts[typeName] = (counts[typeName] ?? 0) + 1;
    }

    return counts;
  }

  // 获取菜单项目（动态数量）
  List<SidebarItem> _getMenuItems(Map<String, int> counts) {
    return [
      SidebarItem(
        icon: Icons.all_inbox_rounded,
        title: '所有项目',
        count: counts['所有项目'] ?? 0,
        color: AppTheme.primaryBlue,
      ),
      SidebarItem(
        icon: Icons.star_rounded,
        title: '收藏',
        count: counts['收藏'] ?? 0,
        color: AppTheme.warning,
      ),
    ];
  }

  // 获取分类项目（动态数量）
  List<SidebarItem> _getCategoryItems(Map<String, int> counts) {
    return [
      SidebarItem(
        icon: Icons.vpn_key_rounded,
        title: '登录信息',
        count: counts['登录信息'] ?? 0,
        color: Color(0xFF4CAF50),
      ),
      SidebarItem(
        icon: Icons.credit_card_rounded,
        title: '信用卡',
        count: counts['信用卡'] ?? 0,
        color: Color(0xFF9C27B0),
      ),
      SidebarItem(
        icon: Icons.badge_rounded,
        title: '身份标识',
        count: counts['身份标识'] ?? 0,
        color: Color(0xFF00BCD4),
      ),
      SidebarItem(
        icon: Icons.dns_rounded,
        title: '服务器',
        count: counts['服务器'] ?? 0,
        color: Color(0xFF795548),
      ),
      SidebarItem(
        icon: Icons.storage_rounded,
        title: '数据库',
        count: counts['数据库'] ?? 0,
        color: Color(0xFF607D8B),
      ),
      SidebarItem(
        icon: Icons.security_rounded,
        title: '安全设备',
        count: counts['安全设备'] ?? 0,
        color: Color(0xFF8BC34A),
      ),
      SidebarItem(
        icon: Icons.wifi_rounded,
        title: 'WiFi密码',
        count: counts['WiFi密码'] ?? 0,
        color: Color(0xFF2196F3),
      ),
      SidebarItem(
        icon: Icons.sticky_note_2_rounded,
        title: '安全笔记',
        count: counts['安全笔记'] ?? 0,
        color: Color(0xFFFF9800),
      ),
      SidebarItem(
        icon: Icons.key_rounded,
        title: '软件许可证',
        count: counts['软件许可证'] ?? 0,
        color: Color(0xFF673AB7),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PasswordProvider>(
      builder: (context, passwordProvider, child) {
        // 计算各分类数量
        final counts = _calculateCounts(passwordProvider.passwords);
        final menuItems = _getMenuItems(counts);
        final categoryItems = _getCategoryItems(counts);

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
                            color: AppTheme.primaryBlue.withOpacity(0.3),
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
                          'SecureVault',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                        ),
                        Text(
                          'Password Manager',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppTheme.textSecondary,
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
                        '主要',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppTheme.textSecondary,
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
                      title: '分类',
                      isExpanded: _isCategoryExpanded,
                      onToggle: () {
                        setState(() {
                          _isCategoryExpanded = !_isCategoryExpanded;
                        });
                      },
                    ),

                    // 分类项目（只在展开状态下显示）
                    if (_isCategoryExpanded)
                      ...categoryItems.map((item) => _buildSidebarTile(item)),

                    const SizedBox(height: 16),

                    // 标签 - 可折叠标题
                    _buildCollapsibleHeader(
                      title: '标签',
                      isExpanded: _isTagExpanded,
                      onToggle: () {
                        setState(() {
                          _isTagExpanded = !_isTagExpanded;
                        });
                      },
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
                      title: '设置',
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
                      title: '我的账户',
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
                  ? AppTheme.primaryBlue.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(color: AppTheme.primaryBlue.withOpacity(0.3))
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
                          ? AppTheme.primaryBlue
                          : AppTheme.textPrimary,
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
                          ? AppTheme.primaryBlue
                          : AppTheme.textSecondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${item.count}',
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : AppTheme.textSecondary,
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
              Icon(icon, color: AppTheme.textSecondary, size: 22),
              const SizedBox(width: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondary,
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
            '暂无标签',
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
              selectedCategory = '所有项目'; // 重置分类选择
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
                  ? AppTheme.primaryBlue.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(color: AppTheme.primaryBlue.withOpacity(0.3))
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primaryBlue
                        : AppTheme.textSecondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.label_rounded,
                    color: isSelected ? Colors.white : AppTheme.textSecondary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    tag,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: isSelected
                          ? AppTheme.primaryBlue
                          : AppTheme.textPrimary,
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
                          ? AppTheme.primaryBlue
                          : AppTheme.textSecondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${count}',
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : AppTheme.textSecondary,
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
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                // 显示展开/收起状态的提示
                Text(
                  isExpanded ? '收起' : '展开',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary.withOpacity(0.7),
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
