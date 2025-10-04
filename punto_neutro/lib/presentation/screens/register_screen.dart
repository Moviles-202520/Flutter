import 'package:flutter/material.dart';

class PuntoNeutroPage extends StatefulWidget {
  const PuntoNeutroPage({Key? key}) : super(key: key); // ✅ Constructor con 'key'

  @override
  _PuntoNeutroPageState createState() => _PuntoNeutroPageState();
}

class _PuntoNeutroPageState extends State<PuntoNeutroPage>
    with SingleTickerProviderStateMixin<PuntoNeutroPage> {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final greenDot = Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: Colors.green,
        shape: BoxShape.circle,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon + Title
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.article_outlined, size: 28),
                SizedBox(width: 8),
                Text(
                  'Punto Neutro',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
            const SizedBox(height: 5),
            // Subtitle
            const Text(
              'Fighting misinformation',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 8),
            // Description text
            Text(
              'A collaborative platform where the community verifies news in real-time to combat disinformation.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),

            const SizedBox(height: 20),

            // Image section
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://images.unsplash.com/photo-1556696863-6c5eddae0f5f?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxuZXdzJTIwam91cm5hbGlzbSUyMG5ld3NwYXBlcnxlbnwxfHx8fDE3NTY4MTk3MTB8MA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
                height: 80,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            // List with green dots
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [greenDot, const SizedBox(width: 8), const Expanded(child: Text('Source credibility analysis'))]),
                const SizedBox(height: 6),
                Row(children: [greenDot, const SizedBox(width: 8), const Expanded(child: Text('Real-time collaborative verification'))]),
                const SizedBox(height: 6),
                Row(children: [greenDot, const SizedBox(width: 8), const Expanded(child: Text('Network of verified users'))]),
              ],
            ),

            const SizedBox(height: 20),

            // Card form container
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Access your account', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 3),
                  Text('Enter your credentials to continue', style: TextStyle(color: Colors.grey[600], fontSize: 12)),

                  const SizedBox(height: 15),

                  // Tabs for Sign In / Register
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      indicator: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      tabs: const [
                        Tab(child: Text('Sign In', style: TextStyle(fontWeight: FontWeight.w600))),
                        Tab(child: Text('Register', style: TextStyle(fontWeight: FontWeight.w600))),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Radio Button info text
                  Row(
                    children: [
                      const Icon(Icons.radio_button_checked, size: 14, color: Colors.grey),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          "100% anonymous registration. We don't store personal information.",
                          style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 15),

                  // Email Label and Field
                  const Text('Email', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 5),
                  TextFormField(
                    decoration: InputDecoration(
                      fillColor: Colors.grey[300],
                      filled: true,
                      hintText: 'you@example.com',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Only for account recovery. Won’t be visible to other users.',
                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                  ),

                  const SizedBox(height: 15),

                  // Password Label and Field
                  const Text('Password', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 5),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      fillColor: Colors.grey[300],
                      filled: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Submit Button
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 40),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Create Anonymous Account', style: TextStyle(fontSize: 12, color: Colors.white)),
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
