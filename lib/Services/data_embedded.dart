import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:learnxt/consts.dart';
import 'package:pdf_text/pdf_text.dart';

class DataEmbedded {
  // ignore: prefer_typing_uninitialized_variables
  String? parentdocid;
  String? pdfpath;
  // ignore: prefer_typing_uninitialized_variables, non_constant_identifier_names

  // ignore: non_constant_identifier_names
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
    storeEmbeddedData(embeddings);
    return embeddings;
  }

  // ignore: non_constant_identifier_names
  Future<void> storeEmbeddedData(List<List<double>> embeddings) async {
    try {
      if (parentdocid!.isEmpty) {
        throw ArgumentError('parentdocid cannot be empty');
      }

      final parentDocRef =
          FirebaseFirestore.instance.collection('Bot').doc(parentdocid);
      final subcollectionRef = parentDocRef.collection('dataEmbedded');

      for (final embedding in embeddings) {
        await subcollectionRef.add({
          'embeddings': embedding,
          'pdfPath': pdfpath,
        });
      }
    } catch (e) {
      print('Error storing data: $e');
    }
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

  Future<List<List<double>>> pdfextract(File pdfFile, String pdfpath) async {
    this.pdfpath = pdfpath;
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

  void getDocId(String parentdocid) {
    this.parentdocid = parentdocid;
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
