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
      if (user != null && ai != null) {
        final userpart = TextPart(user);
        final aipart = TextPart(ai);
        userparts.add(userpart);
        aiparts.add(aipart);
        model.startChat(history: [
          Content.multi([
            TextPart(userparts.toString()),
          ]),
          Content("User", userparts),
          Content("model", aiparts),
        ]);
        var message = promt;
        // final content = Content.text(
        //     "If the input indicates a friendly conversation, respond as a teacher with an engaging and conversational tone. If it is a question, analyze the provided keywords: $keywords and answer the question using only the context provided by these keywords, maintaining the perspective of a teacher. Input message: $message.");

        final prompt =
            "If the input indicates a friendly conversation or start hi or hey like not use keywords give a friendly conversation , respond as a teacher with an engaging and conversational tone. If it is a question, analyze the provided keywords: $keywords and answer the question using only the context provided by these keywords, maintaining the perspective of a teacher and provide answer with simple way to understand like an bot . Input message: $message.";
        final chats = model.startChat();
        final response = await chats.sendMessage(Content.text(prompt));

        return response.text;
      } else {
        model.startChat(history: []);
        var message = promt;
        // final content = Content.text(
        //     "If the input indicates a friendly conversation, respond as a teacher with an engaging and conversational tone. If it is a question, analyze the provided keywords: $keywords and answer the question using only the context provided by these keywords, maintaining the perspective of a teacher. Input message: $message.");

        final prompt =
            "If the input indicates a friendly conversation or start hi or hey like not use keywords give a friendly conversation , respond with an engaging and conversational tone. If it is a question, analyze the provided sentence: $keywords and answer the question using only the context provided by these keywords, provide answer with simple way to understand for students. Input message: $message.";
        final response = await model.generateContent([Content.text(prompt)]);
        return response.text;
      }
    } catch (e) {
      print("Gemini Error: $e");
    }
  }
}
