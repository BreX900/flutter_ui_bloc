import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_extensions/flutter_extensions.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_ui_bloc/src/form/typedefs.dart';

/// [DefaultTabController]
class TabBarControllerFieldBlocProvider extends StatelessWidget {
  final SelectFieldBloc<dynamic, dynamic> selectFieldBloc;
  final Widget child;

  const TabBarControllerFieldBlocProvider({
    Key? key,
    required this.selectFieldBloc,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SelectFieldBlocBuilder<dynamic, dynamic>(
      bloc: selectFieldBloc,
      buildWhen: (prev, curr) => prev.items.length != curr.items.length,
      builder: (context, state) {
        return DefaultTabController(
          length: state.items.length,
          initialIndex: max(state.items.indexOf(state.value), 0),
          child: Builder(builder: (context) {
            final controller = DefaultTabController.of(context)!;

            return SelectFieldBlocListener<dynamic, dynamic>(
              bloc: selectFieldBloc,
              listenWhen: (prev, curr) => prev.value != curr.value && prev.items != curr.items,
              listener: (context, state) {
                controller.animateTo(max(0, state.items.indexOf(state.value)));
              },
              child: ChangeableValueListener<TabController, int>(
                listenable: controller,
                selector: (controller) => controller.index,
                listener: (context, index) {
                  selectFieldBloc.updateValue(state.items[index]);
                },
                child: child,
              ),
            );
          }),
        );
      },
    );
  }
}

/// [TabBar]
class TabBarFieldBlocBuilder<TValue> extends StatelessWidget implements PreferredSizeWidget {
  final SelectFieldBloc<TValue, dynamic> selectFieldBloc;

  /// [TabBar.isScrollable]
  final bool isScrollable;

  /// [TabBar.indicatorColor]
  final Color? indicatorColor;

  /// [TabBar.indicator]
  final Decoration? indicator;

  /// [TabBar.automaticIndicatorColorAdjustment]
  final bool automaticIndicatorColorAdjustment;

  /// [TabBar.indicatorSize]
  final TabBarIndicatorSize? indicatorSize;

  /// [TabBar.labelColor]
  final Color? labelColor;

  /// [TabBar.unselectedLabelColor]
  final Color? unselectedLabelColor;

  /// [TabBar.labelStyle]
  final TextStyle? labelStyle;

  /// [TabBar.labelPadding]
  final EdgeInsetsGeometry? labelPadding;

  /// [TabBar.unselectedLabelStyle]
  final TextStyle? unselectedLabelStyle;

  /// [TabBar.overlayColor]
  final MaterialStateProperty<Color?>? overlayColor;

  /// [TabBar.dragStartBehavior]
  final DragStartBehavior dragStartBehavior;

  /// [TabBar.mouseCursor]
  final MouseCursor? mouseCursor;

  /// [TabBar.enableFeedback]
  final bool? enableFeedback;

  /// [TabBar.onTap]
  final ValueChanged<int>? onTap;

  /// [TabBar.physics]
  final ScrollPhysics? physics;

  final Widget Function(BuildContext context, TValue value) tabBuilder;

  const TabBarFieldBlocBuilder({
    Key? key,
    required this.selectFieldBloc,
    this.isScrollable = false,
    this.indicatorColor,
    this.automaticIndicatorColorAdjustment = true,
    this.indicator,
    this.indicatorSize,
    this.labelColor,
    this.labelStyle,
    this.labelPadding,
    this.unselectedLabelColor,
    this.unselectedLabelStyle,
    this.dragStartBehavior = DragStartBehavior.start,
    this.overlayColor,
    this.mouseCursor,
    this.enableFeedback,
    this.onTap,
    this.physics,
    required this.tabBuilder,
  }) : super(key: key);

  static const double tabHeight = 46.0;
  static const double textAndIconTabHeight = 72.0;

  @override
  Size get preferredSize => const Size.fromHeight(textAndIconTabHeight + 2.0);

  @override
  Widget build(BuildContext context) {
    return SelectFieldBlocBuilder<TValue, dynamic>(
      bloc: selectFieldBloc,
      buildWhen: (prev, curr) => prev.items != curr.items,
      builder: (context, state) {
        return TabBar(
          isScrollable: isScrollable,
          indicatorColor: indicatorColor,
          automaticIndicatorColorAdjustment: automaticIndicatorColorAdjustment,
          indicator: indicator,
          indicatorSize: indicatorSize,
          labelColor: labelColor,
          labelStyle: labelStyle,
          labelPadding: labelPadding,
          unselectedLabelColor: unselectedLabelColor,
          unselectedLabelStyle: unselectedLabelStyle,
          dragStartBehavior: dragStartBehavior,
          overlayColor: overlayColor,
          mouseCursor: mouseCursor,
          enableFeedback: enableFeedback,
          onTap: onTap,
          physics: physics,
          tabs: state.items.map((item) => tabBuilder(context, item!)).toList(),
        );
      },
    );
  }
}

/// [TabBarView]
class TabBarViewFieldBlocBuilder<TValue> extends StatelessWidget {
  final SelectFieldBloc<TValue, dynamic> selectFieldBloc;

  /// [TabBarView.physics]
  final ScrollPhysics? physics;

  /// [TabBarView.dragStartBehavior]
  final DragStartBehavior dragStartBehavior;

  final Widget Function(BuildContext context, TValue value) viewBuilder;

  const TabBarViewFieldBlocBuilder({
    Key? key,
    required this.selectFieldBloc,
    this.physics,
    this.dragStartBehavior = DragStartBehavior.start,
    required this.viewBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SelectFieldBlocBuilder<TValue, dynamic>(
      bloc: selectFieldBloc,
      buildWhen: (prev, curr) => prev.items != curr.items,
      builder: (context, state) {
        return TabBarView(
          physics: physics,
          dragStartBehavior: dragStartBehavior,
          children: state.items.map((item) => viewBuilder(context, item!)).toList(),
        );
      },
    );
  }
}
