import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dio_contact/model/contact_model.dart';
import 'package:dio_contact/services/api_services.dart';
import 'package:dio_contact/services/auth_manager.dart';
import 'package:dio_contact/view/screen/login_page.dart';
import 'package:dio_contact/view/widget/contact_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtl = TextEditingController();
  final _numberCtl = TextEditingController();
  final ApiServices _dataService = ApiServices();

  List<ContactsModel> _contactMdl = [];
  ContactResponse? ctRes;
  bool isEdit = false;
  String idContact = '';
  String _result = '-';
  
  late SharedPreferences logindata;
  String username = '';
  String token = ''; 

  @override
  void initState() {
    super.initState();
    initial();
    refreshContactList();
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      username = logindata.getString('username') ?? 'User';
      token = logindata.getString('token') ?? '- No Token -'; // Ambil token dari SP
    });
  }

  @override
  void dispose() {
    _nameCtl.dispose();
    _numberCtl.dispose();
    super.dispose();
  }

  Future<void> refreshContactList() async {
    final users = await _dataService.getAllContact();
    setState(() {
      _contactMdl.clear();
      if (users != null) {
        _contactMdl.addAll(users.toList().reversed);
      } else {
        _result = 'Gagal memuat data / List Kosong';
      }
    });
  }

  String? _validateName(String? value) {
    if (value != null && value.length < 4) return 'Masukkan minimal 4 karakter';
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) return 'Nomor HP tidak boleh kosong';
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) return 'Nomor HP harus berisi angka';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts API'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            onPressed: () => _showLogoutConfirmationDialog(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLoginInfo(),
                _buildFormFields(),
                const SizedBox(height: 16.0),
                _buildActionButtons(),
                _buildHasilCard(),
                _buildControlButtons(),
                const Divider(height: 32, thickness: 1.2),
                const Text(
                  'List Contact',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
                const SizedBox(height: 8.0),
                _buildContactListSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildLoginInfo() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16.0),
      color: Colors.tealAccent.shade100,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column( // Menggunakan Column untuk menampilkan Token (Challenge)
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.account_circle, color: Colors.teal),
                const SizedBox(width: 8.0),
                Text(
                  'Login sebagai : $username',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              'Token: $token',
              style: const TextStyle(fontSize: 11, color: Colors.black54),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        TextFormField(
          controller: _nameCtl,
          validator: _validateName,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Nama',
            prefixIcon: Icon(Icons.person),
          ),
        ),
        const SizedBox(height: 12.0),
        TextFormField(
          controller: _numberCtl,
          validator: _validatePhoneNumber,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Nomor HP',
            prefixIcon: Icon(Icons.phone),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () async {
            if (!(_formKey.currentState?.validate() ?? false)) return;

            final contactData = ContactInput(
              namaKontak: _nameCtl.text,
              nomorHp: _numberCtl.text,
            );

            ContactResponse? res = isEdit
                ? await _dataService.putContact(idContact, contactData)
                : await _dataService.postContact(contactData);

            setState(() {
              ctRes = res;
              isEdit = false;
            });

            _nameCtl.clear();
            _numberCtl.clear();
            refreshContactList();
          },
          child: Text(isEdit ? 'UPDATE' : 'POST'),
        ),
        if (isEdit) ...[
          const SizedBox(width: 8.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              _nameCtl.clear();
              _numberCtl.clear();
              setState(() => isEdit = false);
            },
            child: const Text('CANCEL', style: TextStyle(color: Colors.white)),
          ),
        ],
      ],
    );
  }

  Widget _buildControlButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: refreshContactList,
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh Data'),
          ),
        ),
        const SizedBox(width: 8.0),
        OutlinedButton(
          onPressed: () {
            setState(() {
              _result = '-';
              _contactMdl.clear();
              ctRes = null;
              isEdit = false;
            });
            _nameCtl.clear();
            _numberCtl.clear();
          },
          child: const Text('Reset'),
        ),
      ],
    );
  }

  Widget _buildContactListSection() {
    return SizedBox(
      height: 400,
      child: _contactMdl.isEmpty
          ? Center(child: Text(_result))
          : ListView.separated(
              itemCount: _contactMdl.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8.0),
              itemBuilder: (context, index) {
                final ct = _contactMdl[index];
                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(ct.namaKontak),
                    subtitle: Text(ct.nomorHp),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () {
                            _nameCtl.text = ct.namaKontak;
                            _numberCtl.text = ct.nomorHp;
                            setState(() {
                              isEdit = true;
                              idContact = ct.id;
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _showDeleteConfirmationDialog(ct.id, ct.namaKontak),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildHasilCard() {
    if (ctRes == null) return const SizedBox(height: 16.0);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ContactCard(
        ctRes: ctRes!,
        onDismissed: () => setState(() => ctRes = null),
      ),
    );
  }


  void _showDeleteConfirmationDialog(String id, String nama) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Hapus data $nama?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          TextButton(
            onPressed: () async {
              ContactResponse? res = await _dataService.deleteContact(id);
              setState(() => ctRes = res);
              if (mounted) Navigator.pop(context);
              refreshContactList();
            },
            child: const Text('DELETE', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Anda yakin ingin logout?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Tidak')),
          TextButton(
            onPressed: () async {
              await AuthManager.logout();
              if (!mounted) return;
              Navigator.pushAndRemoveUntil(
                dialogContext,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
            child: const Text('Ya'),
          ),
        ],
      ),
    );
  }
}