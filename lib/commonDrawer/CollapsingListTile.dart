import 'package:eaglebiz/main.dart';
import 'package:flutter/material.dart';

class CollapsingListTile extends StatefulWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final Function onTap;

  CollapsingListTile(
      {@required this.title,
        @required this.icon,
        this.isSelected = false,
        this.onTap});

  @override
  _CollapsingListTileState createState() => _CollapsingListTileState();
}

class _CollapsingListTileState extends State<CollapsingListTile> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: widget.isSelected
              ? Colors.transparent.withOpacity(0.9)
              : Colors.transparent,
        ),
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        child: Column(
          children: <Widget>[
            Icon(
              widget.icon,
              color: widget.isSelected ? lwtColor : Colors.white30,
              size: 38.0,
            ),
            Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.center,
                direction: Axis.horizontal,
                children: <Widget>[Text(widget.title,style: TextStyle(fontSize: 5,color: Colors.white),)])
          ],
        ),
      ),
    );
  }
}
