import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/contact.dart';

class BackupRestoreScreen extends StatefulWidget {
  final List<Contact> contacts;
  final Function(List<Contact>) onRestore;

  const BackupRestoreScreen({
    super.key,
    required this.contacts,
    required this.onRestore,
  });

  @override
  State<BackupRestoreScreen> createState() => _BackupRestoreScreenState();
}

class _BackupRestoreScreenState extends State<BackupRestoreScreen> {
  String _lastBackupDate = 'Chưa có bản sao lưu';

  @override
  void initState() {
    super.initState();
    _loadBackupInfo();
  }

  void _loadBackupInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lastBackupDate = prefs.getString('last_backup_time') ?? 'Chưa có bản sao lưu';
    });
  }

  void _backupData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = json.encode(widget.contacts.map((e) => e.toMap()).toList());
    final now = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());

    await prefs.setString('backup_contacts', data);
    await prefs.setString('last_backup_time', now);

    setState(() {
      _lastBackupDate = now;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sao lưu ${widget.contacts.length} liên hệ thành công!')),
      );
    }
  }

  void _restoreData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('backup_contacts');

    if (data != null) {
      final List list = json.decode(data);
      List<Contact> restored = list.map((e) => Contact.fromMap(e)).toList();
      widget.onRestore(restored);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Khôi phục thành công ${restored.length} liên hệ!')),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không tìm thấy bản sao lưu nào trên hệ thống!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sao lưu & Khôi phục')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: const Icon(Icons.cloud_upload_outlined, color: Colors.blue, size: 28),
            title: const Text('Sao lưu dữ liệu thực tế', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Lưu toàn bộ danh bạ vào bộ nhớ ứng dụng'),
            onTap: _backupData,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.cloud_download_outlined, color: Colors.green, size: 28),
            title: const Text('Khôi phục dữ liệu', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Tải lại danh bạ từ bản sao lưu gần nhất'),
            onTap: _restoreData,
          ),
          const Divider(),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Lần sao lưu gần nhất:', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 4),
                Text(_lastBackupDate, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue)),
              ],
            ),
          )
        ],
      ),
    );
  }
}