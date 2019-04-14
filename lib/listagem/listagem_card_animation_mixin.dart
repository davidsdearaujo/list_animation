import 'package:flutter/material.dart';

mixin ListagemCardAnimationMixin<T extends StatefulWidget>
    on State<T>, TickerProviderStateMixin<T> {
  AnimationController controller;
  Animation<Offset> initAnimation;

  AnimationController optionsController;
  Animation<double> optionsRemoveButtonAnimation;
  Animation<double> optionsCardAnimation;

  AnimationController removeController;

  Animation<double> removeAnimation;
  Animation<double> removeHeightAnimation;

  bool removed;

  @override
  void initState() {
    super.initState();

    //controllers
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
      value: removed ? 1 : 0,
    );

    optionsController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
      value: removed ? 1 : 0,
    );

    removeController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
      value: removed ? 1 : 0,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    //curves
    CurvedAnimation removeCurve(Interval interval) {
      return CurvedAnimation(
        curve: Curves.ease,
        parent: CurvedAnimation(
          curve: interval,
          parent: removeController,
        ),
      );
    }

    //animations
    initAnimation = Tween<Offset>(
      begin: Offset(MediaQuery.of(context).size.width, 0),
      end: Offset(0, 0),
    ).animate(controller);

    optionsRemoveButtonAnimation = Tween<double>(
      begin: MediaQuery.of(context).size.width / 2,
      end: 0,
    ).animate(optionsController);

    optionsCardAnimation = Tween<double>(
      begin: 0,
      end: MediaQuery.of(context).size.width / 3,
    ).animate(optionsController);

    removeAnimation = Tween<double>(begin: 0, end: 1).animate(
      removeCurve(Interval(0, 0.5)),
    );

    removeHeightAnimation = Tween<double>(begin: 1, end: 0).animate(
      removeCurve(Interval(0.5, 1)),
    );

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    removeController.dispose();
    super.dispose();
  }
}
