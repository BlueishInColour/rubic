import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FullScreenPage extends StatefulWidget {
  FullScreenPage({
    required this.child,
    required this.dark,
  });

  final bool dark;

  final Image child;
  @override
  _FullScreenPageState createState() => _FullScreenPageState();
}

class _FullScreenPageState extends State<FullScreenPage> {
  @override
  void initState() {
    var brightness = widget.dark ? Brightness.light : Brightness.dark;
    var color = widget.dark ? Colors.black12 : Colors.white70;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: color,
        statusBarColor: color,
        statusBarBrightness: brightness,
        statusBarIconBrightness: brightness,
        systemNavigationBarDividerColor: color,
        systemNavigationBarIconBrightness: brightness));
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        // Restore your settings here...
        ));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.dark ? Colors.black : Colors.white,
      body: GestureDetector(
        onDoubleTap: () => Navigator.pop,
        child: Stack(
          children: [
            Stack(
              children: [
                AnimatedPositioned(
                  duration: Duration(milliseconds: 333),
                  curve: Curves.fastOutSlowIn,
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: InteractiveViewer(
                    panEnabled: true,
                    minScale: 0.5,
                    maxScale: 4,
                    child: widget.child,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onDoubleTap: () => Navigator.pop(context),
              child: SafeArea(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: MaterialButton(
                    padding: const EdgeInsets.all(35),
                    elevation: 0,
                    child: Icon(
                      Icons.cancel,
                      color: widget.dark ? Colors.white : Colors.black,
                      size: 45,
                    ),
                    color: widget.dark ? Colors.black12 : Colors.white70,
                    highlightElevation: 0,
                    minWidth: double.minPositive,
                    height: double.minPositive,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
