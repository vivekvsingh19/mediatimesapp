import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleWebViewScreen extends StatefulWidget {
  final String url;

  const ArticleWebViewScreen({super.key, required this.url});

  @override
  State<ArticleWebViewScreen> createState() => _ArticleWebViewScreenState();
}

class _ArticleWebViewScreenState extends State<ArticleWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) async {
            await _controller.runJavaScript('''
              var style = document.createElement('style');
              style.innerHTML = 'header, footer, nav, aside { display: none !important; } ' +
                                'div[class*="topBannerAd"], div[class*="skinAd"], div[class*="topBar"] { display: none !important; }';
              document.head.appendChild(style);
            ''');
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 48,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          Offstage(
            offstage: _isLoading,
            child: WebViewWidget(controller: _controller),
          ),
          if (_isLoading)
            const _ArticleSkeletonLoading(),
        ],
      ),
    );
  }
}

class _ArticleSkeletonLoading extends StatelessWidget {
  const _ArticleSkeletonLoading();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[850]! : Colors.grey[300]!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fake Title
          Container(width: double.infinity, height: 28, decoration: BoxDecoration(color: baseColor, borderRadius: BorderRadius.circular(8))),
          const SizedBox(height: 12),
          Container(width: MediaQuery.of(context).size.width * 0.6, height: 28, decoration: BoxDecoration(color: baseColor, borderRadius: BorderRadius.circular(8))),
          const SizedBox(height: 24),
          // Fake Image
          Container(width: double.infinity, height: 220, decoration: BoxDecoration(color: baseColor, borderRadius: BorderRadius.circular(16))),
          const SizedBox(height: 24),
          // Fake Content
          Container(width: double.infinity, height: 16, decoration: BoxDecoration(color: baseColor, borderRadius: BorderRadius.circular(4))),
          const SizedBox(height: 12),
          Container(width: double.infinity, height: 16, decoration: BoxDecoration(color: baseColor, borderRadius: BorderRadius.circular(4))),
          const SizedBox(height: 12),
          Container(width: MediaQuery.of(context).size.width * 0.8, height: 16, decoration: BoxDecoration(color: baseColor, borderRadius: BorderRadius.circular(4))),
          const SizedBox(height: 24),
          Container(width: double.infinity, height: 16, decoration: BoxDecoration(color: baseColor, borderRadius: BorderRadius.circular(4))),
          const SizedBox(height: 12),
          Container(width: MediaQuery.of(context).size.width * 0.9, height: 16, decoration: BoxDecoration(color: baseColor, borderRadius: BorderRadius.circular(4))),
        ],
      ),
    );
  }
}
