import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NewsCardSkeleton extends StatelessWidget {
  const NewsCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;
    
    return Container(
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        child: Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section Placeholder
              Expanded(
                flex: 45,
                child: Container(
                  width: double.infinity,
                  color: Colors.white, // Shimmer will paint over this
                ),
              ),

              // Content Section Placeholder
              Expanded(
                flex: 55,
                child: Container(
                  color: Theme.of(context).cardColor,
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Publisher Bar
                      Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: 120,
                            height: 14,
                            color: Colors.white,
                          ),
                          const Spacer(),
                          Container(
                            width: 22,
                            height: 22,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 22,
                            height: 22,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Title lines
                      Container(
                        width: double.infinity,
                        height: 22,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        height: 22,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 22,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 16),

                      // Description lines
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(width: double.infinity, height: 14, color: Colors.white),
                            const SizedBox(height: 6),
                            Container(width: double.infinity, height: 14, color: Colors.white),
                            const SizedBox(height: 6),
                            Container(width: double.infinity, height: 14, color: Colors.white),
                            const SizedBox(height: 6),
                            Container(width: MediaQuery.of(context).size.width * 0.4, height: 14, color: Colors.white),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 16),

                      // Footer
                      Container(
                        width: 100,
                        height: 12,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
