import 'package:flutter/material.dart';

enum AsyncButtonType {
  ICON,
  RAISED,
  FLAT,
  OUTLINE
}

class AsyncButton extends StatefulWidget {

  /// Can be IconButton, RaisedButton, FlatButton or OutlinedButton
  final AsyncButtonType type;

  /// In case of IconButton
  final Widget? icon;

  /// In case of IconButton. If null [CenterLoading] is rendered
  final Widget? busyIcon;

  /// The text of the button
  final Text? text;

  /// The color of the button
  final Color color;

  /// The color of the loading circle while button is busy
  final Color? loadingColor;

  /// The border radius of the button
  final BorderRadius? borderRadius;

  final Future<void> Function()? onPressed;

  const AsyncButton.icon({ required this.icon, this.busyIcon, this.onPressed, this.color = Colors.grey, this.loadingColor, Key? key}) : 
    type = AsyncButtonType.ICON,
    text = null,
    borderRadius = null,
    assert(icon != null),
    super(key: key);

  const AsyncButton.raisedButton({required this.text, this.onPressed, this.color = Colors.grey, this.borderRadius = BorderRadius.zero, this.loadingColor, Key? key}):
    type = AsyncButtonType.RAISED,
    icon = null,
    busyIcon = null,
    assert(text != null),
    super(key: key);

  const AsyncButton.outlineButton({required this.text, this.onPressed, this.color = Colors.grey, this.borderRadius = BorderRadius.zero, this.loadingColor, Key? key}):
    type = AsyncButtonType.OUTLINE,
    icon = null,
    busyIcon = null,
    assert(text != null),
    super(key: key);
  
  const AsyncButton.flatButton({required this.text, this.onPressed, this.color = Colors.grey, this.loadingColor, Key? key}):
    type = AsyncButtonType.FLAT,
    icon = null,
    busyIcon = null,
    borderRadius = null,
    assert(text != null),
    super(key: key);

  @override
  _AsyncButtonState createState() => _AsyncButtonState();
}

class _AsyncButtonState extends State<AsyncButton> {

  bool _busy = false;

  @override
  Widget build(BuildContext context) {

    switch (widget.type) {
      case AsyncButtonType.ICON:
        return IconButton(
          icon: _busy ? (widget.busyIcon ?? _Loading(color: widget.color)) : widget.icon!,
          onPressed: _onPressed
        );
      case AsyncButtonType.RAISED:
        return ElevatedButton(
          child: _busy ? _Loading(color: widget.loadingColor ?? widget.color,) : widget.text,
          style: ElevatedButton.styleFrom(
            shape: widget.borderRadius != null ? RoundedRectangleBorder(borderRadius: widget.borderRadius!) : RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            primary: widget.color
          ),
          onPressed: _onPressed
        );
      case AsyncButtonType.FLAT:
        return TextButton(
          child: _busy ? _Loading(color: widget.loadingColor ?? widget.color,) : widget.text!,
          style: TextButton.styleFrom(textStyle: TextStyle(color: widget.color)),
          onPressed: _onPressed
        );
      case AsyncButtonType.OUTLINE:
        return OutlinedButton(
          child: _busy ? _Loading(color: widget.loadingColor ?? widget.color,) : widget.text!,
          style: OutlinedButton.styleFrom(
            //backgroundColor: widget.color,
            textStyle: TextStyle(color: widget.color)
          ),
          onPressed: _onPressed
        );
    }
  }

  void _onPressed() {
    if (widget.onPressed == null) return;
    if (_busy) return;
    setState(() { _busy = true; });
    widget.onPressed!().whenComplete((){
      setState(() { _busy = false; });
    });    
  }
}

class _Loading extends StatelessWidget {

  final Color? color;

  const _Loading({Key? key, this.color }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _color = color ?? Theme.of(context).accentColor;
    Widget loading = SizedBox(
      width: 33,
      height: 33,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: CircularProgressIndicator(
            strokeWidth: 1.5,
            valueColor: AlwaysStoppedAnimation<Color>(_color),
          )
      )
    );
    loading = Center(
      child: loading
    );
    return loading;
  }
}