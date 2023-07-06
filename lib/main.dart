import 'package:flutter/material.dart';

class Contact {
  String name;
  String phoneNumber;
  String email;

  Contact({required this.name, required this.phoneNumber, required this.email});
}

class ContactListApp extends StatelessWidget {
  const ContactListApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        hintColor: Colors.blueAccent,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blueAccent,
          ),
        ),
      ),
      home: ContactListScreen(),
    );
  }
}

class ContactListScreen extends StatefulWidget {
  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  List<Contact> contacts = [
    Contact(
      name: 'Imam Hadid Gunawan',
      phoneNumber: '2011019',
      email: 'imamhadid@hadid.com',
    ),
    Contact(
      name: 'Bagus Anggara S',
      phoneNumber: '2011100',
      email: 'bagus@bagus.com',
    ),
    Contact(
      name: 'Aulia Febriani',
      phoneNumber: '2011014',
      email: 'auliafebriani@aul.com',
    ),
    Contact(
      name: 'Hanif Hibatul W',
      phoneNumber: '2011099',
      email: 'hanif@han.com',
    ),
  ];

  void addContact(Contact newContact) {
    setState(() {
      contacts.add(newContact);
    });
  }

  void editContact(Contact editedContact, int index) {
    setState(() {
      contacts[index] = editedContact;
    });
  }

  void deleteContact(int index) {
    setState(() {
      contacts.removeAt(index);
    });
  }

  void openAddContactScreen(BuildContext context) async {
    final newContact = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddContactScreen()),
    );
    if (newContact != null) {
      addContact(newContact);
    }
  }

  void openEditContactScreen(BuildContext context, int index) async {
    final editedContact = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditContactScreen(contact: contacts[index]),
      ),
    );
    if (editedContact != null) {
      editContact(editedContact, index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Kontak'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(
                    contacts[index].name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(
                    contacts[index].phoneNumber,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      openEditContactScreen(context, index);
                    },
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Kontak'),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Nama: ${contacts[index].name}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Nomor Telepon: ${contacts[index].phoneNumber}',
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Alamat Email: ${contacts[index].email}',
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text(
                                'Hapus',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                deleteContact(index);
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('Tutup'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              openAddContactScreen(context);
            },
          ),
        ],
      ),
    );
  }
}

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({Key? key}) : super(key: key);

  @override
  _AddContactScreenState createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Kontak'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nama',
              ),
            ),
            TextField(
              controller: phoneNumberController,
              decoration: const InputDecoration(
                labelText: 'Nomor Telepon',
              ),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Alamat Email',
              ),
            ),
            ElevatedButton(
              child: const Text(
                'Simpan',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                String name = nameController.text;
                String phoneNumber = phoneNumberController.text;
                String email = emailController.text;

                if (name.isNotEmpty &&
                    phoneNumber.isNotEmpty &&
                    email.isNotEmpty) {
                  Contact newContact = Contact(
                    name: name,
                    phoneNumber: phoneNumber,
                    email: email,
                  );
                  Navigator.pop(context, newContact);
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: const Text('Harap lengkapi semua field.'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Tutup'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class EditContactScreen extends StatefulWidget {
  final Contact contact;

  const EditContactScreen({Key? key, required this.contact}) : super(key: key);

  @override
  _EditContactScreenState createState() => _EditContactScreenState();
}

class _EditContactScreenState extends State<EditContactScreen> {
  late TextEditingController nameController;
  late TextEditingController phoneNumberController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.contact.name);
    phoneNumberController =
        TextEditingController(text: widget.contact.phoneNumber);
    emailController = TextEditingController(text: widget.contact.email);
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Kontak'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nama',
              ),
            ),
            TextField(
              controller: phoneNumberController,
              decoration: const InputDecoration(
                labelText: 'Nomor Telepon',
              ),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Alamat Email',
              ),
            ),
            ElevatedButton(
              child: const Text(
                'Simpan',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                String name = nameController.text;
                String phoneNumber = phoneNumberController.text;
                String email = emailController.text;

                if (name.isNotEmpty &&
                    phoneNumber.isNotEmpty &&
                    email.isNotEmpty) {
                  Contact editedContact = Contact(
                    name: name,
                    phoneNumber: phoneNumber,
                    email: email,
                  );
                  Navigator.pop(context, editedContact);
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: const Text('Harap lengkapi semua field.'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Tutup'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const ContactListApp());
}
