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
import 'package:password_manager/presentation/screens/sidebar.dart';
import 'package:password_manager/presentation/screens/vault_list.dart';
import 'package:password_manager/presentation/screens/password_details.dart';
import 'package:password_manager/presentation/screens/add_password_screen.dart';
import 'package:password_manager/data/models/password_entry.dart';
import 'package:password_manager/presentation/providers/password_provider.dart';
import 'package:provider/provider.dart';
import 'package:password_manager/l10n/app_localizations.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PasswordEntry? _selectedPassword; // 选中的密码
  late VaultList _vaultList;
  String _searchQuery = '';
  String _selectedCategory = '所有项目'; // 添加分类筛选状态
  String? _selectedTag; // 添加标签筛选状态
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchFocused = false;
  String? _selectedPasswordId; // 记录当前选中的密码ID

  @override
  void initState() {
    super.initState();
    _vaultList = VaultList(
      onPasswordSelected: (password) {
        setState(() {
          _selectedPassword = password;
          _selectedPasswordId = password.id;
        });
      },
      searchQuery: _searchQuery,
      selectedCategory: _selectedCategory, // 传递分类筛选参数
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _vaultList = VaultList(
        onPasswordSelected: (password) {
          setState(() {
            _selectedPassword = password;
            _selectedPasswordId = password.id;
          });
        },
        searchQuery: _searchQuery,
        selectedCategory: _selectedCategory, // 传递分类筛选参数
      );
    });
  }

  // 处理分类变更
  void _onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category;
      _selectedTag = null; // 清除标签筛选
      _selectedPassword = null; // 清除当前选中的密码
      _selectedPasswordId = null; // 清除选中的密码ID
      _vaultList = VaultList(
        onPasswordSelected: (password) {
          setState(() {
            _selectedPassword = password;
            _selectedPasswordId = password.id;
          });
        },
        searchQuery: _searchQuery,
        selectedCategory: _selectedCategory,
        selectedTag: _selectedTag, // 传递标签筛选参数
      );
    });
  }

  // 处理标签选择
  void _onTagSelected(String tag) {
    setState(() {
      _selectedTag = tag.isEmpty ? null : tag; // 如果标签为空则清除筛选
      _selectedCategory = '所有项目'; // 清除分类筛选
      _selectedPassword = null; // 清除当前选中的密码
      _selectedPasswordId = null; // 清除选中的密码ID
      _vaultList = VaultList(
        onPasswordSelected: (password) {
          setState(() {
            _selectedPassword = password;
            _selectedPasswordId = password.id;
          });
        },
        searchQuery: _searchQuery,
        selectedCategory: _selectedCategory,
        selectedTag: _selectedTag, // 传递标签筛选参数
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PasswordProvider>(
      builder: (context, passwordProvider, child) {
        // 当Provider中的密码列表更新时，同步更新选中的密码
        if (_selectedPasswordId != null) {
          final updatedPassword = passwordProvider.passwords.firstWhere(
            (p) => p.id == _selectedPasswordId,
            orElse: () => _selectedPassword!,
          );
          if (updatedPassword.id == _selectedPasswordId &&
              updatedPassword != _selectedPassword) {
            // 使用WidgetsBinding延迟更新，避免在build过程中调用setState
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _selectedPassword = updatedPassword;
                });
              }
            });
          }
        }

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: Row(
            children: [
              // 侧边栏
              Sidebar(
                onCategoryChanged: _onCategoryChanged,
                onTagSelected: _onTagSelected,
              ), // 添加分类变更回调
              // 主内容区域
              Expanded(
                child: Column(
                  children: [
                    // 现代化顶部栏
                    Container(
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        border: Border(
                          bottom: BorderSide(
                            color: Theme.of(
                              context,
                            ).dividerColor.withOpacity(0.3),
                            width: 1.0,
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // 搜索栏 - 现代化设计
                          Expanded(
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.surfaceVariant,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: _isSearchFocused
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).dividerColor,
                                  width: _isSearchFocused ? 2 : 1,
                                ),
                              ),
                              child: Focus(
                                onFocusChange: (focused) {
                                  setState(() {
                                    _isSearchFocused = focused;
                                  });
                                },
                                child: TextField(
                                  controller: _searchController,
                                  onChanged: _onSearchChanged,
                                  decoration: InputDecoration(
                                    hintText: AppLocalizations.of(
                                      context,
                                    )!.searchPlaceholder,
                                    hintStyle: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                      fontSize: 15,
                                    ),
                                    prefixIcon: Container(
                                      margin: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: _isSearchFocused
                                            ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withOpacity(0.1)
                                            : Theme.of(
                                                context,
                                              ).dividerColor.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.search_rounded,
                                        color: _isSearchFocused
                                            ? Theme.of(
                                                context,
                                              ).colorScheme.primary
                                            : Theme.of(
                                                context,
                                              ).colorScheme.onSurfaceVariant,
                                        size: 20,
                                      ),
                                    ),
                                    suffixIcon: _searchQuery.isNotEmpty
                                        ? IconButton(
                                            icon: Icon(
                                              Icons.clear_rounded,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onSurfaceVariant,
                                              size: 20,
                                            ),
                                            onPressed: () {
                                              _searchController.clear();
                                              _onSearchChanged('');
                                            },
                                          )
                                        : null,
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 16),

                          // 操作按钮
                          Container(
                            decoration: BoxDecoration(
                              gradient: AppTheme.primaryGradient,
                              borderRadius: BorderRadius.circular(12),
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
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () async {
                                  // 跳转到添加新密码页面
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AddPasswordScreen(),
                                    ),
                                  );

                                  // 如果成功添加密码，刷新列表
                                  if (result == true) {
                                    setState(() {
                                      // 重新构建VaultList以刷新数据
                                      _vaultList = VaultList(
                                        onPasswordSelected: (password) {
                                          setState(() {
                                            _selectedPassword = password;
                                            _selectedPasswordId = password.id;
                                          });
                                        },
                                        searchQuery: _searchQuery,
                                        selectedCategory: _selectedCategory,
                                      );
                                    });
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.add_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        AppLocalizations.of(
                                          context,
                                        )!.addPassword,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 主内容区域
                    Expanded(
                      child: Row(
                        children: [
                          // 密码列表（传递选中回调）
                          Expanded(
                            flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                border: Border(
                                  right: BorderSide(
                                    color: Theme.of(
                                      context,
                                    ).dividerColor.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: _vaultList,
                            ),
                          ),

                          // 密码详情（接收选中的密码）
                          Expanded(
                            flex: 5,
                            child: Container(
                              color: Theme.of(context).colorScheme.background,
                              child: PasswordDetails(
                                selectedPassword: _selectedPassword,
                              ),
                            ),
                          ),
                        ],
                      ),
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
}
