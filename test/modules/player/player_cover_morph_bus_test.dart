import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:md3music/modules/player/player_cover_morph.dart';

void main() {
  test('coverSuppressed=true 时封面不画，文字判据不受影响', () {
    final bus = PlayerCoverMorphBus.instance;
    // 形变在生产环境已整体关闭；本用例验证的是「封面压制」这条独立判据，
    // 需显式开启总开关才能走到它。
    PlayerCoverMorphBus.kCoverMorphEnabled = true;
    addTearDown(() => PlayerCoverMorphBus.kCoverMorphEnabled = false);
    bus.coverSuppressed = false;
    bus.eligible = true;
    bus.miniRect = const Rect.fromLTWH(0, 0, 44, 44);
    bus.settledRect = const Rect.fromLTWH(40, 60, 300, 300);
    bus.miniTextRect = const Rect.fromLTWH(60, 10, 200, 30);
    bus.settledTextRect = const Rect.fromLTWH(40, 380, 300, 60);
    bus.textEligible = true;
    addTearDown(() {
      bus.coverSuppressed = false;
      bus.eligible = false;
      bus.textEligible = false;
      bus.miniRect = null;
      bus.settledRect = null;
      bus.miniTextRect = null;
      bus.settledTextRect = null;
    });

    expect(bus.layerWillDraw, isTrue);
    expect(bus.coverLayerWillDraw, isTrue);
    expect(bus.textWillDraw, isTrue);

    bus.coverSuppressed = true;
    expect(bus.coverLayerWillDraw, isFalse);
    // 文字形变保留（用户明确要求）
    expect(bus.textWillDraw, isTrue);
  });

  test('总开关关闭时：封面与文字两侧判据同时为假（不留"谁都不画"的空洞）', () {
    // 生产默认值就是 false——播放页的大封面/歌名歌手跟整页一起滑出，
    // 迷你条的小封面/歌名歌手随整条一起显隐，两端都不再单独起飞。
    expect(
      PlayerCoverMorphBus.kCoverMorphEnabled,
      isFalse,
      reason: '默认关闭；要恢复共享元素形变把它改回 true 即可',
    );

    final bus = PlayerCoverMorphBus.instance;
    // 把所有「会画」的前置条件都摆好，证明是总开关而非缺数据导致不画
    bus.eligible = true;
    bus.textEligible = true;
    bus.coverSuppressed = false;
    bus.miniRect = const Rect.fromLTWH(0, 0, 44, 44);
    bus.settledRect = const Rect.fromLTWH(40, 60, 300, 300);
    bus.miniTextRect = const Rect.fromLTWH(60, 10, 200, 30);
    bus.settledTextRect = const Rect.fromLTWH(40, 380, 300, 60);
    addTearDown(() {
      bus.eligible = false;
      bus.textEligible = false;
      bus.miniRect = null;
      bus.settledRect = null;
      bus.miniTextRect = null;
      bus.settledTextRect = null;
    });

    expect(bus.layerWillDraw, isFalse);
    expect(bus.coverLayerWillDraw, isFalse);
    expect(bus.textWillDraw, isFalse);
  });
}
