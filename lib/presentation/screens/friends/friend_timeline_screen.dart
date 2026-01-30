import 'package:flutter/material.dart';
import '../../../domain/entities/friend.dart';
import '../../../domain/entities/timeline_photo.dart';
import 'widgets/timeline_header.dart';
import 'widgets/timeline_photo_card.dart';
import 'widgets/timeline_background_decoration.dart';

class FriendTimelineScreen extends StatefulWidget {
  final Friend friend;

  const FriendTimelineScreen({super.key, required this.friend});

  @override
  State<FriendTimelineScreen> createState() => _FriendTimelineScreenState();
}

class _FriendTimelineScreenState extends State<FriendTimelineScreen> {
  // Mock data cho timeline photos
  late List<TimelinePhoto> timelinePhotos;

  @override
  void initState() {
    super.initState();
    _initMockData();
  }

  void _initMockData() {
    timelinePhotos = [
      const TimelinePhoto(
        id: '1',
        imageUrls: [
          'https://picsum.photos/400/600?random=1',
          'https://picsum.photos/400/600?random=11',
          'https://picsum.photos/400/600?random=12',
          'https://picsum.photos/400/600?random=13',
        ],
        time: '03:46',
        season: 'Summer',
        description: 'Em đến với anh',
      ),
      const TimelinePhoto(
        id: '2',
        imageUrls: [
          'https://picsum.photos/400/600?random=2',
          'https://picsum.photos/400/600?random=21',
          'https://picsum.photos/400/600?random=22',
        ],
        time: '05:30',
        season: 'Spring',
        description: 'Hoa nở rộ',
      ),
      const TimelinePhoto(
        id: '3',
        imageUrls: [
          'https://picsum.photos/400/600?random=3',
          'https://picsum.photos/400/600?random=31',
          'https://picsum.photos/400/600?random=32',
          'https://picsum.photos/400/600?random=33',
        ],
        time: '18:20',
        season: 'Autumn',
        description: 'Hoàng hôn tím',
      ),
      const TimelinePhoto(
        id: '4',
        imageUrls: [
          'https://picsum.photos/400/600?random=4',
          'https://picsum.photos/400/600?random=41',
          'https://picsum.photos/400/600?random=42',
        ],
        time: '09:15',
        season: 'Winter',
        description: 'Buổi sáng se lạnh',
      ),
    ];
  }

  void _onMenuTap() {
    // TODO: Show menu options
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.block),
                title: const Text('Chặn người dùng'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.report),
                title: const Text('Báo cáo'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: const Icon(Icons.chevron_left, color: Colors.black),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Background decorations
          const TimelineBackgroundDecoration(),
          // Vertical timeline line - Liền mạch chạy suốt
          Positioned(
            right: 10, // Gần edge màn hình
            top: 0,
            bottom: 0,
            child: Container(width: 2, color: const Color(0xFF464646)),
          ),
          // Main content
          SingleChildScrollView(
            child: Column(
              children: [
                // Header
                TimelineHeader(
                  name: widget.friend.name,
                  avatarUrl: widget.friend.avatarUrl,
                  isOnline: widget.friend.isOnline,
                  onMenuTap: _onMenuTap,
                ),
                const SizedBox(height: 20),
                // Timeline photos
                ...timelinePhotos.asMap().entries.map((entry) {
                  return TimelinePhotoCard(
                    photo: entry.value,
                    index: entry.key,
                  );
                }).toList(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
