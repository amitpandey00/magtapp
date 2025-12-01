import 'package:flutter/material.dart';

/// App Feature Model for FAB Menu
class AppFeature {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final String route;

  AppFeature({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.route,
  });

  static List<AppFeature> getAllFeatures() {
    return [
      AppFeature(
        id: 'smart_dictionary',
        name: 'Smart Dictionary',
        icon: Icons.book_outlined,
        color: Colors.blue,
        route: '/smart-dictionary',
      ),
      AppFeature(
        id: 'document_reader',
        name: 'Document Reader',
        icon: Icons.picture_as_pdf_outlined,
        color: Colors.red,
        route: '/documents',
      ),
      AppFeature(
        id: 'books',
        name: 'Books',
        icon: Icons.menu_book_outlined,
        color: Colors.teal,
        route: '/books',
      ),
      AppFeature(
        id: 'translation',
        name: 'Translation',
        icon: Icons.translate,
        color: Colors.green,
        route: '/translation',
      ),
      AppFeature(
        id: 'quiz',
        name: 'Quiz',
        icon: Icons.quiz_outlined,
        color: Colors.orange,
        route: '/quiz',
      ),
      AppFeature(
        id: 'games',
        name: 'Games',
        icon: Icons.sports_esports_outlined,
        color: Colors.purple,
        route: '/games',
      ),
      AppFeature(
        id: 'notes',
        name: 'Notes',
        icon: Icons.note_outlined,
        color: Colors.amber,
        route: '/notes',
      ),
      AppFeature(
        id: 'course',
        name: 'Course',
        icon: Icons.cast_for_education_outlined,
        color: Colors.indigo,
        route: '/course',
      ),
    ];
  }
}

