import '../../domain/entities/friend.dart';

class MockFriendsData {
  static List<Friend> getMockFriends() {
    return [
      const Friend(
        id: '1',
        name: 'Vu Dinh Dang',
        avatarUrl: 'https://i.pravatar.cc/150?img=12',
        isOnline: true,
        lastActiveTime: 'Đang hoạt động',
      ),
      const Friend(
        id: '2',
        name: 'Nguyen Trong Chien',
        avatarUrl: 'https://i.pravatar.cc/150?img=33',
        isOnline: false,
        lastActiveTime: 'Hoạt động 3s giờ trước',
      ),
      const Friend(
        id: '3',
        name: 'Vu Nhat Ming',
        avatarUrl: 'https://i.pravatar.cc/150?img=56',
        isOnline: false,
        lastActiveTime: 'Hoạt động 3s giờ trước',
      ),
      const Friend(
        id: '4',
        name: 'Vu Tuan Hiep',
        avatarUrl: 'https://i.pravatar.cc/150?img=68',
        isOnline: false,
        lastActiveTime: 'Hoạt động 3s giờ trước',
      ),
      const Friend(
        id: '5',
        name: 'Tran Ba Dat',
        avatarUrl: 'https://i.pravatar.cc/150?img=14',
        isOnline: false,
        lastActiveTime: 'Hoạt động 3s giờ trước',
      ),
    ];
  }
}
