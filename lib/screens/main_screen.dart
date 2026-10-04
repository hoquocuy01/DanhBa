import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/contact.dart';
import 'contact_detail_screen.dart';
import 'contact_form_screen.dart';
import 'backup_restore_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  List<Contact> _contacts = [];
  List<String> _customGroups = ['Gia đình', 'Bạn bè', 'Công việc', 'Chưa phân nhóm'];
  String _searchQuery = '';
  String _sortOption = 'A-Z';

  @override
  void initState() {
    super.initState();
    _loadSampleData();
  }

  void _loadSampleData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('contacts_data');
    final String? groupData = prefs.getString('groups_data');

    if (groupData != null) {
      _customGroups = List<String>.from(json.decode(groupData));
    }

    if (data != null) {
      final List list = json.decode(data);
      setState(() {
        _contacts = list.map((e) => Contact.fromMap(e)).toList();
      });
    } else {
      _contacts = [
        Contact(id: '1', name: 'Nguyễn Văn A', phone: '0987 123 456', address: '123 Hải Phòng', email: 'nguyenvana@email.com', isFavorite: true, group: 'Gia đình'),
        Contact(id: '2', name: 'Trần Thị B', phone: '0912 345 678', group: 'Bạn bè'),
        Contact(id: '3', name: 'Lê Văn C', phone: '0967 890 123', isFavorite: true, group: 'Công việc'),
      ];
      _saveContacts();
    }
  }

  void _saveContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final String data = json.encode(_contacts.map((e) => e.toMap()).toList());
    await prefs.setString('contacts_data', data);
    await prefs.setString('groups_data', json.encode(_customGroups));
  }

  List<Contact> get _filteredContacts {
    List<Contact> list = _contacts.where((c) {
      return c.name.toLowerCase().contains(_searchQuery.toLowerCase()) || c.phone.contains(_searchQuery);
    }).toList();
    if (_sortOption == 'A-Z') {
      list.sort((a, b) => a.name.compareTo(b.name));
    } else if (_sortOption == 'Z-A') {
      list.sort((a, b) => b.name.compareTo(a.name));
    }
    return list;
  }

  void _addNewGroup() {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm nhóm mới'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Nhập tên nhóm...'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  _customGroups.add(controller.text.trim());
                  _saveContacts();
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Thêm'),
          )
        ],
      ),
    );
  }

  void _renameGroup(String oldName) {
    TextEditingController controller = TextEditingController(text: oldName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sửa tên nhóm "$oldName"'),
        content: TextField(controller: controller),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () {
              String newName = controller.text.trim();
              if (newName.isNotEmpty && newName != oldName) {
                setState(() {
                  int idx = _customGroups.indexOf(oldName);
                  if (idx != -1) _customGroups[idx] = newName;
                  for (var c in _contacts) {
                    if (c.group == oldName) c.group = newName;
                  }
                  _saveContacts();
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Lưu'),
          )
        ],
      ),
    );
  }

  void _showAppInfo() {
    showAboutDialog(
      context: context,
      applicationName: 'Quản Lý Danh Bạ',
      applicationVersion: 'v1.0.2',
      applicationIcon: const Icon(Icons.import_contacts, size: 40, color: Colors.blue),
      children: const [
        Text('Ứng dụng quản lý danh bạ thông minh hỗ trợ lưu trữ, nhóm liên hệ, chia sẻ thiệp và sao lưu dữ liệu khôi phục an toàn.'),
        SizedBox(height: 10),
        Text('Phát triển bởi: Hồ Quốc Uy', style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildContactTab(),
          _buildFavoriteTab(),
          _buildGroupTab(),
          _buildSettingsTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.import_contacts), label: 'Danh bạ'),
          BottomNavigationBarItem(icon: Icon(Icons.star_border), label: 'Yêu thích'),
          BottomNavigationBarItem(icon: Icon(Icons.group_outlined), label: 'Nhóm'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Cài đặt'),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add, color: Colors.white),
              onPressed: () async {
                final newContact = await Navigator.push<Contact>(
                  context,
                  MaterialPageRoute(builder: (context) => ContactFormScreen(groups: _customGroups)),
                );
                if (newContact != null) {
                  setState(() {
                    _contacts.add(newContact);
                    _saveContacts();
                  });
                }
              },
            )
          : (_currentIndex == 2
              ? FloatingActionButton(
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.create_new_folder, color: Colors.white),
                  onPressed: _addNewGroup,
                )
              : null),
    );
  }

  // 1. Tab Danh Bạ
  Widget _buildContactTab() {
    return Scaffold(
      appBar: AppBar(title: const Text('Danh bạ')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Tìm kiếm liên hệ...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          Expanded(child: _buildContactList(_filteredContacts)),
        ],
      ),
    );
  }

  // 2. Tab Yêu thích
  Widget _buildFavoriteTab() {
    final favorites = _filteredContacts.where((c) => c.isFavorite).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Yêu thích')),
      body: _buildContactList(favorites),
    );
  }

  // 3. Tab Nhóm
  Widget _buildGroupTab() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhóm liên hệ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box),
            onPressed: _addNewGroup,
          )
        ],
      ),
      body: ListView.builder(
        itemCount: _customGroups.length,
        itemBuilder: (context, index) {
          String groupName = _customGroups[index];
          List<Contact> groupContacts = _contacts.where((c) => c.group == groupName).toList();

          return ExpansionTile(
            leading: const Icon(Icons.folder, color: Colors.blue),
            title: Text('$groupName (${groupContacts.length})'),
            trailing: IconButton(
              icon: const Icon(Icons.edit, size: 20, color: Colors.grey),
              onPressed: () => _renameGroup(groupName),
            ),
            children: groupContacts.map((c) => _buildContactTile(c)).toList(),
          );
        },
      ),
    );
  }

  // 4. Tab Cài đặt
  Widget _buildSettingsTab() {
    return Scaffold(
      appBar: AppBar(title: const Text('Cài đặt')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.sort_by_alpha),
            title: const Text('Sắp xếp theo'),
            trailing: DropdownButton<String>(
              value: _sortOption,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(value: 'A-Z', child: Text('Tên A → Z')),
                DropdownMenuItem(value: 'Z-A', child: Text('Tên Z → A')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _sortOption = val);
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.cloud_upload_outlined),
            title: const Text('Sao lưu & Khôi phục'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BackupRestoreScreen(
                    contacts: _contacts,
                    onRestore: (newList) {
                      setState(() {
                        _contacts = newList;
                        _saveContacts();
                      });
                    },
                  ),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Thông tin phần mềm'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _showAppInfo,
          ),
        ],
      ),
    );
  }

  Widget _buildContactList(List<Contact> list) {
    if (list.isEmpty) return const Center(child: Text('Không có liên hệ nào'));
    return ListView.separated(
      itemCount: list.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) => _buildContactTile(list[index]),
    );
  }

  Widget _buildContactTile(Contact contact) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue.shade100,
        child: const Icon(Icons.person, color: Colors.blue),
      ),
      title: Text(contact.name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(contact.phone),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              contact.isFavorite ? Icons.star : Icons.star_border,
              color: contact.isFavorite ? Colors.amber : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                contact.isFavorite = !contact.isFavorite;
                _saveContacts();
              });
            },
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ContactDetailScreen(
              contact: contact,
              onDelete: (id) {
                setState(() {
                  _contacts.removeWhere((c) => c.id == id);
                  _saveContacts();
                });
              },
              onUpdate: (updated) {
                setState(() {
                  int idx = _contacts.indexWhere((c) => c.id == updated.id);
                  if (idx != -1) _contacts[idx] = updated;
                  _saveContacts();
                });
              },
            ),
          ),
        );
        setState(() {});
      },
    );
  }
}