import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:punto_neutro/presentation/screens/LoginScreen.dart';

// Imports de tu capa de datos (ya creados antes)
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/fake_auth_repository.dart';
import '../../data/models/user_login.dart';

// ================================================
// ViewModel TEMPORAL (colocado aquí para que compiles ya).
// Luego muévelo a: lib/presentation/viewmodels/auth_view_model.dart
// ================================================
class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repository;
  AuthViewModel(this._repository);

  UserLogin? _currentUser;
  bool _loading = false;
  String? _error;

  UserLogin? get currentUser => _currentUser;
  bool get loading => _loading;
  String? get error => _error;
  bool get loggedIn => _currentUser != null;

  Future<void> loginWithPassword(String email, String password) async {
    _loading = true; _error = null; notifyListeners();
    try {
      final user = await _repository.loginWithPassword(email: email, password: password);
      _currentUser = user;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false; notifyListeners();
    }
  }

  Future<void> loginWithBiometric() async {
    _loading = true; _error = null; notifyListeners();
    try {
      final ok = await _repository.refreshSession(); // lee token de la bóveda (pide huella)
      if (ok) {
        // Usuario mock al refrescar por huella (solo para UI)
        _currentUser = UserLogin(
          userLoginId: 'biometric',
          email: 'test@demo.com',
          password: 'password123',
          fingerprintEnabled: true,
        );
      } else {
        _error = 'No hay sesión biométrica guardada';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false; notifyListeners();
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    _currentUser = null;
    notifyListeners();
  }
}

// ================================================
// App root con Provider y rutas
// ================================================

class PuntoNeutroApp extends StatelessWidget {
  const PuntoNeutroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthViewModel(FakeAuthRepository()),
      child: MaterialApp(
        title: 'Punto Neutro',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          scaffoldBackgroundColor: Colors.grey[100],
        ),
        home: const LoginScreen(),
        routes: {
          '/home': (_) => const VerifiedNewsPage(), // Home abajo
        },
      ),
    );
  }
}

// ================================================
// Home (tu VerifiedNewsPage original, sin main())
// ================================================
class VerifiedNewsPage extends StatefulWidget {
  const VerifiedNewsPage({Key? key}) : super(key: key);

  @override
  State<VerifiedNewsPage> createState() => _VerifiedNewsPageState();
}

class _VerifiedNewsPageState extends State<VerifiedNewsPage> {
  int _selectedCategoryIndex = 0;
  int _selectedBottomIndex = 0;

  final List<String> _categories = ['All', 'Tech', 'Politics', 'Health', 'Security'];

  Future<void> _confirmLogout(BuildContext context) async {
    final vm = context.read<AuthViewModel>();
    final bool? ok = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('¿Cerrar sesión?'),
        content: const Text('¿Estás seguro que quieres cerrar sesión?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('No')),
          FilledButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Sí')),
        ],
      ),
    );

    if (ok == true) {
      await vm.logout();
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil('/', (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con logout
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: const [
                    Icon(Icons.shield_outlined, size: 24),
                    SizedBox(width: 8),
                    Text('Punto Neutro', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                  ]),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
                      Positioned(
                        right: 6, top: 6,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red, shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          child: const Text('3', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout_outlined),
                    onPressed: () => _confirmLogout(context),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              const Text('Verified News', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _StatsCard(icon: Icons.check_circle_outline, iconColor: Colors.green, number: '1,247', label: 'Verified today'),
                  _StatsCard(icon: Icons.error_outline, iconColor: Colors.red, number: '23', label: 'Fake detected'),
                  _StatsCard(icon: Icons.access_time_outlined, iconColor: Colors.blue, number: '156', label: 'Verifying'),
                ],
              ),

              const SizedBox(height: 15),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search news...',
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        prefixIcon: const Icon(Icons.search),
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.filter_list_outlined),
                  )
                ],
              ),

              const SizedBox(height: 12),

              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final selected = index == _selectedCategoryIndex;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategoryIndex = index),
                      child: Container(
                        margin: EdgeInsets.only(right: index == _categories.length - 1 ? 0 : 12),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        decoration: BoxDecoration(
                          color: selected ? Colors.black : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            _categories[index],
                            style: TextStyle(
                              color: selected ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w600, fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  border: Border.all(color: Colors.orange.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Icon(Icons.warning_amber_rounded, color: Colors.orange.shade600),
                      const SizedBox(width: 8),
                      Text('Misinformation Alert', style: TextStyle(color: Colors.orange.shade800, fontWeight: FontWeight.w700, fontSize: 16)),
                    ]),
                    const SizedBox(height: 8),
                    Text(
                      '3 fake news stories detected about health topics.\nVerify sources before sharing.',
                      style: TextStyle(color: Colors.orange.shade900, fontWeight: FontWeight.w400, fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {},
                      child: Text('View details',
                        style: TextStyle(color: Colors.orange.shade700, fontWeight: FontWeight.w600, fontSize: 14, decoration: TextDecoration.underline),
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 12),

              Expanded(
                child: ListView(
                  children: const [
                    _NewsCard(
                      imageUrl: 'assets/images/image1.jpeg',
                      category: 'Technology',
                      fakePercent: 68,
                      headline: 'Advances in automatic verification technology combat fake news',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey.shade600,
        currentIndex: _selectedBottomIndex,
        onTap: (i) => setState(() => _selectedBottomIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book_outlined), label: 'Guide'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String number;
  final String label;
  const _StatsCard({Key? key, required this.icon, required this.iconColor, required this.number, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3))],
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(height: 6),
            Text(number, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  final String imageUrl;
  final String category;
  final int fakePercent;
  final String headline;
  const _NewsCard({Key? key, required this.imageUrl, required this.category, required this.fakePercent, required this.headline}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 7, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Image.asset(imageUrl, height: 180, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
                    child: Text(category, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.blue.shade700)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(12)),
                    child: Row(children: [
                      const Icon(Icons.warning_amber_rounded, size: 14, color: Colors.red),
                      const SizedBox(width: 4),
                      Text('$fakePercent%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.red)),
                    ]),
                  ),
                  IconButton(icon: const Icon(Icons.flag_outlined), onPressed: () {}),
                ]),
                const SizedBox(height: 10),
                Text(headline, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
