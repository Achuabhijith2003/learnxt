import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:learnxt/consts.dart';
// import 'package:pdf_text/pdf_text.dart';

class DataEmbedded {
  // ignore: non_constant_identifier_names
  Generate_dataEmbedded(String text) async {
    final model =
        GenerativeModel(model: 'text-embedding-004', apiKey: GEMINI_API_KEY);
    final content = Content.text(text);
    final result = await model.embedContent(content);
    print(result.embedding.values);
  }

  // ignore: non_constant_identifier_names
  Generate_promtEmbedded(String text) async {
    final model =
        GenerativeModel(model: 'text-embedding-004', apiKey: GEMINI_API_KEY);
    final content = Content.text(text);
    final result = await model.embedContent(content);
    print(result.embedding.values);
  }

  pdfextract(){

  }
}
