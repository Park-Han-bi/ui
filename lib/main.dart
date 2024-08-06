import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NeededScreen(),
    );
  }
}

class NeededScreen extends StatefulWidget {
  @override
  _NeededScreenState createState() => _NeededScreenState();
}

class _NeededScreenState extends State<NeededScreen> {
  int _currentIndex = 0;
  String _selectedRoom = '';
  String _selectedDate = '';
  List<String> _selectedTimes = [];
  bool _showAccountMenu = false;
  String _selectedOrderCategory = '커피';

  // 예시 데이터
  final List<Map<String, String>> _posts = List.generate(
    10,
    (index) => {
      'title': '제목 ${index + 1}',
      'content': '작성자 ${index + 1}',
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hansung Computer Engineering Community'),
        actions: [
          if (_currentIndex == 0 && !_showAccountMenu)
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                _showSearchDialog(context);
              },
            ),
          if (_currentIndex == 0 && !_showAccountMenu)
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                setState(() {
                  _showAccountMenu = true;
                });
              },
            ),
          if (_currentIndex == 0 && _showAccountMenu)
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                setState(() {
                  _showAccountMenu = false;
                });
              },
            ),
        ],
        backgroundColor: Colors.blue,
      ),
      body: _showAccountMenu ? _buildAccountMenu() : _buildBody(),
      bottomNavigationBar: _showAccountMenu
          ? null
          : BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.group),
                  label: 'Needed',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.local_cafe),
                  label: 'Order',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today),
                  label: 'Reservation',
                ),
              ],
              backgroundColor: Colors.blue,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white70,
            ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 1:
        return _buildOrderMenu();
      case 2:
        return _buildReservationForm();
      default:
        return _buildNeededList();
    }
  }

  Widget _buildNeededList() {
    return ListView.builder(
      itemCount: _posts.length,
      itemBuilder: (context, index) {
        final post = _posts[_posts.length - 1 - index];
        final int commentCount = index * 5;
        final DateTime now = DateTime.now();
        final DateTime postTime = now
            .subtract(Duration(minutes: (9 - _posts.length + 1 + index) * 2));
        final String formattedTime =
            '${postTime.hour.toString().padLeft(2, '0')}:${postTime.minute.toString().padLeft(2, '0')}';

        final String additionalText =
            '60자를 넘어가면 "..."으로 줄어들어야 하는 텍스트 칸인데 화면 비율 좁을 때만 되는 거 같음!';

        return GestureDetector(
          onTap: () {
            _showPostDetail(post);
          },
          child: Card(
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          post['title']!,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        formattedTime,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Text(post['content']!),
                  SizedBox(height: 8.0),
                  Text(
                    additionalText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.comment,
                        color: Colors.grey[600],
                        size: 20.0,
                      ),
                      SizedBox(width: 4.0),
                      Text(
                        '$commentCount',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showPostDetail(Map<String, String> post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetailScreen(post: post),
      ),
    );
  }

  Widget _buildAccountMenu() {
    return ListView(
      children: [
        ListTile(
          title: Text('내 계정'),
          onTap: () {},
        ),
        ListTile(
          title: Text('내가 쓴 글'),
          onTap: () {},
        ),
        ListTile(
          title: Text('내 예약'),
          onTap: () {},
        ),
        ListTile(
          title: Text('로그아웃'),
          onTap: () {},
        ),
        ListTile(
          title: Text('회원 탈퇴'),
          onTap: () {},
        ),
      ],
    );
  }

  void _showSearchDialog(BuildContext context) {
    final TextEditingController _searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Search'),
          content: TextField(
            controller: _searchController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: '검색어를 입력하세요.',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final String query = _searchController.text;
                if (query.isNotEmpty) {
                  Navigator.of(context).pop();
                  _showFilteredResults(context, query);
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Text('확인'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
          ],
        );
      },
    );
  }

  void _showFilteredResults(BuildContext context, String query) {
    final List<Map<String, String>> filteredPosts = _posts.where((post) {
      return post['title']!.contains(query) || post['content']!.contains(query);
    }).toList();

    // 역순으로 정렬
    filteredPosts
        .sort((a, b) => _posts.indexOf(b).compareTo(_posts.indexOf(a)));

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('검색 결과'),
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: ListView.builder(
              itemCount: filteredPosts.length,
              itemBuilder: (context, index) {
                final post = filteredPosts[index];
                final int commentCount = index * 5;
                final DateTime now = DateTime.now();
                final DateTime postTime = now.subtract(
                    Duration(minutes: (filteredPosts.length - index - 1) * 2));
                final String formattedTime =
                    '${postTime.hour.toString().padLeft(2, '0')}:${postTime.minute.toString().padLeft(2, '0')}';
                final String additionalText =
                    '60자를 넘어가면 "..."으로 줄어들어야 하는 텍스트 칸인데 화면 비율 좁을 때만 되는 거 같음!';

                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                post['title']!,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              formattedTime,
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Text(post['content']!),
                        SizedBox(height: 8.0),
                        Text(
                          additionalText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.comment,
                              color: Colors.grey[600],
                              size: 20.0,
                            ),
                            SizedBox(width: 4.0),
                            Text(
                              '$commentCount',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrderMenu() {
    return Column(
      children: [
        Container(
          color: Colors.brown[200],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildOrderCategoryButton('커피'),
              _buildOrderCategoryButton('에이드'),
              _buildOrderCategoryButton('티'),
              _buildOrderCategoryButton('디카페인'),
              _buildOrderCategoryButton('디저트'),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.all(8.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 2 / 3,
            ),
            itemCount: 16,
            itemBuilder: (context, index) {
              return Center(
                child: Container(
                  width: MediaQuery.of(context).size.width / 4.5,
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/ex.jpg',
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 8.0),
                        Text('아메리카노'),
                        SizedBox(height: 8.0),
                        Text('3000원'),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOrderCategoryButton(String category) {
    return TextButton(
      onPressed: () {
        setState(() {
          _selectedOrderCategory = category;
        });
      },
      style: TextButton.styleFrom(
        backgroundColor: _selectedOrderCategory == category
            ? Colors.brown
            : Colors.transparent,
        foregroundColor:
            _selectedOrderCategory == category ? Colors.white : Colors.black,
      ),
      child: Text(category),
    );
  }

  Widget _buildReservationForm() {
    final _nameController = TextEditingController();
    final _studentIdController = TextEditingController();
    final _phoneController = TextEditingController();
    final _emailController = TextEditingController();
    final _usersController = TextEditingController();
    final _totalController = TextEditingController();
    final _dateController = TextEditingController();
    final List<String> _rooms = [
      'IB101',
      'IB102',
      'IB103',
      'IB104',
      'IB105',
      'IB106',
      'IB107',
      'IB108'
    ];
    final List<String> _times = [
      '09:00',
      '10:00',
      '11:00',
      '12:00',
      '13:00',
      '14:00',
      '15:00',
      '16:00',
      '17:00',
      '18:00',
      '19:00',
      '20:00'
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: '신청자'),
          ),
          TextField(
            controller: _studentIdController,
            decoration: InputDecoration(labelText: '학번'),
          ),
          TextField(
            controller: _phoneController,
            decoration: InputDecoration(labelText: '전화번호'),
          ),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(labelText: '이메일'),
          ),
          TextField(
            controller: _usersController,
            decoration: InputDecoration(labelText: '전체 이용자 (성명/학번)'),
          ),
          TextField(
            controller: _totalController,
            decoration: InputDecoration(labelText: '총 인원 수'),
          ),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: '예약 공간 목록'),
            value: _selectedRoom.isNotEmpty ? _selectedRoom : null,
            items: _rooms.map((room) {
              return DropdownMenuItem<String>(
                value: room,
                child: Text(room),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedRoom = value!;
              });
            },
          ),
          TextField(
            controller: _dateController,
            decoration: InputDecoration(labelText: '예약 일자'),
            readOnly: true,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                setState(() {
                  _selectedDate = "${pickedDate.toLocal()}".split(' ')[0];
                  _dateController.text = _selectedDate;
                });
              }
            },
          ),
          Wrap(
            spacing: 8.0,
            children: _times.map((time) {
              final isSelected = _selectedTimes.contains(time);
              return FilterChip(
                label: Text(time),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      if (_selectedTimes.length < 3) {
                        _selectedTimes.add(time);
                      }
                    } else {
                      _selectedTimes.remove(time);
                    }
                  });
                },
              );
            }).toList(),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              _nameController.clear();
              _studentIdController.clear();
              _phoneController.clear();
              _emailController.clear();
              _usersController.clear();
              _totalController.clear();
              _dateController.clear();
              setState(() {
                _selectedRoom = '';
                _selectedDate = '';
                _selectedTimes.clear();
              });
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text('신청되었습니다.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('확인'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text('신청하기'),
          ),
        ],
      ),
    );
  }
}

class PostDetailScreen extends StatelessWidget {
  final Map<String, String> post;
  final List<Map<String, String>> comments = List.generate(
    5,
    (index) => {
      'author': '익명${index + 1}',
      'content': '안녕하세요.',
    },
  );

  PostDetailScreen({required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
              } else if (value == 'edit') {}
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Text('삭제하기'),
                ),
                PopupMenuItem<String>(
                  value: 'edit',
                  child: Text('수정하기'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post['title']!,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(post['content']!),
            SizedBox(height: 8.0),
            Text(
              '이것은 추가된 텍스트입니다. 이 텍스트는 60자를 넘어가면 "..."으로 줄어들어야 합니다.',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  return ListTile(
                    title: Text(comment['author']!),
                    subtitle: Text(comment['content']!),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'delete') {
                        } else if (value == 'report') {}
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem<String>(
                            value: 'delete',
                            child: Text('삭제하기'),
                          ),
                          PopupMenuItem<String>(
                            value: 'report',
                            child: Text('신고하기'),
                          ),
                        ];
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
