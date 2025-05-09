import 'dart:io';
import 'dart:math';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:learnxt/Services/Hive/chat.dart'; // Ensure this import is correct and necessary.  It seems this class isn't used.
import 'package:learnxt/key.dart'; // Make sure this key is secure.  Do not commit API keys to public repositories.
import 'package:flutter_pdf_text/flutter_pdf_text.dart';

class DataEmbedded extends Chatputandget {
  //  Inheritance from Chatputandget is not used.  Consider removing it.
  String? parentdocid;

  Future<void> pdfextract(File pdfFile) async {
    try {
      final pdfDoc = await PDFDoc.fromFile(pdfFile);

      // Limit the number of concurrent embedding requests.  Consider making this configurable.
      const int maxConcurrentRequests = 3;
      final List<Future<void>> processingTasks = [];
      // final semaphore = StreamController<int>.broadcast(); // Not used, so remove.

      for (int i = 1; i <= pdfDoc.length; i++) {
        final page = pdfDoc.pageAt(i);
        final pageText = await page.text;

        // Split text into smaller chunks
        final chunks = splitTextIntoChunks(pageText, 100);

        // Process each chunk with limited concurrency
        for (final chunk in chunks) {
          if (processingTasks.length >= maxConcurrentRequests) {
            // Wait for any task to complete before starting a new one.  This ensures the limit.
            await Future.any(processingTasks);
          }
          processingTasks.add(processChunk(chunk));
        }

        // Dispose of the page after processing.  Good practice to free resources.
        // page.dispose();
      }

      // Wait for all tasks to complete
      await Future.wait(processingTasks);
      // semaphore.close(); // Not used, remove.
    } catch (e) {
      print('Error processing PDF: $e');
      rethrow; // Good practice: rethrow the error to allow for higher-level handling.
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
      // Consider more robust error handling here.  Perhaps a retry mechanism or a way to log failed chunks.
    }
  }

  // ignore: non_constant_identifier_names  -  Follow Dart naming conventions:  Use lowerCamelCase for function names.
  Future<List<double>> Generate_dataEmbedded(String text) async {
    try {
      final model = GenerativeModel(
        model:
            'text-embedding-004', // Consider making the model name configurable.
        apiKey:
            GEMINI_API_KEY, //  IMPORTANT:  Move this to a secure configuration.
      );
      final content = Content.text(text);
      final result = await model.embedContent(content);
      return result.embedding.values;
    } catch (e) {
      print('Error generating embedding: $e');
      return []; // Handle error, return empty list.  Caller should check for empty list.
    }
  }

  Future<void> storeEmbeddedData(List<double> embeddings, String text) async {
    try {
      if (parentdocid == null || parentdocid!.isEmpty) {
        throw ArgumentError(
            'parentdocid cannot be empty'); // Use more specific exceptions when appropriate.
      }

      final parentDocRef =
          FirebaseFirestore.instance.collection('bot').doc(parentdocid);
      final subcollectionRef = parentDocRef.collection('dataEmbedded');
      await subcollectionRef.add({
        'pdf_text': text,
        'embeddings': FieldValue.arrayUnion(
            embeddings), //  Using arrayUnion is correct to prevent duplicates
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
      final int end = min(start + chunkSize, words.length);
      chunks.add(words.sublist(start, end).join(' '));
      start = end;
    }
    return chunks;
  }

  void getDocId(String parentdocid) {
    this.parentdocid = parentdocid;
  }

  // ignore: non_constant_identifier_names  -  Follow Dart naming conventions.
//   Generate_promptEmbedded(String text) async {
//     final model = GenerativeModel(
//         model: 'gemini-embedding-exp-03-07', apiKey: GEMINI_API_KEY); //  Move API key.
//     final content = Content.text(text);
//     final result = await model.embedContent(content);
//     print(result.embedding.values);
//     return result.embedding.values;
//   }
Future<String> searchAndAnswer(String query, String parentdocid) async {
  try {
    // Step 1: Embed the query
    final queryEmbedding = await Generate_dataEmbedded(query);

    // Step 2: Retrieve all documents in the collection
    final subcollectionRef = FirebaseFirestore.instance
        .collection('bot')
        .doc(parentdocid)
        .collection('dataEmbedded');

    final querySnapshot = await subcollectionRef.get();

    if (querySnapshot.docs.isEmpty) {
      return "No results found.";
    }

    // Step 3: Compare embeddings and rank documents
    final rankedResults = querySnapshot.docs.map((doc) {
      final embeddingList = doc.data()['embeddings'] as List<dynamic>?;

      if (embeddingList == null) {
        throw Exception('Embedding list is null');
      }

      // Convert List<dynamic> to List<double>
      final embedding = embeddingList.map((item) {
        if (item is num) {
          return item.toDouble();
        } else {
          throw Exception('Invalid type in embedding list');
        }
      }).toList();

      // Ensure both embeddings are the same length
      final trimmedQueryEmbedding = trimToMinLength(queryEmbedding, embedding);
      final trimmedDocEmbedding = trimToMinLength(embedding, queryEmbedding);

      // Calculate cosine similarity
      final similarity = calculateCosineSimilarity(
        trimmedQueryEmbedding,
        trimmedDocEmbedding,
      );

      return {
        'similarity': similarity,
        'docId': doc.id,
        'text': doc.data()['pdf_text']
      };
    }).toList();

    // Sort documents by similarity in descending order
    rankedResults.sort((a, b) {
      final similarityA = a['similarity'] as double?;
      final similarityB = b['similarity'] as double?;
      return (similarityB ?? 0).compareTo(similarityA ?? 0);
    });

    // Step 4: Take the top 6 documents
    final topResults = rankedResults.take(6).toList();

    // Step 5: Concatenate the text from the top documents
    final concatenatedText = topResults.map((result) {
      return result['text'] as String? ?? '';
    }).join(' ');

    // Return the concatenated text
    return concatenatedText.trim().isNotEmpty
        ? concatenatedText
        : "No relevant text found.";
  } catch (e) {
    print('Error in searchAndAnswer: $e');
    return "An error occurred.";
  }
}

// Helper method to trim vectors to the same length
  List<double> trimToMinLength(List<double> a, List<double> b) {
    final minLength = a.length < b.length ? a.length : b.length;
    return a.sublist(0, minLength);
  }

  double calculateCosineSimilarity(List<double> vector1, List<double> vector2) {
    double dotProduct = 0.0;
    double magnitude1 = 0.0;
    double magnitude2 = 0.0;

    if (vector1.length != vector2.length) {
      throw ArgumentError(
          "Vectors must have the same length to calculate cosine similarity.");
    }

    for (int i = 0; i < vector1.length; i++) {
      dotProduct += vector1[i] * vector2[i];
      magnitude1 += vector1[i] * vector1[i];
      magnitude2 += vector2[i] * vector2[i];
    }

    final magnitude = sqrt(magnitude1 * magnitude2);
    if (magnitude == 0) return 0.0; // Handle zero magnitude case.

    return dotProduct / magnitude;
  }
}
