import 'package:flutter/material.dart';
import 'dart:math';
import 'package:clipboard/clipboard.dart';

void main() {
  runApp(MyApp());
}

class PasswordGenerator {
  static String generatePassword(int length, bool useUppercase, bool useSymbols) {
    final random = Random();
    final lowercaseLetters = 'abcdefghijklmnopqrstuvwxyz';
    final uppercaseLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final symbols = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

    String chars = lowercaseLetters;
     if (useSymbols) chars += symbols;
    if (useUppercase) chars += uppercaseLetters;
   

    // Ensure the password length is at least the specified length
    length = length.clamp(4, chars.length);

    return List.generate(length, (index) => chars[random.nextInt(chars.length)]).join();
  }
}







class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Password Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PasswordGeneratorScreen(),
    );
  }
}

class PasswordGeneratorScreen extends StatefulWidget {
  @override
  _PasswordGeneratorScreenState createState() => _PasswordGeneratorScreenState();
}

class _PasswordGeneratorScreenState extends State<PasswordGeneratorScreen> {
  bool useUppercase = false;
  bool useSymbols = false;
  int passwordLength = 8;
  late String generatedPassword = ''; // Initialize with an empty string

  void generatePassword() {
    setState(() {
      generatedPassword = PasswordGenerator.generatePassword(passwordLength, useUppercase, useSymbols);
    });
  }

  void copyToClipboard() {
    FlutterClipboard.copy(generatedPassword).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password copied to clipboard'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password Generator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    generatedPassword.isNotEmpty ? generatedPassword : 'Your Password',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: generatedPassword.isNotEmpty ? copyToClipboard : null,
                    child: Text('Copy to Clipboard'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text('Password Length: $passwordLength'),
            Slider(
              value: passwordLength.toDouble(),
              min: 4,
              max: 20,
              onChanged: (value) {
                setState(() {
                  passwordLength = value.toInt();
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Include Uppercase Letters'),
                Switch(
                  value: useUppercase,
                  onChanged: (value) {
                    setState(() {
                      useUppercase = value;
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Include Symbols'),
                Switch(
                  value: useSymbols,
                  onChanged: (value) {
                    setState(() {
                      useSymbols = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: generatePassword,
              child: Text('Generate Password'),
            ),
          ],
        ),
      ),
    );
  }
}
