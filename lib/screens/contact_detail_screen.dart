import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../models/contact.dart';
import 'contact_form_screen.dart';

class ContactDetailScreen extends StatelessWidget {
  final Contact contact;
  final Function(String) onDelete;
  final Function(Contact) onUpdate;

  const ContactDetailScreen({
    super.key,
    required this.contact,
    required this.onDelete,
    required this.onUpdate,
  });

  void _shareContactCard(BuildContext context) {
    final cardContent = '''
🎴 --- THIỆP LIÊN HỆ --- 🎴
👤 Họ tên: ${contact.name}
📞 Điện thoại: ${contact.phone}
✉️ Email: ${contact.email.isEmpty ? 'Chưa cập nhật' : contact.email}
🏠 Địa chỉ: ${contact.address.isEmpty ? 'Chưa cập nhật' : contact.address}
🏷️ Nhóm: ${contact.group}
---------------------------
Được chia sẻ từ Ứng dụng Danh Bạ
''';
    Share.share(cardContent, subject: 'Thiệp danh bạ của ${contact.name}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết liên hệ')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            CircleAvatar(
              radius: 45,
              backgroundColor: Colors.blue.shade100,
              child: const Icon(Icons.person, size: 50, color: Colors.blue),
            ),
            const SizedBox(height: 12),
            Text(contact.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(contact.phone, style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(Icons.phone, 'Gọi', Colors.blue, () {}),
                _buildActionButton(Icons.message, 'Nhắn tin', Colors.blue, () {}),
                _buildActionButton(Icons.share, 'Chia sẻ', Colors.green, () => _shareContactCard(context)),
                _buildActionButton(Icons.edit, 'Sửa', Colors.orange, () async {
                  final updated = await Navigator.push<Contact>(
                    context,
                    MaterialPageRoute(builder: (context) => ContactFormScreen(contact: contact)),
                  );
                  if (updated != null) onUpdate(updated);
                }),
                _buildActionButton(Icons.delete, 'Xóa', Colors.red, () {
                  onDelete(contact.id);
                  Navigator.pop(context);
                }),
              ],
            ),
            const SizedBox(height: 30),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Thông tin khác', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.location_on_outlined, 'Địa chỉ', contact.address),
            _buildInfoRow(Icons.email_outlined, 'Email', contact.email),
            _buildInfoRow(Icons.note_outlined, 'Ghi chú', contact.note),
            _buildInfoRow(Icons.group_outlined, 'Nhóm', contact.group),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(backgroundColor: color, radius: 22, child: Icon(icon, color: Colors.white, size: 20)),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 16),
          SizedBox(width: 70, child: Text(label, style: const TextStyle(color: Colors.grey))),
          Expanded(child: Text(value.isEmpty ? 'Chưa có' : value, style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}