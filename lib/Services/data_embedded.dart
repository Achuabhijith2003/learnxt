import 'dart:io';
import 'dart:math';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:learnxt/key.dart';

import 'package:pdf_text/pdf_text.dart';

class DataEmbedded {
  // ignore: prefer_typing_uninitialized_variables
  String? parentdocid;
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
      storeEmbeddedData(result.embedding.values, text);
    }

    return embeddings;
  }

  // ignore: non_constant_identifier_names
  Future<void> storeEmbeddedData(embeddings, String text) async {
    try {
      if (parentdocid!.isEmpty) {
        throw ArgumentError('parentdocid cannot be empty');
      }

      final parentDocRef =
          FirebaseFirestore.instance.collection('Bot').doc(parentdocid);
      final subcollectionRef = parentDocRef.collection('dataEmbedded');

      await subcollectionRef.add({
        'embeddings': embeddings,
        'pdf_text': text,
      });
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

// Generate Ans
  Future<String> searchAndAnswer(String query) async {
    final queryEmbedding =
        Generate_promtEmbedded(query); // Generate embedding for the query

    // Retrieve embeddings from Firestore (optimized query for performance)
    final querySnapshot = await FirebaseFirestore.instance
        .collection('embeddings')
        .orderBy('embedding',
            descending: true) // Assuming an index on embedding field
        .limit(10) // Adjust limit as needed
        .get();

    // Calculate similarity scores and rank results
    final rankedResults = querySnapshot.docs.map((doc) {
      final embedding = doc.data()['embeddings'] as List<double>;
      final similarity =
          calculateCosineSimilarity(queryEmbedding[0], embedding);
      return {'similarity': similarity, 'docId': doc.id};
    }).toList();
    rankedResults.sort((a, b) {
      final similarityA = a['similarity'] as double?;
      final similarityB = b['similarity'] as double?;
      return (similarityB ?? 0).compareTo(similarityA ?? 0);
    });

    // Retrieve original text based on top ranked results
    // ... (implement logic to retrieve original text based on docId)

    // Generate an answer based on the retrieved text
    // ... (use a language model or other techniques to generate an answer)

    return "generatedAnswer";
  }

  double calculateCosineSimilarity(List<double> vector1, List<double> vector2) {
    double dotProduct = 0.0;
    double magnitude1 = 0.0;
    double magnitude2 = 0.0;

    for (int i = 0; i < vector1.length; i++) {
      dotProduct += vector1[i] * vector2[i];
      magnitude1 += vector1[i] * vector1[i];
      magnitude2 += vector2[i] * vector2[i];
    }

    final magnitude = sqrt(magnitude1 * magnitude2);
    if (magnitude == 0) return 0.0;

    return dotProduct / magnitude;
  }

  Future<String> generateAnswerWithGemini(
      String originalText, String query) async {
    // Replace with your Gemini API endpoint and credentials
    const geminiApiUrl = 'https://gemini.example.com/generate';
    const apiKey = GEMINI_API_KEY;

    // Prepare the query for Gemini
    final geminiPrompt =
        'Generate an answer based on the following text: $originalText, given the query: $query';

    // Make the API call
    final response = await http.post(
      Uri.parse(geminiApiUrl),
      headers: {'Authorization': 'Bearer $apiKey'},
      body: jsonEncode({'prompt': geminiPrompt}),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final generatedAnswer = jsonResponse['answer'];
      return generatedAnswer;
    } else {
      throw Exception('Gemini API Error: ${response.statusCode}');
    }
  }
}
