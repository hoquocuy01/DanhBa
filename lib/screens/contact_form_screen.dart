import 'package:flutter/material.dart';
import '../models/contact.dart';

class ContactFormScreen extends StatefulWidget {
  final Contact? contact;
  final List<String> groups;

  const ContactFormScreen({super.key, this.contact, this.groups = const ['Gia đình', 'Bạn bè', 'Công việc', 'Chưa phân nhóm']});

  @override
  State<ContactFormScreen> createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends State<ContactFormScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _noteController = TextEditingController();
  late String _selectedGroup;

  @override
  void initState() {
    super.initState();
    _selectedGroup = widget.groups.first;
    if (widget.contact != null) {
      _nameController.text = widget.contact!.name;
      _phoneController.text = widget.contact!.phone;
      _addressController.text = widget.contact!.address;
      _emailController.text = widget.contact!.email;
      _noteController.text = widget.contact!.note;
      if (widget.groups.contains(widget.contact!.group)) {
        _selectedGroup = widget.contact!.group;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEdit = widget.contact != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Sửa liên hệ' : 'Thêm liên hệ')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInput(Icons.person_outline, 'Họ và tên *', _nameController),
            _buildInput(Icons.phone_outlined, 'Số điện thoại *', _phoneController, keyboardType: TextInputType.phone),
            _buildInput(Icons.location_on_outlined, 'Địa chỉ', _addressController),
            _buildInput(Icons.email_outlined, 'Email', _emailController, keyboardType: TextInputType.emailAddress),
            _buildInput(Icons.note_outlined, 'Ghi chú', _noteController),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.group_outlined, color: Colors.grey),
                const SizedBox(width: 16),
                const Text('Nhóm: ', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: widget.groups.contains(_selectedGroup) ? _selectedGroup : widget.groups.first,
                  items: widget.groups.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedGroup = val);
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Hủy'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_nameController.text.isEmpty || _phoneController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Vui lòng điền Họ tên và Số điện thoại')),
                        );
                        return;
                      }
                      final result = Contact(
                        id: widget.contact?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                        name: _nameController.text,
                        phone: _phoneController.text,
                        address: _addressController.text,
                        email: _emailController.text,
                        note: _noteController.text,
                        isFavorite: widget.contact?.isFavorite ?? false,
                        group: _selectedGroup,
                      );
                      Navigator.pop(context, result);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                    child: const Text('Lưu'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInput(IconData icon, String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(prefixIcon: Icon(icon), labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }
}