import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// final userProfileProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
//   final user = FirebaseAuth.instance.currentUser;
//   if (user == null) return null;

//   final doc =
//       await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
//   return doc.data();
// });

final firebaseUserProvider =
    StreamProvider<User?>((ref) => FirebaseAuth.instance.authStateChanges());

final userProfileProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final user = ref.watch(firebaseUserProvider).value;
  if (user == null) return null;

  final doc =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

  return doc.data();
});

class UserAvatarNameBadge extends ConsumerWidget {
  const UserAvatarNameBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsync = ref.watch(userProfileProvider);

    return userProfileAsync.when(
      data: (data) {
        if (data == null) return const SizedBox();

        final avatar = data['avatar'] ?? '👻';
        final name = data['displayName'] ?? 'Ghostling';
        print("👤 Avatar: ${data['avatar']}, Name: ${data['displayName']}");

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.deepPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                avatar,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 8),
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox(),
      error: (e, _) => const SizedBox(),
    );
  }
}
