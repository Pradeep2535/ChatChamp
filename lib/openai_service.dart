import 'dart:convert';

import 'package:chat_gen_ai_app/secrets.dart';
import 'package:http/http.dart' as http;

class OpenAIService {
  final List<Map<String, String>> messages = [];

  Future<String> apiDecider(String prompt) async {
    try {
      final response = await http.post(
          Uri.parse('https://api.openai.com/v1/chat/completions'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $openaiApiKey",
          },
          body: jsonEncode({
            "model": "gpt-3.5-turbo",
            "messages": [
              //{"role": "system", "content": "You are a helpful assistant."},
              {
                "role": "user",
                "content":
                    "Does the message given below want to generate an AI picture,image, art or anything similar to generating a image? \n$prompt . \nSimply answer with yes or no. No need to answer other than yes or no."
              },
            ]
          }));
      print(response.body);
      if (response.statusCode == 200) {
        String content =
            jsonDecode(response.body)['choices'][0]['message']['content'];
        content = content.trim();

        switch (content) {
          case 'yes':
          case 'yes.':
          case 'Yes':
          case 'Yes.':
          case 'YES':
          case 'YES.':
            return dallEAPI(prompt);
          default:
            return chatGPTAPI(prompt);
        }
      }
      return 'Internal Error occured';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> chatGPTAPI(String prompt) async {
    messages.add({'role': 'user', 'content': prompt});
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $openaiApiKey",
        },
        body: jsonEncode(
          {
            "model": "gpt-3.5-turbo",
            "messages": messages,
          },
        ),
      );

      if (response.statusCode == 200) {
        String content =
            jsonDecode(response.body)['choices'][0]['message']['content'];
        content = content.trim();

        messages.add({
          'role': 'assistant',
          'content': content,
        });
        return content;
      }
      return 'An Internal Error occured';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> dallEAPI(String prompt) async {
    messages.add({'role': 'user', 'content': prompt});
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/images/generations'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $openaiApiKey",
        },
        body: jsonEncode(
          {
            'prompt': prompt,
            'n': 1,
          },
        ),
      );

      if (response.statusCode == 200) {
        String imageUrl = jsonDecode(response.body)['data'][0]['url'];
        imageUrl = imageUrl.trim();

        messages.add({
          'role': 'assistant',
          'content': imageUrl,
        });
        return imageUrl;
      }
      return 'An Internal Error occured';
    } catch (e) {
      return e.toString();
    }
  }
}
