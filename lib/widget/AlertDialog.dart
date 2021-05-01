import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showDiaglogs(
    String title, String subtitle, Function action, BuildContext context) {
  bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
  // print('show dialog active');
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return isIOS
          ? CupertinoAlertDialog(
              title: Text(
                title.toString(),
                style: TextStyle(fontFamily: 'sarabun'),
              ),
              content: Text(
                subtitle.toString(),
                style: TextStyle(fontFamily: 'sarabun', height: 1.5),
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  onPressed: () {
                    Navigator.pop(context);
                    action();
                  },
                  child: Text(
                    'ปิด',
                  ),
                ),
              ],
            )
          : Center(
              child: WillPopScope(
                onWillPop: () {},
                child: AlertDialog(
                  //  a
                  title: Text(title.toString()),
                  content: new Text(subtitle.toString()),
                  actions: <Widget>[
                    // usually buttons at the bottom of the dialog
                    new FlatButton(
                      child: new Text('ปิด'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        action();
                      },
                    ),
                  ],
                ),
              ),
            );
    },
  );
}

showDiaglogscomfilm(
    String title, String subtitle, Function action, BuildContext context) {
  bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return isIOS
          ? CupertinoAlertDialog(
              title: Text(
                title.toString(),
                style: TextStyle(fontFamily: 'sarabun'),
              ),
              content: Text(
                subtitle.toString(),
                style: TextStyle(fontFamily: 'sarabun', height: 1.5),
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'ปิด',
                    style: TextStyle(fontFamily: 'sarabun'),
                  ),
                ),
                CupertinoDialogAction(
                  onPressed: () {
                    Navigator.pop(context);
                    action();
                  },
                  child: Text(
                    'ยืนยัน',
                    style: TextStyle(fontFamily: 'sarabun'),
                  ),
                ),
              ],
            )
          : Center(
              child: AlertDialog(
                title: Text(title.toString()),
                content: new Text(subtitle.toString()),
                actions: <Widget>[
                  // usually buttons at the bottom of the dialog
                  new FlatButton(
                    child: new Text('ปิด'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  new FlatButton(
                    child: new Text('ยืนยัน'),
                    onPressed: () {
                      Navigator.pop(context);
                      action();
                    },
                  ),
                ],
              ),
            );
    },
  );
}
