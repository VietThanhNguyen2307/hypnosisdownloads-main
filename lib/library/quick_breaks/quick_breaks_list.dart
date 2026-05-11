import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hypnosis_downloads/app/home/routes/listen_routes.dart';
import 'package:hypnosis_downloads/library/data/model/product_pack.dart';
import 'package:hypnosis_downloads/products/audios/download/data/model/downloadable.dart';
import 'package:hypnosis_downloads/library/data/model/product.dart';
import 'package:hypnosis_downloads/library/data/model/product_type.dart';

class QuickBreaksList extends StatelessWidget {
  QuickBreaksList({super.key});

  static const String _baseUrl =
      'https://www.hypnosisdownloads.com/free/Quick-Break-';

  final List<AudioItem> audioItems = [
    AudioItem(
        title: 'Be Peaceful',
        url: '${_baseUrl}Be-Peaceful.mp3',
        duration: '6:53'),
    AudioItem(
        title: 'Ease Stress',
        url: '${_baseUrl}Ease-Stress.mp3',
        duration: '6:57'),
    AudioItem(
        title: 'Feel Creative',
        url: '${_baseUrl}Feel-Creative.mp3',
        duration: '7:40'),
    AudioItem(
        title: 'Feel Energized',
        url: '${_baseUrl}Feel-Energized.mp3',
        duration: '8:29'),
    AudioItem(
        title: 'Feel Happy',
        url: '${_baseUrl}Feel-Happy.mp3',
        duration: '7:22'),
    AudioItem(
        title: 'Feel Playful',
        url: '${_baseUrl}Feel-Playful.mp3',
        duration: '6:44'),
    AudioItem(
        title: 'Recharge Your Brain',
        url: '${_baseUrl}Recharge-Your-Brain.mp3',
        duration: '5:50'),
    AudioItem(
        title: 'Refocus', url: '${_baseUrl}Refocus.mp3', duration: '7:45'),
    AudioItem(
        title: 'Release Worries',
        url: '${_baseUrl}Release-Worries.mp3',
        duration: '7:17'),
  ];

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: audioItems.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () {
                final product = Product(
                  audioItems[index].url,
                  audioItems[index].title,
                  audioItems[index].url,
                  audioItems[index].title,
                  now,
                  DownloadProductType.audio,
                  null,
                );

                final downloadable = Downloadable(
                  item: product,
                  onlineUrl: audioItems[index].url,
                  name: audioItems[index].title,
                );

                final productPack = ProductPack(
                  'Quick Breaks',
                  'Quick Breaks',
                  now,
                  audioItems
                      .map((item) => Product(
                            item.url,
                            item.title,
                            item.url,
                            item.title,
                            now,
                            DownloadProductType.audio,
                            null,
                          ))
                      .toList(),
                  DownloadProductType.audio,
                );

                pushPlayerPage(
                  context,
                  DownloadProductType.audio,
                  downloadable,
                  productPack,
                  null,
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.asset(
                        'assets/images/quick_breaks.png',
                        width: 88,
                        height: 64,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            audioItems[index].title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            '${audioItems[index].duration} minutes',
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: SvgPicture.asset(
                        'assets/icons/play_outlined.svg',
                        width: 36,
                        height: 36,
                        fit: BoxFit.none,
                      ),
                      padding: const EdgeInsets.all(3),
                      onPressed: null,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class AudioItem {
  final String title;
  final String url;
  final String duration;

  AudioItem({required this.title, required this.url, required this.duration});
}
