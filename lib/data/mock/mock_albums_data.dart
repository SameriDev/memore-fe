import '../../domain/entities/album.dart';
import '../../domain/entities/story.dart';

class MockAlbumsData {
  static List<Story> getMockStories() {
    return [
      Story(
        id: '0',
        userId: 'current_user',
        userAvatar: '',
        userName: 'Add Story',
        isAddButton: true,
      ),
      Story(
        id: '1',
        userId: '1',
        userAvatar: '',
        userName: 'User 1',
        images: ['image1', 'image2', 'image3'],
      ),
      Story(
        id: '2',
        userId: '2',
        userAvatar: '',
        userName: 'User 2',
        images: ['image1', 'image2', 'image3'],
      ),
      Story(
        id: '3',
        userId: '3',
        userAvatar: '',
        userName: 'User 3',
        images: ['image1', 'image2', 'image3'],
      ),
    ];
  }

  static List<Album> getMockAlbums() {
    return [
      Album(
        id: '1',
        name: 'Just cat',
        coverImageUrl:
            'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=400',
        filesCount: 36,
        timeAgo: '2 days',
        participantAvatars: [],
        additionalParticipants: 9,
        isFavorite: true,
      ),
      Album(
        id: '2',
        name: 'Van la tro',
        coverImageUrl:
            'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?w=400',
        filesCount: 36,
        timeAgo: '2 days',
        participantAvatars: [],
        additionalParticipants: 8,
        isFavorite: false,
      ),
      Album(
        id: '3',
        name: 'Family Time',
        coverImageUrl:
            'https://images.unsplash.com/photo-1511632765486-a01980e01a18?w=400',
        filesCount: 24,
        timeAgo: '3 days',
        participantAvatars: [],
        additionalParticipants: 0,
        isFavorite: false,
      ),
      Album(
        id: '4',
        name: 'Doro',
        coverImageUrl:
            'https://images.unsplash.com/photo-1614730321146-b6fa6a46bcb4?w=400',
        filesCount: 36,
        timeAgo: '2 days',
        participantAvatars: [],
        additionalParticipants: 0,
        isFavorite: false,
      ),
    ];
  }
}
