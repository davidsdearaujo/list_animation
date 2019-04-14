import 'package:flutter/material.dart';
import 'listagem_card_animation_mixin.dart';

class ListagemCard extends StatefulWidget {
  final String content;
  final void Function() onRemove;
  bool removed = false;

  ListagemCard({Key key, this.content, this.onRemove}) : super(key: key);

  @override
  _ListagemCardState createState() => _ListagemCardState();
}

class _ListagemCardState extends State<ListagemCard>
    with TickerProviderStateMixin, ListagemCardAnimationMixin {
  @override
  void initState() {
    removed = widget.removed;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildRemoveAnimation(
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          optionsController.value +=
              details.primaryDelta / MediaQuery.of(context).size.width * 3;
        },
        onHorizontalDragEnd: (details) {
          if (optionsController.value > 0.5)
            optionsController.forward();
          else
            optionsController.reverse();
        },
        child: AnimatedBuilder(
          animation: initAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: initAnimation.value,
              child: child,
            );
          },
          child: AnimatedBuilder(
            animation: optionsController,
            builder: (context, childWidget) {
              return Stack(
                alignment: Alignment.centerLeft,
                children: <Widget>[
                  _buildRemoveButton(),
                  Transform.translate(
                    offset: Offset(optionsCardAnimation.value, 0),
                    child: childWidget,
                  ),
                ],
              );
            },
            child: _buildCard(),
          ),
        ),
      ),
    );
  }

  Widget _buildRemoveButton() {
    return AnimatedBuilder(
      animation: removeController,
      builder: (context, childWidget) {
        var removeButtonX =
            -MediaQuery.of(context).size.width * 0.2 * removeAnimation.value;
        return Transform.translate(
          offset: Offset(optionsRemoveButtonAnimation.value + removeButtonX, 0),
          child: childWidget,
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 3,
        child: Column(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                if (widget.onRemove != null) {
                  await removeController.forward();
                  widget.removed = true;
                  widget.onRemove();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard() {
    return AnimatedBuilder(
      animation: removeController,
      builder: (context, childWidget) {
        var position =
            MediaQuery.of(context).size.width * 2 / 3 * removeAnimation.value;
        return Transform.translate(
          offset: Offset(position, 0),
          child: childWidget,
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Card(
          elevation: 5,
          child: ListTile(
            title: Container(
              height: 150,
              child: Center(
                child: Text(widget.content),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRemoveAnimation({Widget child}) {
    return AnimatedBuilder(
      animation: removeHeightAnimation,
      child: child,
      builder: (context, childWidget) {
        return Align(
          heightFactor: removeHeightAnimation.value,
          child: childWidget,
        );
      },
    );
  }
}
