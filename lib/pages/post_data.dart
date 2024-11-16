import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PostData extends StatefulWidget {
  final String prompt;
  final String selectedUser;

  PostData({super.key, required this.prompt, required this.selectedUser});

  @override
  _PostDataState createState() => _PostDataState();
}

class _PostDataState extends State<PostData> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _responses = [];
  bool _isLoading = false;
  String? conversationId; // Variable to store conversationId

  @override
  void initState() {
    super.initState();

    // Reset conversationId when page is opened
    conversationId = null;

    // Add the initial prompt to responses
    _responses.add({"type": "prompt", "content": widget.prompt});

    // Call API to generate initial prompts and conversation ID
    _postData(widget.prompt, isFollowUp: false);
  }

  Future<void> _postData(String prompt, {bool isFollowUp = false}) async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(isFollowUp
        ? 'https://qa-ai-7xtp.onrender.com/api/follow-up'
        : 'https://qa-ai-7xtp.onrender.com/api/generate-prompts');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(
        isFollowUp
            ? {
          'conversationId': conversationId,
          'followUpQuestion': prompt,
        }
            : {
          'providedText': prompt,
          'personality': widget.selectedUser,
        },
      ),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      setState(() {
        if (!isFollowUp && jsonResponse['conversationId'] != null) {
          // Store conversationId from the initial response
          conversationId = jsonResponse['conversationId'];
        }
        _responses.add({"type": "response", "content": jsonResponse});
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to post data: ${response.statusCode}');
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Widget _buildContent(Map<String, dynamic> content) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: content['sections'] != null ? content['sections'].length : 0,
      itemBuilder: (context, index) {
        final section = content['sections']?[index];
        if (section != null) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section['heading'] ?? 'No Heading',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  ...(section['content'] as List<dynamic>? ?? []).map<Widget>(
                        (paragraph) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(fontSize: 16.0, color: Colors.black),
                            children: _processText(paragraph ?? 'No content'),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ],
              ),
            ),
          );
        }
        return Container();
      },
    );
  }

  List<TextSpan> _processText(String text) {
    final regex = RegExp(r'\*\*(.*?)\*\*'); // Matches text between **
    final matches = regex.allMatches(text);

    List<TextSpan> spans = [];
    int currentIndex = 0;

    for (final match in matches) {
      // Add regular text before the match
      if (match.start > currentIndex) {
        spans.add(TextSpan(text: text.substring(currentIndex, match.start)));
      }
      // Add bold text
      spans.add(
        TextSpan(
          text: match.group(1), // Extract matched text without **
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      );
      currentIndex = match.end; // Update current index
    }

    // Add remaining text after the last match
    if (currentIndex < text.length) {
      spans.add(TextSpan(text: text.substring(currentIndex)));
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("LearnGPT", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _responses.map((response) {
                  if (response["type"] == "prompt") {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      padding: EdgeInsets.all(12.0),
                      color: Colors.blue[100],
                      child: Text(
                        response["content"] ?? 'No content available',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    );
                  } else if (response["type"] == "response" &&
                      response["content"] is Map<String, dynamic>) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: _buildContent(response["content"]),
                    );
                  } else {
                    return Container();
                  }
                }).toList(),
              ),
            ),
          ),
          if (_isLoading)
            Padding(
              padding: EdgeInsets.all(4.0),
              child: Center(child: CircularProgressIndicator()),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: "Enter your question",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final followUpQuestion = _textController.text;
                    setState(() {
                      _responses.add({"type": "prompt", "content": followUpQuestion});
                    });
                    _postData(followUpQuestion, isFollowUp: conversationId != null);
                    _textController.clear();
                    _scrollToBottom();
                  },
                  child: Text("Send"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
