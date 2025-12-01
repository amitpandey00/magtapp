import 'package:flutter/material.dart';
import '../../../../core/models/language.dart';

class LanguageCard extends StatelessWidget {
  final Language language;
  final VoidCallback onTap;

  const LanguageCard({super.key, required this.language, required this.onTap});

  Color _getColor() {
    return Color(int.parse(language.colorHex.replaceFirst('#', '0xFF')));
  }

  IconData _getIcon() {
    switch (language.code) {
      case 'af':
        return Icons.account_balance;
      case 'ar':
        return Icons.mosque;
      case 'az':
        return Icons.mosque_outlined;
      case 'bs':
        return Icons.location_city;
      case 'ceb':
        return Icons.church;
      case 'fil':
        return Icons.church_outlined;
      case 'fr':
        return Icons.location_city;
      case 'de':
        return Icons.account_balance_outlined;
      case 'el':
        return Icons.temple_hindu;
      case 'ht':
        return Icons.home_work;
      case 'hi':
        return Icons.temple_buddhist;
      case 'bn':
        return Icons.account_balance;
      case 'te':
        return Icons.mosque;
      case 'mr':
        return Icons.account_balance;
      case 'ta':
        return Icons.temple_hindu;
      case 'gu':
        return Icons.account_balance;
      default:
        return Icons.language;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(color: _getColor(), borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  language.name,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(language.nativeName, style: const TextStyle(color: Colors.white, fontSize: 14)),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Icon(_getIcon(), color: Colors.white, size: 48),
            ),
          ],
        ),
      ),
    );
  }
}
