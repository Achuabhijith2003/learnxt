import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:learnxt/Services/AI/data_embedded.dart';
import 'package:learnxt/key.dart';

class AI extends DataEmbedded {
  geminirespones(String promt) async {
    try {
      // final apiKey = Platform.environment["AIzaSyCx9CV9Ca3AT4kAjUd6BDyPGBreMv5_u_g"];
      // if (apiKey == null) {
      //   stderr.writeln(r'No $GEMINI_API_KEY environment variable');
      //   exit(1);
      // }

      final model = GenerativeModel(
        model: 'tunedModels/learnxt-bdmo4k9pyl9x',
        apiKey: GEMINI_API_KEY,
        generationConfig: GenerationConfig(
          temperature: 1,
          topK: 40,
          topP: 0.95,
          maxOutputTokens: 8192,
          responseMimeType: 'text/plain',
        ),
      );

      final chat = model.startChat(history: []);
      var message = promt;
      final content = Content.text(message);

      final response = await chat.sendMessage(content);
      // print(response.text);
      return response.text;
    } catch (e) {
      print("Gemini Error: $e");
    }
  }
}
