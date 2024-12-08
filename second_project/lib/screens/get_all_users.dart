import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../utils/auth_provider.dart';
import 'package:provider/provider.dart';


class AllUsersScreen extends StatefulWidget {
  const AllUsersScreen({super.key});

  @override
  State<AllUsersScreen> createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  late Future<List<Map<String, dynamic>>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = UserService.getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    if (userProvider.role != 'admin') {
      // If the user is not an admin, show an error or redirect them
      return Scaffold(
        appBar: AppBar(title: const Text("Unauthorized")),
        body: const Center(
          child: Text("You do not have permission to view this page."),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Users'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found.'));
          }

          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text(user['username'] ?? 'Unknown Name'),
                subtitle: Text(user['email'] ?? 'Unknown Email'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteUser(context, user['id']),
                ),
              );
            },
          );
        },
      ),
    );
  }


  Future<void> _deleteUser(BuildContext context, int userId) async {
    try {
      await UserService.deleteUserById(userId);
      setState(() {
        _usersFuture = UserService.getAllUsers();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete user: $e')),
      );
    }
  }
}
