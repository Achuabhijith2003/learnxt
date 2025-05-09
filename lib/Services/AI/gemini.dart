import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:learnxt/Services/AI/data_embedded.dart';
import 'package:learnxt/key.dart';

class AI extends DataEmbedded {
  geminirespones(
      String promt, String docId, keywords, BuildContext context) async {
    try {
      final model = GenerativeModel(
        model: 'gemini-2.0-flash',
        apiKey: GEMINI_API_KEY,
        generationConfig: GenerationConfig(
          temperature: 1,
          topK: 40,
          topP: 0.95,
          maxOutputTokens: 8192,
          responseMimeType: 'text/plain',
        ),
      );

      model.startChat();

      // Refined prompt to ensure concise and note-friendly output
      final prompt = '''
 You are an AI Agent named LearnXT. Your primary task is to assist students in creating concise and accurate notes.
If the input indicates a friendly conversation, respond  with an engaging and conversational tone. 
If it is a question, analyze the provided paragrah: $keywords and  provide direct, well-structured, 
and actionable answers without any conversational phrases, introductions, or explanations.
Focus on delivering key points in a format that can be directly saved as notes. 
Avoid phrases like "Here's what I found" or"Based on the provided text." Instead, 
provide the information directly in bullet points or short sentences.
        Input message: $promt
        ''';

      final response = await model.generateContent([Content.text(prompt)]);
      return response.text;
    } catch (e) {
      print("Gemini Error: $e");
      return null;
    }
  }
}
