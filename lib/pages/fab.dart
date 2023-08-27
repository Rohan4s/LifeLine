import 'dart:math';

import 'package:flutter/material.dart';

bool toggle = true;

class Fab extends StatefulWidget {
  late final count;
  late List<String> labels;
  List<IconData> icons;
  final List<VoidCallback?> functions;
  final List<Color?> colors;

  Fab(
      {super.key,
      required this.colors,
      required this.count,
      required this.icons,
      required this.functions,
      required this.labels});

  @override
  State<Fab> createState() => _FabState();
}

class _FabState extends State<Fab> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  late final List<Color?> colors;

  late final cnt;
  late List<IconData> icons;
  late final List<VoidCallback?> functions;
  late final List<String> labels;
  double size1 = 50.0;
  List<Alignment> alignments = [];
  // List<IconData> icons =[Icons.add,Icons.edit,Icons.message];
  @override
  void initState() {
    cnt = widget.count;
    icons = widget.icons;
    functions = widget.functions;
    labels = widget.labels;
    colors = widget.colors;

    // TODO: implement initState
    for (int i = 0; i < cnt; i++) {
      alignments.add(const Alignment(0.25, 1));
      // alignments[i] = const Alignment(0,0);
    }
    // alignments=[const Alignment(0, 0),const Alignment(0, 0),const Alignment(0, 0)];

    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 350),
        reverseDuration: const Duration(milliseconds: 285));

    _animation = CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn);

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> animatedAligns = [];
    for (int i = 0; i < cnt; i++) {
      animatedAligns.add(
        AnimatedAlign(
          duration: toggle
              ? const Duration(milliseconds: 275)
              : const Duration(milliseconds: 875),
          alignment: alignments[i],
          curve: toggle ? Curves.easeIn : Curves.elasticOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 275),
            curve: toggle ? Curves.easeIn : Curves.easeOut,
            height: 100,
            width: 150,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Row(
              children: [
                TextButton.icon(
                  icon: Icon(
                    icons[i],
                    size: 25,
                    color: colors[i],
                  ),
                  // color: colors[i],
                  onPressed: (){
                    functions[i]?.call();
                    setState(() {
                      toggle = !toggle;
                      _controller.reverse();
                      for (int i = 0; i < cnt; i++) {
                        alignments[i] = const Alignment(0.25, 1);
                      }
                    });
                  },      /// Fix Here
                  label: Text(
                    toggle ? '' : labels[i],
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: colors[i]),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container( // this container
      height: toggle ? 70 : 200,
      width: toggle ? 70 : 150,
      color: Colors.transparent,
      child: Stack(
        children: [
          ...animatedAligns,
          Align(
            alignment: Alignment.bottomCenter,
            child: Transform.rotate(
              angle: _animation.value * pi * 3 / 4,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 375),
                curve: Curves.easeOut,
                alignment: Alignment.center,
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.yellow[600],
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: IconButton(
                    splashColor: Colors.black54,
                    splashRadius: 31,
                    onPressed: () {
                      setState(() {
                        if (toggle) {
                          toggle = !toggle;
                          _controller.forward();
                          for (int i = 0; i < cnt; i++) {
                            Future.delayed(const Duration(milliseconds: 10),
                                () {
                              alignments[i] = Alignment(0, 1 - 1 * (i + 1));
                            });
                          }
                        } else {
                          toggle = !toggle;
                          _controller.reverse();
                          for (int i = 0; i < cnt; i++) {
                            alignments[i] = const Alignment(0.25, 1);
                          }
                        }
                      });
                    },
                    icon: const Icon(Icons.add, size: 30),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
