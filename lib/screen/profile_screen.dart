import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:convert';
import 'dart:typed_data';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactNumberController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  User? _user;
  String? _profileImageBase64; // Store Base64 string for profile image
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      _user = FirebaseAuth.instance.currentUser;
      if (_user == null) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
        return;
      }

      // Fetch user data from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .get();

      if (mounted) {
        setState(() {
          // Split displayName into first and last name (if available)
          final displayName = _user!.displayName ?? '';
          final nameParts = displayName.split(' ');
          _firstNameController.text = nameParts.isNotEmpty ? nameParts[0] : '';
          _lastNameController.text = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
          _emailController.text = _user!.email ?? '';
          _contactNumberController.text = userDoc.exists ? (userDoc.data()!['contactNumber'] ?? '') : '';
          _profileImageBase64 = userDoc.exists ? userDoc.data()!['profileImage'] : null;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _pickAndCompressImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 200,
        maxHeight: 200,
      );
      if (image == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No image selected')),
          );
        }
        return;
      }

      // Read image bytes
      Uint8List imageBytes = await image.readAsBytes();

      // Compress the image (mobile only)
      Uint8List? compressedImage;
      if (!kIsWeb) {
        compressedImage = await FlutterImageCompress.compressWithList(
          imageBytes,
          minHeight: 200,
          minWidth: 200,
          quality: 70,
          format: CompressFormat.jpeg,
        );
      } else {
        // On web, use the original bytes (no compression available)
        compressedImage = imageBytes;
      }

      // Convert to Base64
      final String base64String = base64Encode(compressedImage);

      if (mounted) {
        setState(() {
          _profileImageBase64 = 'data:image/jpeg;base64,$base64String';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to pick image: $e';
        });
      }
    }
  }

  Future<void> _saveProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      if (_user != null) {
        // Combine first and last name for displayName
        final displayName = '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}'.trim();
        await _user!.updateDisplayName(displayName);

        // Save profile data to Firestore
        final userData = {
          'firstName': _firstNameController.text.trim(),
          'lastName': _lastNameController.text.trim(),
          'contactNumber': _contactNumberController.text.trim(),
          'email': _user!.email,
          'updatedAt': FieldValue.serverTimestamp(),
          'profileImage': _profileImageBase64 ?? FieldValue.delete(),
        };

        await FirebaseFirestore.instance
            .collection('users')
            .doc(_user!.uid)
            .set(userData, SetOptions(merge: true));

        await _user!.reload();
        if (mounted) {
          setState(() {
            _user = FirebaseAuth.instance.currentUser;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully.'),
              backgroundColor: Color(0xFF4CAF50),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _signOut() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF43EA7D), // Vibrant light green
              Color(0xFF4CAF50), // Main green
              Color(0xFF388E3C), // Medium green
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                    ),
                  ],
                ),
              ),
              // Account Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Text(
                  'Account',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              // Main Content Card
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _user?.displayName ?? 'User',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: _isLoading ? null : _saveProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2196F3),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 0,
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                                  : const Text(
                                      'SAVE',
                                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                                    ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Error Message
                        if (_errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(color: Colors.red, fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        // Profile Image
                        Center(
                          child: Column(
                            children: [
                              InkWell(
                                onTap: _isLoading ? null : _pickAndCompressImage,
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey.shade300, width: 2),
                                  ),
                                  child: _profileImageBase64 != null && _profileImageBase64!.startsWith('data:image')
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.memory(
                                            base64Decode(_profileImageBase64!.split(',')[1]),
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) => const Icon(
                                              Icons.person,
                                              size: 60,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        )
                                      : const Icon(Icons.add_a_photo, size: 40, color: Colors.green),
                                ),
                              ),
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: _isLoading ? null : _pickAndCompressImage,
                                child: const Text(
                                  'Upload Image',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF2196F3),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        // First Name Field
                        _buildProfileInputField('First Name', _firstNameController, 'Enter your first name'),
                        const SizedBox(height: 20),
                        // Last Name Field
                        _buildProfileInputField('Last Name', _lastNameController, 'Enter your last name'),
                        const SizedBox(height: 20),
                        // Email Field (Read-only)
                        _buildProfileInputField('Email', _emailController, 'Enter your email', enabled: false),
                        const SizedBox(height: 20),
                        // Contact Number Field
                        _buildProfileInputField('Contact Number', _contactNumberController, 'Enter your contact number'),
                        const SizedBox(height: 40),
                        // Sign Out Button
                        Align(
                          alignment: Alignment.bottomRight,
                          child: GestureDetector(
                            onTap: _isLoading ? null : _signOut,
                            child: const Text(
                              'Sign Out',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInputField(String label, TextEditingController controller, String hint, {bool obscureText = false, bool enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            enabled: enabled,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.black54),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _contactNumberController.dispose();
    super.dispose();
  }
}