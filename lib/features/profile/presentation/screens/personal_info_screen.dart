import 'dart:io';

import 'package:expense_gem_mobile/features/auth/domain/entities/user.dart';
import 'package:expense_gem_mobile/features/auth/presentation/providers/auth_providers.dart';
import 'package:expense_gem_mobile/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class PersonalInfoScreen extends ConsumerStatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  ConsumerState<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends ConsumerState<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _imagePicker = ImagePicker();

  String? _loadedUserId;
  XFile? _pickedImage;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(authStateProvider);
    final formState = ref.watch(profileFormStateProvider);
    final isLoading = formState.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Personal Information')),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            context.go('/login');
            return const SizedBox.shrink();
          }

          _syncUser(user);

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(child: _AvatarPicker(user: user, image: _pickedImage)),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: isLoading ? null : _pickImage,
                  icon: const Icon(Icons.photo_camera_outlined),
                  label: const Text('Change photo (optional)'),
                ),
                const SizedBox(height: 24),
                AuthTextField(
                  controller: _firstNameController,
                  label: 'First Name',
                  hint: 'Enter your first name',
                  icon: Icons.person_outline,
                  textInputAction: TextInputAction.next,
                  validator: _requiredNameValidator,
                ),
                const SizedBox(height: 16),
                AuthTextField(
                  controller: _lastNameController,
                  label: 'Last Name',
                  hint: 'Enter your last name',
                  icon: Icons.person_outline,
                  textInputAction: TextInputAction.next,
                  validator: _requiredNameValidator,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (formState.hasError)
                  _InlineError(message: formState.error.toString()),
                const SizedBox(height: 16),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _saveProfile,
                    child:
                        isLoading
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : const Text('Save Changes'),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stackTrace) =>
                Center(child: _InlineError(message: error.toString())),
      ),
    );
  }

  void _syncUser(User user) {
    if (_loadedUserId == user.id) {
      return;
    }

    _loadedUserId = user.id;
    _firstNameController.text = user.firstName;
    _lastNameController.text = user.lastName;
    _emailController.text = user.email;
  }

  Future<void> _pickImage() async {
    final image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      imageQuality: 85,
    );

    if (image == null || !mounted) {
      return;
    }

    setState(() {
      _pickedImage = image;
    });
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final success = await ref
        .read(profileFormStateProvider.notifier)
        .updateProfile(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          picturePath: _pickedImage?.path,
        );

    if (!mounted || !success) {
      return;
    }

    context.pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );
  }

  String? _requiredNameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }
}

class _AvatarPicker extends StatelessWidget {
  final User user;
  final XFile? image;

  const _AvatarPicker({required this.user, required this.image});

  @override
  Widget build(BuildContext context) {
    final imageFile = image;
    final picture = user.picture;
    final imageProvider =
        imageFile != null
            ? FileImage(File(imageFile.path)) as ImageProvider
            : picture != null && picture.startsWith('http')
            ? NetworkImage(picture) as ImageProvider
            : null;

    return CircleAvatar(
      radius: 52,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      backgroundImage: imageProvider,
      child:
          imageProvider == null
              ? Icon(
                Icons.person,
                size: 56,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              )
              : null,
    );
  }
}

class _InlineError extends StatelessWidget {
  final String message;

  const _InlineError({required this.message});

  @override
  Widget build(BuildContext context) {
    return SelectableText.rich(
      TextSpan(text: message),
      style: TextStyle(color: Theme.of(context).colorScheme.error),
    );
  }
}
