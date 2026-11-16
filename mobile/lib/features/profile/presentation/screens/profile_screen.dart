import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/di/di.dart';
import 'package:mobile/core/routing/routes.dart';
import 'package:mobile/core/storage/secure_storage.dart';
import 'package:mobile/core/utils/constants/colors.dart';
import 'package:mobile/core/utils/responsive/responsive.dart';

class ProfileScreen extends StatefulWidget {
  final SecureTokenStorage? storage;

  const ProfileScreen({super.key, this.storage});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final SecureTokenStorage _storage;
  late Future<List<String?>> _profile;
  bool _isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    _storage = widget.storage ?? sl<SecureTokenStorage>();
    _profile = _readProfile();
  }

  Future<List<String?>> _readProfile() =>
      Future.wait([_storage.readName(), _storage.readEmail()]);

  Future<void> _logout() async {
    setState(() => _isLoggingOut = true);
    try {
      await _storage.clear();
      if (mounted) context.go(Routes.login);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not log out: $error'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoggingOut = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SHOPPPIX / PROFILE", style: Theme.of(context).textTheme.titleMedium),
        centerTitle: false,
      ),
      body: FutureBuilder<List<String?>>(
        future: _profile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(Responsive.w(24)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Could not load your profile: ${snapshot.error}',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: Responsive.h(16)),
                    TextButton(
                      onPressed: () =>
                          setState(() => _profile = _readProfile()),
                      child: const Text('TRY AGAIN'),
                    ),
                  ],
                ),
              ),
            );
          }

          final values = snapshot.data!;
          final name = values[0]?.trim() ?? '';
          final email = values[1]?.trim() ?? '';
          final displayName = name.isEmpty ? 'Shoppix User' : name;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.w(16),
              vertical: Responsive.h(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'YOUR ACCOUNT',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: Responsive.h(24)),
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: Responsive.r(44),
                        backgroundColor: AppColors.button,
                        child: Text(
                          displayName[0].toUpperCase(),
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: AppColors.buttonText,
                                fontSize: Responsive.sp(36),
                              ),
                        ),
                      ),
                      SizedBox(height: Responsive.h(16)),
                      Text(
                        displayName,
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: Responsive.h(4)),
                      Text(
                        email.isEmpty ? 'Email unavailable' : email,
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Responsive.h(32)),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.textFieldFillColor,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.person_outline,
                          color: AppColors.bodyLarge,
                        ),
                        title: Text(
                          'NAME',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        subtitle: Text(
                          displayName,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      Divider(height: 1, color: AppColors.border),
                      ListTile(
                        leading: const Icon(
                          Icons.email_outlined,
                          color: AppColors.bodyLarge,
                        ),
                        title: Text(
                          'EMAIL',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        subtitle: Text(
                          email.isEmpty ? 'Email unavailable' : email,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Responsive.h(32)),
                SizedBox(
                  width: double.infinity,
                  height: Responsive.h(52),
                  child: ElevatedButton.icon(
                    onPressed: _isLoggingOut ? null : _logout,
                    icon: const Icon(Icons.logout),
                    label: Text(_isLoggingOut ? 'SIGNING OUT' : 'LOG OUT'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
