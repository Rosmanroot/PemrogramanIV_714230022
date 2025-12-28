import 'package:flutter/material.dart';
import 'data_service.dart';
import 'user.dart';
import 'user_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DataService _dataService = DataService();
  final _nameCtl = TextEditingController();
  final _jobCtl = TextEditingController();
  String _result = '-';
  List<User> _users = [];
  UserCreate? usCreate; 
  UserCreate? usUpdate; 

  @override
  void dispose() {
    _nameCtl.dispose();
    _jobCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('REST API (DIO)')),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameCtl,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Name',
                suffixIcon: IconButton(
                  onPressed: _nameCtl.clear,
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _jobCtl,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Job',
                suffixIcon: IconButton(
                  onPressed: _jobCtl.clear,
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final res = await _dataService.getUsers();
                      if (res != null) {
                        setState(() => _result = res.toString());
                      } else {
                        displaySnackbar('Failed to get data');
                      }
                    },
                    child: const Text('GET'),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_nameCtl.text.isEmpty || _jobCtl.text.isEmpty) {
                        displaySnackbar('Semua field harus diisi');
                        return;
                      }
                      final postModel = UserCreate(
                        name: _nameCtl.text,
                        job: _jobCtl.text,
                      );
                      final res = await _dataService.postUser(postModel);
                      setState(() {
                        usCreate = res;
                        usUpdate = null;
                        _result = res?.toString() ?? 'Post failed';
                      });
                      _nameCtl.clear();
                      _jobCtl.clear();
                    },
                    child: const Text('POST'),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_nameCtl.text.isEmpty || _jobCtl.text.isEmpty) {
                        displaySnackbar('Semua field harus diisi');
                        return;
                      }
                      final res = await _dataService.putUser(
                        '3',
                        _nameCtl.text,
                        _jobCtl.text,
                      );
                      if (res != null && res is Map<String, dynamic>) {
                        setState(() {
                          usUpdate = UserCreate(
                            id: '3',
                            name: res['name'] as String? ?? 'Unknown',
                            job: res['job'] as String? ?? 'Unknown',
                            createdAt: res['updatedAt'] as String? ?? 'Unknown',
                          );
                          usCreate = null;
                          _result = res.toString();
                        });
                      } else {
                        setState(() => _result = 'Update failed');
                      }
                      _nameCtl.clear();
                      _jobCtl.clear();
                    },
                    child: const Text('PUT'),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final res = await _dataService.deleteUser('4');
                      setState(
                        () => _result = res?.toString() ?? 'Delete failed',
                      );
                    },
                    child: const Text('DELETE'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final users = await _dataService.getUserModel();
                      if (users != null) {
                        setState(() {
                          _users = users.toList();
                          _result = '-';
                          usCreate = null;
                          usUpdate = null;
                        });
                      }
                    },
                    child: const Text('Model Class User Example'),
                  ),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _result = '-';
                      _users.clear();
                      usCreate = null;
                      usUpdate = null;
                    });
                  },
                  child: const Text('Reset'),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Result',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: _users.isEmpty
                  ? SingleChildScrollView(
                      child: Text(
                        _result,
                        style: const TextStyle(fontSize: 16),
                      ),
                    )
                  : _buildListUser(),
            ),
            const SizedBox(height: 20),
            if (usCreate != null)
              UserCard(
                usrCreate: usCreate!,
                cardColor: Colors.lightBlue[200],
                timeLabel: 'Created At',
              ),
            if (usUpdate != null)
              UserCard(
                usrCreate: usUpdate!,
                cardColor: Colors.orange[200],
                timeLabel: 'Updated At',
              ),
            if (_users.isEmpty && usCreate == null && usUpdate == null && _result == '-')
              Text(
                'no data',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildListUser() {
    return ListView.separated(
      itemBuilder: (context, index) {
        final user = _users[index];
        return Card(
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.network(user.avatar),
            ),
            title: Text('${user.firstName} ${user.lastName}'),
            subtitle: Text(user.email),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 10.0),
      itemCount: _users.length,
    );
  }

  void displaySnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}