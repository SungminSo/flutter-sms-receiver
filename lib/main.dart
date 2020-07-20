import 'package:flutter/material.dart';
import 'package:slack/io/slack.dart';
import 'package:sms/sms.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: ReceiverPage(),
    );
  }
}

class ReceiverPage extends StatelessWidget {
  Slack slack = new Slack('{slack_key}');
  SmsReceiver receiver = new SmsReceiver();

  _addListener() {
    receiver.onSmsReceived.listen((SmsMessage msg) {
      if (msg.sender == "01039167481" || msg.sender == "16449999") {
        List<String> textLines = msg.body.split("\n");
        String company = textLines[1].substring(1, textLines[1].indexOf("]"));
        String datetime = textLines[1].substring(textLines[1].indexOf("]") + 1);
        String account = textLines[2];
        String where = textLines[3];
        String how = textLines[4];
        String amount = textLines[5];
        String rest = textLines[6].substring(2);

        if (how.contains("입금")) {
          Attachment cardReport = Attachment("card detail report",
              fields: [
                Field("계좌", account, short: true),
                Field("일시", datetime, short: true),
                Field("사용처", where, short: true),
                Field("입금 금액", amount, short: true),
              ],
              color: "#36a64f"
          );

          Message message = Message('', username: '덕준', attachments: [cardReport]);
          this.slack.send(message);
        } else {
          Attachment cardReport = Attachment("card detail report",
              fields: [
                Field("계좌", account, short: true),
                Field("일시", datetime, short: true),
                Field("사용처", where, short: true),
                Field("결제 금액", amount, short: true),
              ],
              color: "#FFA500"
          );

          Message message = Message('', username: '덕준', attachments: [cardReport]);
          this.slack.send(message);
        }
      }
    });
  }

  void _sendTestMessage() {
    Attachment cardReport = Attachment("card detail report",
        pretext: "카드 사용 내역",
        text: '테스트 메세지입니다.',
        color: "#FFA500"
    );

    Message message = Message('', username: '덕준', attachments: [cardReport]);
    this.slack.send(message);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    _addListener();

    return Scaffold(
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Text(
          "sms-receiver"
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendTestMessage,
        tooltip: 'Test',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
