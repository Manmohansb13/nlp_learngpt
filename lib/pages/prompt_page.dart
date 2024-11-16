import 'package:flutter/material.dart';
import 'choose_user.dart';

class PromptPage extends StatefulWidget {
  const PromptPage({super.key});

  @override
  State<PromptPage> createState() => _PromptPageState();
}

class _PromptPageState extends State<PromptPage> {
  final _promptController = TextEditingController();

  void _navigateAndClear() {
    // Navigate to the next page if the text field is not empty
    if (_promptController.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChooseUser(prompt: _promptController.text),
        ),
      ).then((_) {
        // Clear the text field after returning from the next page
        _promptController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Prompt Page",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _promptController,
              decoration: InputDecoration(
                hintText: "Enter your question....",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: null,  // Allow the text field to expand
              minLines: 1,  // Minimum number of lines to display
            ),
            SizedBox(height: 20),  // Space between text field and button
            MaterialButton(
              onPressed: _navigateAndClear,
              height: 50,
              color: Colors.green,
              child: Text("Next"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
