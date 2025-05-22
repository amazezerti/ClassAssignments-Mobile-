import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<Contact> _contacts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getContacts();
  }

  Future<void> _getContacts() async {
    final status = await Permission.contacts.request();
    if (status.isGranted) {
      try {
        final contacts = await FlutterContacts.getContacts(
          withProperties: true,
        );
        setState(() {
          _contacts = contacts;
          _isLoading = false;
        });
      } catch (e) {
        print("Error fetching contacts: $e");
        setState(() => _isLoading = false);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contacts permission denied')),
      );
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contacts')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _contacts.isEmpty
          ? const Center(child: Text('No contacts found'))
          : ListView.builder(
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          final contact = _contacts[index];
          return ListTile(
            leading: contact.photo != null
                ? CircleAvatar(backgroundImage: MemoryImage(contact.photo!))
                : const CircleAvatar(child: Icon(Icons.person)),
            title: Text(contact.displayName),
            subtitle: Text(contact.phones.isNotEmpty ? contact.phones.first.number : 'No Phone'),
          );
        },
      ),
    );
  }
}