import 'dart:io';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:learnxt/consts.dart';
import 'package:pdf_text/pdf_text.dart';

class DataEmbedded {
  Future<List<List<double>>> Generate_dataEmbedded(
      List<String> textList) async {
    final embeddings = <List<double>>[];
    for (final text in textList) {
      final model =
          GenerativeModel(model: 'text-embedding-004', apiKey: GEMINI_API_KEY);
      final content = Content.text(text);
      final result = await model.embedContent(content);
      embeddings.add(result.embedding.values);
    }
    print(embeddings);
    return embeddings;
  }

  // ignore: non_constant_identifier_names
  Generate_promtEmbedded(String text) async {
    final model =
        GenerativeModel(model: 'text-embedding-004', apiKey: GEMINI_API_KEY);
    final content = Content.text(text);
    final result = await model.embedContent(content);
    print(result.embedding.values);
  }

  //pdf to text
  // Future<String> pdfextract(File pdfFile) async {
  //   final pdfDoc = await PDFDoc.fromFile(pdfFile);
  //   List<String> text = (await pdfDoc.text) as List<String>;
  //   Generate_dataEmbedded(text);
  //   return "null";
  // }

  Future<List<List<double>>> pdfextract(File pdfFile) async {
    final pdfDoc = await PDFDoc.fromFile(pdfFile);
    final text = await pdfDoc.text;
    final textList = text.split('\n'); // Split text into a list of strings
    return Generate_dataEmbedded(textList);
  }
}
