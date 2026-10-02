import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../providers/ads_provider.dart';
import 'dart:math';

class AdSlot extends ConsumerWidget {
  final String position;
  
  const AdSlot({super.key, required this.position});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adsState = ref.watch(adsProvider);
    return Container(
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(22),
          topRight: Radius.circular(22),
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
          topLeft: Radius.circular(22),
          topRight: Radius.circular(22),
        ),
        child: adsState.when(
          data: (ads) {
            final validAds = ads.where((ad) => 
                ad.position == 'mobile_feed' && 
                ad.mobileImageUrl != null && 
                ad.mobileImageUrl!.isNotEmpty
            ).toList();
            if (validAds.isEmpty) {
              return _buildPlaceholder(context);
            }
            
            // Pick a random ad
            final random = Random();
            final ad = validAds[random.nextInt(validAds.length)];
            
            return GestureDetector(
              onTap: () async {
                if (ad.destinationUrl != null) {
                  final uri = Uri.parse(ad.destinationUrl!);
                  try {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } catch (e) {
                    debugPrint('Could not launch $uri');
                  }
                }
              },
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: ad.mobileImageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => _buildPlaceholder(context),
                    errorWidget: (context, url, error) => _buildPlaceholder(context),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'ADVERTISEMENT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => _buildPlaceholder(context),
          error: (_, __) => _buildPlaceholder(context),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'ADVERTISEMENT',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
              letterSpacing: 3.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),
          Icon(
            Icons.ad_units,
            size: 120,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Container(
            height: 20,
            width: 250,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 16,
            width: 200,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}
