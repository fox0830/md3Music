// 一级页面顶栏的「设置」入口。
//
// 原先只有「我的」页有这颗按钮，其余一级页要进设置得先切到「我的」。
// 抽成共享组件而不是各页复制一份 IconButton：导航方式有个容易写错的点
// （见下方 rootNavigator 说明），复制出去迟早会有人漏掉。
//
// 刻意**不**做成「在 ScrollAwareAppBar 里自动注入」：那个顶栏同时被十几个
// 二级详情页复用（场景详情、频道详情等），自动注入会把设置入口撒得到处都是。
// 由各一级页显式加入，范围看得见、可控。
library;

import 'package:material_ui/material_ui.dart';

import '../modules/settings/settings_page.dart';

/// 紧凑模式的尺寸，与 `discover_page.dart` 的 `_buildActionIcon` 同参。
///
/// 那组常量是该页私有的，这里只能复制数值；两处若要调整需同步
/// （发现页顶栏一行挤了三枚图标，尺寸不一致会很明显）。
const double _kCompactWidth = 36.0;
const double _kCompactHeight = 40.0;

/// 顶栏右上角的设置按钮，行为与「我的」页那颗完全一致。
///
/// [compact] 用于「发现」页：那一行已有搜索与识曲两枚紧凑按钮，
/// 标准尺寸的 IconButton 放进去会明显比邻居大一圈。
class SettingsIconButton extends StatelessWidget {
  const SettingsIconButton({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    void open() => Navigator.of(
      context,
      // rootNavigator: true 是关键——一级页活在 tab 的内层 Navigator 里，
      // 不加这个设置页会被推进 tab 内部，底栏仍然浮在上面且能切走。
      rootNavigator: true,
    ).push(MaterialPageRoute(builder: (_) => const SettingsPage()));

    if (!compact) {
      return IconButton(
        icon: const Icon(Icons.settings),
        tooltip: '设置',
        onPressed: open,
      );
    }
    return IconButton(
      visualDensity: const VisualDensity(horizontal: -3, vertical: -2),
      constraints: const BoxConstraints.tightFor(
        width: _kCompactWidth,
        height: _kCompactHeight,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      icon: const Icon(Icons.settings),
      tooltip: '设置',
      onPressed: open,
    );
  }
}
