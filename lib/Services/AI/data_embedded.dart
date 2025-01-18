import 'dart:io';
import 'dart:math';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:learnxt/Services/Hive/chat.dart';
import 'package:learnxt/key.dart';
import 'package:flutter_pdf_text/flutter_pdf_text.dart';

class DataEmbedded extends Chatputandget {
  String? parentdocid;

  Future<void> pdfextract(File pdfFile) async {
    try {
      final pdfDoc = await PDFDoc.fromFile(pdfFile);

      // Limit the number of concurrent embedding requests
      const int maxConcurrentRequests = 3;
      final List<Future<void>> processingTasks = [];
      final semaphore = StreamController<int>.broadcast();

      for (int i = 1; i <= pdfDoc.length; i++) {
        final page = pdfDoc.pageAt(i);
        final pageText = await page.text;

        // Split text into smaller chunks
        final chunks = splitTextIntoChunks(pageText, 100);

        // Process each chunk with limited concurrency
        for (final chunk in chunks) {
          if (processingTasks.length >= maxConcurrentRequests) {
            // Wait for any task to complete before starting a new one
            await Future.any(processingTasks);
          }
          processingTasks.add(processChunk(chunk));
        }

        // Dispose of the page after processing
        // page.dispose();
      }

      // Wait for all tasks to complete
      await Future.wait(processingTasks);
      semaphore.close();
    } catch (e) {
      print('Error processing PDF: $e');
      rethrow;
    }
  }

  Future<void> processChunk(String chunk) async {
    try {
      final embedding = await Generate_dataEmbedded(chunk);
      if (embedding.isNotEmpty) {
        await storeEmbeddedData(embedding, chunk);
      }
    } catch (e) {
      print('Error processing chunk: $e');
    }
  }

  // ignore: non_constant_identifier_names
  Future<List<double>> Generate_dataEmbedded(String text) async {
    try {
      final model = GenerativeModel(
        model: 'text-embedding-004',
        apiKey: GEMINI_API_KEY,
      );
      final content = Content.text(text);
      final result = await model.embedContent(content);
      return result.embedding.values;
    } catch (e) {
      print('Error generating embedding: $e');
      return [];
    }
  }

  Future<void> storeEmbeddedData(List<double> embeddings, String text) async {
    try {
      if (parentdocid == null || parentdocid!.isEmpty) {
        throw ArgumentError('parentdocid cannot be empty');
      }

      final parentDocRef =
          FirebaseFirestore.instance.collection('bot').doc(parentdocid);
      final subcollectionRef = parentDocRef.collection('dataEmbedded');
      await subcollectionRef.add({
        'pdf_text': text,
        'embeddings': FieldValue.arrayUnion(embeddings),
      });
    } catch (e) {
      print('Error storing data: $e');
    }
  }

  List<String> splitTextIntoChunks(String text, int chunkSize) {
    final chunks = <String>[];
    final words = text.split(' ');

    int start = 0;
    while (start < words.length) {
      // int end = chunkSize;
      int end = min(start + chunkSize, words.length);
      chunks.add(words.sublist(start, end).join(' '));
      start = end;
    }

    return chunks;
  }

  void getDocId(String parentdocid) {
    this.parentdocid = parentdocid;
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

// Generate Ans
  Future<String> searchAndAnswer(String query, String parentdocid) async {
    try {
      final queryEmbedding = await Generate_promptEmbedded(query);

      final subcollectionRef = FirebaseFirestore.instance
          .collection('bot')
          .doc(parentdocid)
          .collection('dataEmbedded');

      final querySnapshot =
          await subcollectionRef.orderBy('embeddings', descending: true).get();

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

// Find the index of the top result
      int topResultIndex = 0; // Default to the first result
      final topResult = rankedResults[topResultIndex];
      final topDocId = topResult['docId'] as String;

// Get the previous and next document IDs if available
      String? previousDocId;
      String? nextDocId;

      // if (topResultIndex > 0) {
      previousDocId = rankedResults[topResultIndex + 2]['docId'] as String?;
      // }

      if (topResultIndex < rankedResults.length - 1) {
        nextDocId = rankedResults[topResultIndex + 1]['docId'] as String?;
      }

      final topDoc = await subcollectionRef.doc(topDocId).get();
      final prevdoc = await subcollectionRef.doc(previousDocId).get();
      final nextdoc = await subcollectionRef.doc(nextDocId).get();

      if (!topDoc.exists) {
        return "Top document not found.";
      }
      final originalTextbefore = prevdoc.data()?['pdf_text'] as String?;
      final originalTextnow = topDoc.data()?['pdf_text'] as String?;
      final originalTextafter = nextdoc.data()?['pdf_text'] as String?;
      final originalText =
          "$originalTextbefore $originalTextnow $originalTextafter";
      print("Searched anw from firebase :$originalText");
      if (originalText == "") {
        return "No text found in the document.";
      }

// Log or return the surrounding document IDs for additional context
      print('Previous Document ID: $previousDocId');
      print('Next Document ID: $nextDocId');

// You can include this information in the response if needed
      // return "Top Document Text: $originalText\nPrevious Document ID: $previousDocId\nNext Document ID: $nextDocId";
      return originalText;

      // final originalText = topDoc.data()?['pdf_text'] as String?;
      // if (originalText == null) {
      //   return "No text found in the document.";
      // }

      // // final generatedAnswer = generateAnswer(originalText);

      // return originalText;
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
}
