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
  Generate_promptEmbedded(String text) async {
    final model =
        GenerativeModel(model: 'text-embedding-004', apiKey: GEMINI_API_KEY);
    final content = Content.text(text);
    final result = await model.embedContent(content);
    print(result.embedding.values);
    return result.embedding.values;
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
  Future<String> searchAndAnswer(String query, String parentdocid) async {
    try {
      final queryEmbedding = await Generate_promptEmbedded(query);

      final subcollectionRef = FirebaseFirestore.instance
          .collection('Bot')
          .doc(parentdocid)
          .collection('dataEmbedded');

      final querySnapshot = await subcollectionRef
          .orderBy('embeddings', descending: true)
          .limit(10)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return "No results found.";
      }

      final rankedResults = querySnapshot.docs.map((doc) {
        final embeddingList = doc.data()['embeddings'] as List<dynamic>?;

        if (embeddingList == null) {
          throw Exception('Embedding list is null');
        }

        // Safely convert List<dynamic> to List<double>
        final embedding = embeddingList.map((item) {
          if (item is num) {
            return item.toDouble();
          } else {
            throw Exception('Invalid type in embedding list');
          }
        }).toList();

        final similarity = calculateCosineSimilarity(queryEmbedding, embedding);
        return {'similarity': similarity, 'docId': doc.id};
      }).toList();

      rankedResults.sort((a, b) {
        final similarityA = a['similarity'] as double?;
        final similarityB = b['similarity'] as double?;
        return (similarityB ?? 0).compareTo(similarityA ?? 0);
      });

      if (rankedResults.isEmpty) {
        return "No results after ranking.";
      }

      final topResult = rankedResults.first;
      final topDocId = topResult['docId'] as String;

      final topDoc = await subcollectionRef.doc(topDocId).get();

      if (!topDoc.exists) {
        return "Top document not found.";
      }

      final originalText = topDoc.data()?['pdf_text'] as String?;
      if (originalText == null) {
        return "No text found in the document.";
      }

      // final generatedAnswer = generateAnswer(originalText);

      return originalText;
    } catch (e) {
      print('Error in searchAndAnswer: $e');
      return "An error occurred.";
    }
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
