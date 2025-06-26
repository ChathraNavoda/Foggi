import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final displayNamePromptProvider = StateProvider<bool>((ref) => false);
final selectedAvatarProvider = StateProvider<String>((ref) => '👻');

final availableAvatars = ['👻', '🧙‍♂️', '🧛‍♀️', '👽', '🧞', '🤖', '🧙'];

class PromptDisplayNameDialog extends ConsumerWidget {
  final VoidCallback? onSaved;
  const PromptDisplayNameDialog({super.key, this.onSaved});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController nameController = TextEditingController();
    final selectedAvatar = ref.watch(selectedAvatarProvider);

    return AlertDialog(
      title: const Text("Choose Your Ghost Persona"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: "Display Name"),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: availableAvatars.map((emoji) {
              return ChoiceChip(
                label: Text(emoji, style: const TextStyle(fontSize: 20)),
                selected: selectedAvatar == emoji,
                onSelected: (_) =>
                    ref.read(selectedAvatarProvider.notifier).state = emoji,
              );
            }).toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Skip"),
        ),
        ElevatedButton(
          onPressed: () async {
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              final name = nameController.text.trim().isNotEmpty
                  ? nameController.text.trim()
                  : "Ghostling";

              await user.updateDisplayName(name);
              // await FirebaseFirestore.instance
              //     .collection('users')
              //     .doc(user.uid)
              //     .set({
              //   'displayName': name,
              //   'avatar': ref.read(selectedAvatarProvider),
              //   'email': user.email ?? '',
              // }, SetOptions(merge: true));

              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .set({
                'displayName': name,
                'avatar': ref.read(selectedAvatarProvider),
                'email': user.email ?? '',
                'createdAt': FieldValue.serverTimestamp(),
              }, SetOptions(merge: true));
            }

            Navigator.pop(context);
            ref.read(displayNamePromptProvider.notifier).state = false;
            onSaved?.call();
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}
