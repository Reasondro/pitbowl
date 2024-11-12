// FILE: user_profile.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:pitbowl/screens/auth_screen.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firebaseStorageProvider = Provider<FirebaseStorage>((ref) {
  return FirebaseStorage.instance;
});

class UserProfile extends ConsumerStatefulWidget {
  const UserProfile({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserProfileState();
}

class _UserProfileState extends ConsumerState<UserProfile> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  File? _imageFile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final currentUser = ref.read(firebaseAuthProvider).currentUser;
    _nameController = TextEditingController(
        text: currentUser?.displayName ?? "No Display Name");
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadProfilePicture(File image) async {
    try {
      String fileName = path.basename(image.path);
      Reference storageRef = ref
          .read(firebaseStorageProvider)
          .ref()
          .child('profile_pictures/$fileName');

      UploadTask uploadTask = storageRef.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      String downloadURL = await snapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      // Handle errors

      if (!mounted) {
        return null;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to upload image: $e"),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final auth = ref.read(firebaseAuthProvider);
    final currentUser = auth.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No user is signed in."),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    String? photoURL = currentUser.photoURL;

    if (_imageFile != null) {
      final uploadedURL = await _uploadProfilePicture(_imageFile!);
      if (uploadedURL != null) {
        photoURL = uploadedURL;
      }
    }

    try {
      await currentUser.updateDisplayName(_nameController.text.trim());
      if (photoURL != currentUser.photoURL) {
        await currentUser.updatePhotoURL(photoURL);
      }
      await currentUser.reload();
      final updatedUser = auth.currentUser;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile updated successfully."),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to update profile: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
        _imageFile = null;
      });
    }
  }

  Future<void> _signOut() async {
    await ref.read(firebaseAuthProvider).signOut();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("You have been signed out."),
        backgroundColor: Colors.blue,
      ),
    );
    // Navigate to AuthScreen or appropriate screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const AuthScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(firebaseAuthProvider).currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Profile"),
        actions: [
          IconButton(
            onPressed: _signOut,
            icon: const Icon(Icons.logout),
            tooltip: "Sign Out",
          ),
        ],
      ),
      body: currentUser == null
          ? const Center(child: Text("No user is signed in."))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Profile Picture
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!)
                          : (currentUser.photoURL != null
                              ? NetworkImage(currentUser.photoURL!)
                                  as ImageProvider
                              : const AssetImage('assets/default_avatar.png')),
                      child: const Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 20,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Profile Form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Display Name
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: "Display Name",
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                value.trim().length < 3) {
                              return "Display name must be at least 3 characters long.";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        // Email Address (Read-Only)
                        TextFormField(
                          initialValue: currentUser.email ?? "No Email",
                          decoration: const InputDecoration(
                            labelText: "Email Address",
                            border: OutlineInputBorder(),
                          ),
                          readOnly: true,
                        ),
                        const SizedBox(height: 30),
                        // Save Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _saveProfile,
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text("Save Changes"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
