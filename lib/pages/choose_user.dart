import 'package:flutter/material.dart';
import 'package:nlpproject/pages/post_data.dart';

class ChooseUser extends StatefulWidget {
  final String prompt;
  ChooseUser({super.key, required this.prompt});

  @override
  State<ChooseUser> createState() => _ChooseUserState();
}

class _ChooseUserState extends State<ChooseUser> {
  int _selectedOption = -1;
  String _currentUser = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Choose Personality",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildUserOption(
                    imagePath: 'ass/ALEX.png',
                    userName: 'Alex',
                    value: 0,
                    description:
                    'An expert teacher who explains concepts in detail with clear structure and relevant examples.',
                  ),
                  _buildUserOption(
                    imagePath: 'ass/ALICE.png',
                    userName: 'Alice',
                    value: 1,
                    description:
                    'A strict teacher who explains concepts through a series of questions and answers.',
                  ),
                  _buildUserOption(
                    imagePath: 'ass/BOB.png',
                    userName: 'Bob',
                    value: 2,
                    description:
                    'A cool teacher who explains concepts directly and concisely.',
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: MaterialButton(
              onPressed: _selectedOption == -1
                  ? null // Disable the button when no option is selected
                  : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostData(
                      prompt: widget.prompt,
                      selectedUser: _currentUser,
                    ),
                  ),
                );
              },
              height: 50,
              color: _selectedOption == -1 ? Colors.grey : Colors.green,
              disabledColor: Colors.grey, // Color when the button is disabled
              child: Text(
                "Submit",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserOption({
    required String imagePath,
    required String userName,
    required int value,
    required String description,
  }) {
    final bool isSelected = _selectedOption == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOption = value;
          _currentUser = userName.toLowerCase();
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green[100] : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              imagePath,
              width: 50,
              height: 50,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
