# Pencil ✏️

一个优雅的想法记录与管理应用，采用 Flutter 构建，使用朱雀仿宋字体，提供美观的Material 3设计体验。

## 功能特性

### 📝 想法管理
- **快速记录**：简洁的文本输入界面，支持多行文本
- **标签分类**：为想法添加自定义标签，便于分类管理
- **分组浏览**：按标签自动分组展示，支持折叠/展开
- **全屏浏览**：沉浸式阅读体验，支持文本选择复制

### ✏️ 编辑功能
- **全屏编辑**：专注的编辑环境，支持实时预览
- **智能标签**：快速选择已有标签，避免重复创建
- **变更检测**：自动检测未保存更改，防止意外丢失
- **批量操作**：支持删除整个标签及其所有想法
- **标签编辑**：主页面点击标签可直接编辑重命名

### 💾 数据持久化
- **本地存储**：使用SharedPreferences实现数据持久化
- **自动保存**：所有操作自动保存，无需手动操作
- **快速加载**：应用启动时自动加载历史数据
- **数据安全**：本地存储，完全私密，支持所有平台

### 🎨 用户体验
- **朱雀仿宋字体**：优雅的中文字体，提升阅读体验
- **Material 3设计**：现代化UI设计，支持亮色/暗色主题
- **响应式布局**：适配不同屏幕尺寸
- **直观操作**：简单易用的交互设计

## 技术架构

### 🏗️ 项目结构
```
lib/
├── main.dart                    # 应用入口
├── constants/
│   └── app_constants.dart       # 应用常量定义
├── models/
│   └── thought_item.dart        # 想法数据模型
├── services/
│   └── thought_service.dart     # 想法管理服务
├── theme/
│   └── app_theme.dart          # 主题配置
├── utils/
│   └── utils.dart              # 通用工具类
├── widgets/
│   ├── common_widgets.dart     # 通用组件
│   └── thought_widgets.dart    # 想法相关组件
└── pages/
    ├── home_page.dart          # 主页面
    ├── edit_thought_page.dart  # 编辑页面
    └── view_thought_page.dart  # 浏览页面
```

### 🔧 核心组件

#### 数据模型 (Models)
- `ThoughtItem`: 想法数据模型，包含ID、内容、标签、创建时间等字段
- 支持 `copyWith`、`toMap`、`fromMap` 等实用方法

#### 服务层 (Services)
- `ThoughtService`: 想法管理核心服务
- 提供增删改查、标签管理、分组等功能
- 支持本地持久化存储，自动加载和保存数据
- 异步操作，不阻塞UI线程

#### 通用组件 (Widgets)
- `TagSelector`: 标签选择器
- `TagFilter`: 标签过滤器
- `ConfirmDialog`: 确认对话框
- `EmptyState`: 空状态组件
- `ThoughtCard`: 想法卡片
- `TagGroupCard`: 标签分组卡片

#### 页面组件 (Pages)
- `HomePage`: 主页面，包含想法输入和列表展示
- `EditThoughtPage`: 全屏编辑页面
- `ViewThoughtPage`: 全屏浏览页面

### 🎯 设计原则

#### 代码质量
- **模块化设计**：清晰的分层架构和职责分离
- **常量管理**：统一的常量定义，便于维护
- **工具类封装**：通用功能抽象为工具方法
- **错误处理**：完善的异常处理和用户提示

#### 用户体验
- **一致性设计**：统一的UI风格和交互模式
- **响应式反馈**：及时的操作反馈和状态提示
- **数据安全**：删除确认和变更检测机制
- **性能优化**：高效的状态管理和渲染

## 运行环境

### 系统要求
- Flutter SDK >= 3.8.1
- Dart SDK >= 3.0.0

### 依赖包
- `flutter`: Flutter SDK
- `cupertino_icons`: iOS风格图标
- `shared_preferences`: 本地数据持久化存储

### 字体配置
应用使用朱雀仿宋字体，字体文件位于 `fonts/ZhuqueFangsong-Regular.ttf`

### 运行指南
```bash
# 克隆项目
git clone <repository-url>

# 进入项目目录
cd pencil

# 获取依赖
flutter pub get

# 运行应用
flutter run

# 运行测试
flutter test
```

### 构建发布
```bash
# Android
flutter build apk

# iOS
flutter build ios

# Web
flutter build web

# Desktop (Linux/Windows/macOS)
flutter build linux
flutter build windows
flutter build macos
```

## 开发计划

### 🚀 已完成功能
- [x] 基础想法记录和管理
- [x] 标签分类和分组展示
- [x] 全屏编辑和浏览
- [x] Material 3 UI设计
- [x] 朱雀仿宋字体集成
- [x] 代码模块化重构
- [x] 完整的测试覆盖
- [x] 本地持久化存储
- [x] 标签编辑功能
- [x] 自动保存机制

### 📋 计划功能
- [ ] 云端同步支持
- [ ] 搜索和过滤功能
- [ ] 导入导出功能
- [ ] 主题自定义
- [ ] 多语言支持
- [ ] 快捷键支持
- [ ] 数据备份恢复

## 贡献指南

欢迎提交Issue和Pull Request来改进这个项目！

### 开发规范
- 遵循Dart/Flutter官方代码规范
- 保持代码注释的简洁和有效
- 确保新功能有相应的测试覆盖
- 遵循现有的项目架构和设计模式

### 提交规范
- 使用清晰的提交信息
- 单个提交专注于单一功能或修复
- 提交前运行测试确保代码质量

## 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 致谢

- Flutter团队提供的优秀框架
- Material Design 3设计规范
- 朱雀仿宋字体项目
