import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fcm/Login.dart';
import 'package:fcm/fcm_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  final String user;
  Homepage({super.key, required this.user});

  @override
  State<Homepage> createState() => _HomepageState();
}

final TextEditingController title = TextEditingController();
final TextEditingController desc = TextEditingController();
String dropdownValue = 'employee';
final List<String> items = <String>['employee', 'admin'];

class _HomepageState extends State<Homepage> {
  Firebasepushnotify() async {
    final fcm = FirebaseMessaging.instance;

    await fcm.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      sound: true,
    );
//when user login as employee then subscribe to employee topic and unsubscribe from admin topic
//when user login as admin then subscribe to admin topic and unsubscribe from employee topic
    if (widget.user == 'employee') {
      fcm.subscribeToTopic("employee");
      fcm.unsubscribeFromTopic("admin");
    } else {
      fcm.subscribeToTopic("admin");
      fcm.unsubscribeFromTopic("employee");
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        if (mounted) {
          AwesomeDialog(
            context: context,
            title: message.notification!.title,
            desc: message.notification!.body,
            dialogType: DialogType.success,
            animType: AnimType.scale,
            btnOkOnPress: () {},
          ).show();
        }
      }
    });
  }

  @override
  void initState() {
    Firebasepushnotify();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('send notification'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Login_page()),
                (route) => false);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Text(
                "Login as ${widget.user}",
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: title,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'title',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: desc,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'description',
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  const Text(
                    'send to',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<String>(
                        value: dropdownValue,
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                        items:
                            items.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList()),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: () {
                  FcmController()
                      .sendNotification(title.text, desc.text, dropdownValue);
                },
                child: const Text('send'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
