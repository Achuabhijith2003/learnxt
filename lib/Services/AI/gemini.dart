import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:learnxt/Services/AI/data_embedded.dart';
import 'package:learnxt/key.dart';

class AI extends DataEmbedded {
  geminirespones(
      String promt, String docId, keywords, BuildContext context) async {
    try {
      List<Part> userparts = [];
      List<Part> aiparts = [];
      final user = await fetchChatuser(docId);
      final ai = await fetchChatai(docId);
      late ChatSession chat;

      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: GEMINI_API_KEY,
        generationConfig: GenerationConfig(
          temperature: 1,
          topK: 40,
          topP: 0.95,
          maxOutputTokens: 8192,
          responseMimeType: 'text/plain',
        ),
      );

      // ignore: unnecessary_null_comparison
      if (user != null || ai != null) {
        final userpart = TextPart(user);
        final aipart = TextPart(ai);
        userparts.add(userpart);
        aiparts.add(aipart);
        final chats = model.startChat(history: [
          Content("User", userparts),
          Content("model", aiparts),
        ]);
        chat = chats;
      } else {
        final chats = model.startChat(history: []);
        chat = chats;
      }
      var message = promt;
      final content = Content.text(
          "Here are some keywords related to your query: $keywords.\n\n"
          "Please provide a comprehensive and informative response to the following query: $message");

      final response = await chat.sendMessage(content);
      // print(response.text);
      return response.text;
    } catch (e) {
      if (e == "The model is overloaded. Please try again later.") {
        BuildContext;
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("The model is overloaded. Please try again later."),
            backgroundColor: Colors.grey,
          ),
        );
      }
      print("Gemini Error: $e");
    }
  }
}
