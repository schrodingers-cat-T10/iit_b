import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:here_sdk/core.dart' as HereCore;
import 'package:here_sdk/mapview.dart' as HereMap;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatGPT Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => BottomNavigation()),
                );
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    ChatScreen(),
    MapPage(),
    UserProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Bottom Navigation'),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _messageController = TextEditingController();
  List<String> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_messages[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _sendMessage(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    String userMessage = _messageController.text;
    _messageController.clear();
    _addMessage('You: $userMessage');

    // Replace "YOUR_OPENAI_API_KEY" with your actual OpenAI API key
    String openaiApiKey = "YOUR_OPENAI_API_KEY";
    String openaiEndpoint = "https://api.openai.com/v1/engines/davinci-codex/completions";

    final response = await http.post(
      Uri.parse(openaiEndpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $openaiApiKey',
      },
      body: jsonEncode({
        'prompt': userMessage,
        'max_tokens': 50,
      }),
    );

    if (response.statusCode == 200) {
      String chatbotResponse = jsonDecode(response.body)['choices'][0]['text'];
      _addMessage('ChatGPT: $chatbotResponse');
    } else {
      _addMessage('Error communicating with ChatGPT');
    }
  }

  void _addMessage(String message) {
    setState(() {
      _messages.add(message);
    });
  }
}

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HereMap(
        onMapCreated: _onMapCreated,
      ),
    );
  }



class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HereMap(
        onMapCreated: _onMapCreated,
      ),
    );
  }

  void _onMapCreated(HereMap.HereMapController hereMapController) {
    
    hereMapController.mapScene.loadSceneForMapScheme(HereMap.MapScheme.normalDay);

  
    HereMap.MapMarker mapMarker = HereMap.MapMarker(HereCore.GeoCoordinates(52.520008, 13.404954), HereMap.MapMarkerImage.withFilePathAndSize('assets/pin.png', 30, 30));
    hereMapController.mapScene.addMapMarker(mapMarker);
  }

class UserProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'User Profile Page',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
