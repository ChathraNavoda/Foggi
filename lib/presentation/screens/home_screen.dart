// import 'package:flutter/material.dart';

// import '../layout/foggi_scaffold.dart';
// import '../widgets/custom_header.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const FoggiScaffold(
//       title: "Welcome to Foggi 👻",
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CustomHeader("Let's get foggy with it!"),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/blocs/auth/auth_bloc.dart';
import '../../logic/blocs/auth/auth_event.dart';
import '../layout/foggi_scaffold.dart';
import '../widgets/custom_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _logout(BuildContext context) {
    context.read<AuthBloc>().add(AuthLogoutRequested());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("👻 The ghost has left the game..."),
        backgroundColor: Colors.deepPurpleAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FoggiScaffold(
      title: "Welcome to Foggi 👻",
      child: Stack(
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 80), // space for FAB
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomHeader("Let's get foggy with it!"),
                // Add game content here later...
              ],
            ),
          ),

          // Floating Logout Ghost Button
          Positioned(
            bottom: 24,
            right: 24,
            child: FloatingActionButton.extended(
              onPressed: () => _logout(context),
              backgroundColor: Colors.white,
              icon: const Text("👻", style: TextStyle(fontSize: 22)),
              label: const Text("Logout",
                  style: TextStyle(fontWeight: FontWeight.w600)),
              foregroundColor: Colors.black,
              elevation: 4,
            ),
          ),
        ],
      ),
    );
  }
}
