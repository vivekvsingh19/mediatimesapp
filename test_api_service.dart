import 'dart:io';
import 'package:mediatimesapp/services/api_service.dart';

void main() async {
  final api = ApiService();
  try {
    print("Fetching news...");
    final articles = await api.getNews();
    print("Success: \${articles.length} articles fetched.");
  } catch (e, stack) {
    print("Error: \$e");
    print(stack);
  }
}
