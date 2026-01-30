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
        isOnline: true,
        lastActiveTime: 'Đang hoạt động',
      ),
      const Friend(
        id: '3',
        name: 'Vu Nhat Ming',
        avatarUrl: 'https://i.pravatar.cc/150?img=56',
        isOnline: true,
        lastActiveTime: 'Đang hoạt động',
      ),
      const Friend(
        id: '4',
        name: 'Vu Tuan Hiep',
        avatarUrl: 'https://i.pravatar.cc/150?img=68',
        isOnline: true,
        lastActiveTime: 'Đang hoạt động',
      ),
      const Friend(
        id: '5',
        name: 'Tran Ba Dat',
        avatarUrl: 'https://i.pravatar.cc/150?img=14',
        isOnline: false,
        lastActiveTime: 'Hoạt động 3 giờ trước',
      ),
      const Friend(
        id: '6',
        name: 'Lai Duc Dung',
        avatarUrl: 'https://i.pravatar.cc/150?img=15',
        isOnline: false,
        lastActiveTime: 'Hoạt động 1 ngày trước',
      ),
      const Friend(
        id: '7',
        name: 'Pham Minh Quan',
        avatarUrl: 'https://i.pravatar.cc/150?img=17',
        isOnline: false,
        lastActiveTime: 'Hoạt động 2 giờ trước',
      ),
      const Friend(
        id: '8',
        name: 'Le Hoang Nam',
        avatarUrl: 'https://i.pravatar.cc/150?img=18',
        isOnline: true,
        lastActiveTime: 'Đang hoạt động',
      ),
      const Friend(
        id: '9',
        name: 'Tran Thi Lan',
        avatarUrl: 'https://i.pravatar.cc/150?img=20',
        isOnline: false,
        lastActiveTime: 'Hoạt động 5 giờ trước',
      ),
      const Friend(
        id: '10',
        name: 'Nguyen Van A',
        avatarUrl: 'https://i.pravatar.cc/150?img=22',
        isOnline: true,
        lastActiveTime: 'Đang hoạt động',
      ),
      const Friend(
        id: '11',
        name: 'Do Minh Duc',
        avatarUrl: 'https://i.pravatar.cc/150?img=25',
        isOnline: false,
        lastActiveTime: 'Hoạt động 1 giờ trước',
      ),
      const Friend(
        id: '12',
        name: 'Bui Thi Hong',
        avatarUrl: 'https://i.pravatar.cc/150?img=27',
        isOnline: false,
        lastActiveTime: 'Hoạt động 4 giờ trước',
      ),
      const Friend(
        id: '13',
        name: 'Hoang Van Tuan',
        avatarUrl: 'https://i.pravatar.cc/150?img=30',
        isOnline: true,
        lastActiveTime: 'Đang hoạt động',
      ),
      const Friend(
        id: '14',
        name: 'Phan Thi Mai',
        avatarUrl: 'https://i.pravatar.cc/150?img=32',
        isOnline: false,
        lastActiveTime: 'Hoạt động 6 giờ trước',
      ),
      const Friend(
        id: '15',
        name: 'Vo Quang Huy',
        avatarUrl: 'https://i.pravatar.cc/150?img=35',
        isOnline: false,
        lastActiveTime: 'Hoạt động 2 ngày trước',
      ),
      const Friend(
        id: '16',
        name: 'Dinh Thi Thao',
        avatarUrl: 'https://i.pravatar.cc/150?img=38',
        isOnline: true,
        lastActiveTime: 'Đang hoạt động',
      ),
      const Friend(
        id: '17',
        name: 'Ly Van Phong',
        avatarUrl: 'https://i.pravatar.cc/150?img=40',
        isOnline: false,
        lastActiveTime: 'Hoạt động 8 giờ trước',
      ),
      const Friend(
        id: '18',
        name: 'Mac Thi Huyen',
        avatarUrl: 'https://i.pravatar.cc/150?img=43',
        isOnline: false,
        lastActiveTime: 'Hoạt động 12 giờ trước',
      ),
      const Friend(
        id: '19',
        name: 'Ngo Van Khanh',
        avatarUrl: 'https://i.pravatar.cc/150?img=45',
        isOnline: true,
        lastActiveTime: 'Đang hoạt động',
      ),
      const Friend(
        id: '20',
        name: 'Truong Thi Linh',
        avatarUrl: 'https://i.pravatar.cc/150?img=48',
        isOnline: false,
        lastActiveTime: 'Hoạt động 1 ngày trước',
      ),
    ];
  }

  static int getFriendsCount() {
    return getMockFriends().length;
  }
}
