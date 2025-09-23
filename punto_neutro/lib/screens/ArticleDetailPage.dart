import 'package:flutter/material.dart';

class ArticleDetailPage extends StatelessWidget {
  const ArticleDetailPage({super.key});

  // ===== Strings fijos / demo =====
  static const _assetPath = 'assets/images/image1.jpeg';
  static const _category = 'Technology';
  static const _fakePercent = 68;
  static const _title =
      'Advances in automatic verification technology combat fake news';
  static const _subtitle =
      'New AI algorithms can identify manipulated content with 98% accuracy.';
  static const _author = 'Verified author';
  static const _source = 'Tech Research Institute';

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffFAFAFA),
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Back to feed', style: TextStyle(fontWeight: FontWeight.w600)),
        actions: const [
          Icon(Icons.notifications_none_rounded),
          SizedBox(width: 4),
          Icon(Icons.ios_share_rounded),
          SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
        children: [
          // chips
          Row(
            children: [
              _pill(text: _category, bg: cs.secondaryContainer, fg: cs.onSecondaryContainer),
              const SizedBox(width: 8),
              _pill(
                text: '$_fakePercent%',
                icon: Icons.warning_amber_rounded,
                bg: cs.errorContainer,
                fg: cs.onErrorContainer,
              ),
            ],
          ),
          const SizedBox(height: 12),

          const Text(_title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, height: 1.1)),
          const SizedBox(height: 6),
          Text(_subtitle, style: TextStyle(color: Colors.black.withOpacity(.7), height: 1.4)),
          const SizedBox(height: 14),

          // author block
          Row(
            children: [
              const CircleAvatar(radius: 16, child: Icon(Icons.verified_user_rounded)),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(_author, style: TextStyle(fontWeight: FontWeight.w700)),
                  Text('Tech Research Institute • January 15, 2025 at 05:30',
                      style: TextStyle(color: Colors.black54, fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // share / bookmark row
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.ios_share_rounded, size: 18),
                  label: const Text('Share'),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(onPressed: () {}, child: const Icon(Icons.bookmark_border_rounded)),
              const SizedBox(width: 8),
              OutlinedButton(onPressed: () {}, child: const Icon(Icons.flag_outlined)),
            ],
          ),
          const SizedBox(height: 14),

          // main image (ASSET)
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(_assetPath, fit: BoxFit.cover),
          ),
          const SizedBox(height: 16),

          // ===== Credibility Analysis =====
          _card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: const [
                  Icon(Icons.shield_outlined, size: 18),
                  SizedBox(width: 8),
                  Text('Credibility Analysis', style: TextStyle(fontWeight: FontWeight.w700)),
                ]),
                const SizedBox(height: 14),
                Center(
                  child: Text(
                    '$_fakePercent%',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: cs.error,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const Center(
                  child: Text('Reliability score', style: TextStyle(color: Colors.black54)),
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: _fakePercent / 100,
                  minHeight: 8,
                  backgroundColor: cs.errorContainer.withOpacity(.5),
                  color: cs.error,
                  borderRadius: BorderRadius.circular(8),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: const [
                    _Check(label: 'Verified source'),
                    _Check(label: 'Verified data'),
                    _Check(label: 'Recognized author'),
                    _Check(label: 'No manipulation'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ===== Long description / methodology =====
          _card(
            child: const Text(
              'Researchers have developed advanced artificial intelligence systems capable of detecting '
                  'manipulated content, deepfakes and fake news with unprecedented 98% accuracy.\n\n'
                  'This advancement represents a significant milestone in the fight against digital '
                  'misinformation, which has become one of the greatest challenges of our digital era. '
                  'The new algorithms use deep learning techniques to analyze subtle patterns in images, '
                  'videos and text that are imperceptible to the human eye.\n\n'
                  'Verification Methodology\n'
                  'The system employs multiple layers of analysis:\n'
                  '• Metadata and source origin analysis\n'
                  '• Detection of inconsistencies in images and videos\n'
                  '• Cross-verification with reliable databases\n'
                  '• Semantic analysis of textual content\n'
                  'Preliminary results show extraordinary effectiveness in identifying false content, '
                  'which could revolutionize the way we consume information online.\n\n'
                  'Impact on Society\n'
                  'The implementation of this technology has the potential to restore public trust in digital '
                  'information sources and protect citizens from malicious disinformation campaigns.',
              style: TextStyle(height: 1.35),
            ),
          ),

          const SizedBox(height: 12),

          // ===== Rate this article (simulado) =====
          const _RateCard(),

          const SizedBox(height: 12),

          // ===== Source Information =====
          _card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: const [
                  Icon(Icons.info_outline, size: 18),
                  SizedBox(width: 8),
                  Text('Source Information', style: TextStyle(fontWeight: FontWeight.w700)),
                ]),
                const SizedBox(height: 16),
                const Text('Tech Research Institute',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                const SizedBox(height: 4),
                const Text(
                  'Internationally recognized technology research institute',
                  style: TextStyle(color: Colors.black54),
                ),
                const Divider(height: 24),
                _kv('Founded:', '1995'),
                _kv('Location:', 'Madrid, Spain'),
                _kv('Type:', 'Academic institution'),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () {}, // no abre nada, demo
                  icon: const Icon(Icons.open_in_new_rounded, size: 18),
                  label: const Text('View original source'),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (_) {},
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey.shade600,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book_outlined), label: 'Guide'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  // ===== helpers UI =====
  static Widget _kv(String k, String v) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        SizedBox(width: 90, child: Text(k, style: const TextStyle(color: Colors.black54))),
        Expanded(child: Text(v, style: const TextStyle(fontWeight: FontWeight.w600))),
      ],
    ),
  );

  static Widget _card({required Widget child}) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.black12),
      borderRadius: BorderRadius.circular(16),
    ),
    child: child,
  );

  static Widget _pill({required String text, required Color bg, required Color fg, IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (icon != null) ...[Icon(icon, size: 14, color: fg), const SizedBox(width: 4)],
        Text(text, style: TextStyle(color: fg, fontWeight: FontWeight.w700, letterSpacing: .2)),
      ]),
    );
  }
}

class _Check extends StatelessWidget {
  final String label;
  const _Check({required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.check_circle, color: Colors.green.shade600, size: 16),
      const SizedBox(width: 6),
      Text(label, style: TextStyle(color: Colors.green.shade700)),
    ]);
  }
}

// Tarjeta con slider + comentario (sin backend)
class _RateCard extends StatefulWidget {
  const _RateCard();

  @override
  State<_RateCard> createState() => _RateCardState();
}

class _RateCardState extends State<_RateCard> {
  double value = 1.0; // 0.0–1.0
  final controller = TextEditingController();
  static const maxChars = 500;

  String get label {
    final pct = (value * 100).round();
    if (pct <= 20) return 'Very unreliable';
    if (pct <= 40) return 'Unreliable';
    if (pct <= 60) return 'Neutral';
    if (pct <= 80) return 'Reliable';
    return 'Very reliable';
  }

  @override
  Widget build(BuildContext context) {
    final pct = (value * 100).round();

    return ArticleDetailPage._card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: const [
            Icon(Icons.percent_rounded, size: 18),
            SizedBox(width: 8),
            Text('Rate this article', style: TextStyle(fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: 12),
          Text('How reliable do you find this information?',
              style: TextStyle(color: Colors.black.withOpacity(.8))),
          const SizedBox(height: 8),
          Center(
            child: Text(
              '$pct%',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 8),
          Slider(
            value: value,
            onChanged: (v) => setState(() => value = v),
          ),
          Center(
            child: Text(label, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 16),
          const Text('Share your opinion (optional):'),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLength: maxChars,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Write your comment about the credibility of this article...',
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              counterText: '${controller.text.length}/$maxChars',
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Rating submitted (demo).')),
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Submit rating'),
            ),
          ),
        ],
      ),
    );
  }
}
