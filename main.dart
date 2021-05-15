import 'package:orignal/model/Days_Setting.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final String title = '100 Days Of Sweat';

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
    theme: ThemeData(primarySwatch: Colors.deepOrange),
    home: MainPage(title: title),
  );
}

class MainPage extends StatefulWidget {
  final String title;

  const MainPage({
    @required this.title,
  });

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final daysCompleted = DaysSetting(title: 'Challenge Completed');
  final notifications = List<DaysSetting>.generate(100, (i) => DaysSetting(title: 'Day${i + 1}'));
  

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(widget.title),
    ),
    body: ListView(
      children: [
        buildToggleCheckbox(daysCompleted),
        Divider(),
        ...notifications.map(buildSingleCheckbox).toList(),
      ],
    ),
  );

  Widget buildToggleCheckbox(DaysSetting notification) => buildCheckbox(
      notification: notification,
      onClicked: () {
        final newValue = !notification.value;

        setState(() {
          daysCompleted.value = newValue;
          notifications.forEach((notification) {
            notification.value = newValue;
          });
        });
      });

  Widget buildSingleCheckbox(DaysSetting notification) => buildCheckbox(
    notification: notification,
    onClicked: () {
      setState(() {
        final newValue = !notification.value;
        notification.value = newValue;

        if (!newValue) {
          daysCompleted.value = false;
        } else {
          final allow =
          notifications.every((notification) => notification.value);
          daysCompleted.value = allow;
        }
      });
    },
  );

  Widget buildCheckbox({
    @required DaysSetting notification,
    @required VoidCallback onClicked,
  }) =>
      ListTile(
        onTap: onClicked,
        leading: Checkbox(

            value: notification.value,
            onChanged: (value) async {
              final prefs = await SharedPreferences.getInstance();
              prefs.setBool('checkBox', value);
              onClicked();
            }
        ),
        title: Text(
          notification.title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
  void initState() {
    super.initState();
    _loadCounter();
    _savedCounter();
  }
  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      daysCompleted.value = (prefs.getBool("checkBox")) ?? false;
    });
  }

  _savedCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('checkBox', daysCompleted.value);
    });
  }
}
