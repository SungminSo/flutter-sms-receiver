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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  Slack slack = new Slack('https://hooks.slack.com/services/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');
  SmsReceiver receiver = new SmsReceiver();

  void initState() {
    super.initState();

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
          Attachment cardReport = new Attachment("card detail report",
              fields: [
                Field("계좌", account, short: true),
                Field("일시", datetime, short: true),
                Field("사용처", where, short: true),
                Field("입금 금액", amount, short: true),
              ],
              color: "#36a64f"
          );

          Message message = new Message('', username: '덕준', attachments: [cardReport]);
          this.slack.send(message);
        } else {
          Attachment cardReport = new Attachment("card detail report",
              fields: [
                Field("계좌", account, short: true),
                Field("일시", datetime, short: true),
                Field("사용처", where, short: true),
                Field("결제 금액", amount, short: true),
              ],
              color: "#FFA500"
          );

          Message message = new Message('', username: '덕준', attachments: [cardReport]);
          this.slack.send(message);
        }
      }
    });
  }

  void _sendTestMessage() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });

    Attachment cardReport = new Attachment("card detail report",
        pretext: "카드 사용 내역",
        text: '테스트 메세지입니다.',
        color: "#FFA500"
    );

    Message message = new Message('', username: '덕준', attachments: [cardReport]);
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
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendTestMessage,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
