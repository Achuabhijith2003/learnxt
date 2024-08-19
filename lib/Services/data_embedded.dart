import 'dart:io';
import 'dart:math';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:learnxt/consts.dart';
import 'package:pdf_text/pdf_text.dart';

class DataEmbedded {
  Future<List<List<double>>> Generate_dataEmbedded(
      List<String> textList) async {
    final embeddings = <List<double>>[];
    for (final text in textList) {
      print(text);
      final model =
          GenerativeModel(model: 'text-embedding-004', apiKey: GEMINI_API_KEY);
      final content = Content.text(text);
      final result = await model.embedContent(content);
      embeddings.add(result.embedding.values);
      print(result.embedding.values);
    }
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
    try {
      final pdfDoc = await PDFDoc.fromFile(pdfFile);
      final StringBuffer textBuffer = StringBuffer();

      for (var i = 0; i < pdfDoc.length; i++) {
        final page = pdfDoc.pageAt(i + 1);
        String pageText = await page.text;

        // Debugging: Log the length of text from each page
        print('Page ${i + 1} text length: ${pageText.length}');

        textBuffer.write(pageText);
      }

      String text = textBuffer.toString();
      print('Total text length: ${text.length}');

      final chunks =
          splitTextIntoChunks(text, 100); // Adjust chunk size as needed
      return await Generate_dataEmbedded(chunks);
    } catch (e) {
      print('Error processing PDF: $e');
      rethrow; // Or handle the error as needed
    }
  }

  List<String> splitTextIntoChunks(String text, int chunkSize) {
    final chunks = <String>[];
    final words = text.split(' ');

    int start = 0;
    while (start < words.length) {
      int end = min(start + chunkSize, words.length);
      chunks.add(words.sublist(start, end).join(' '));
      start = end;
    }

    // Debugging: Log number of chunks and size of each chunk
    print('Number of chunks: ${chunks.length}');
    chunks.forEach((chunk) {
      print('Chunk length: ${chunk.length}');
    });

    return chunks;
  }
}
