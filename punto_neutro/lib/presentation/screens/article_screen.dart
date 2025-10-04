import 'package:flutter/material.dart';

class ArticlePage extends StatelessWidget {
  const ArticlePage({Key? key}) : super(key: key);

  // Dummy variables to simulate data
  final double reliabilityScore = 68;
  final double userReliabilityRating = 75;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Punto Neutro'),
        leading: IconButton(
          icon: const Icon(Icons.security_outlined),
          onPressed: () {}, // Logo/button action
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          // Notification badge example
          Positioned(
            right: 12,
            top: 12,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: const Text(
                '3',
                style: TextStyle(color: Colors.white, fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back to feed
            InkWell(
              onTap: () {}, // Back action
              child: Row(
                children: const [
                  Icon(Icons.arrow_back_ios, size: 16),
                  SizedBox(width: 6),
                  Text('Back to feed', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Technology tag and reliability score tag
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Technology',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.shade900,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.warning_amber_rounded, size: 14, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        '68%',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 12),

            // Title
            const Text(
              'Advances in automatic verification technology combat fake news',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 6),

            // Subtitle / summary
            const Text(
              'New AI algorithms can identify manipulated content with 98% accuracy.',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 12),

            // Author and date info
            Row(
              children: [
                const CircleAvatar(
                  radius: 12,
                  child: Icon(Icons.person, size: 16),
                  backgroundColor: Colors.grey,
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Verified author', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    SizedBox(height: 2),
                    Text('Tech Research Institute • January 15, 2025 at 05:30 AM',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                )
              ],
            ),
            const SizedBox(height: 16),

            // Share and bookmark icons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.share_outlined),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.bookmark_border),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.flag_outlined),
                  onPressed: () {},
                ),
              ],
            ),

            // Image placeholder (since no images to use)
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade300,
              ),
              alignment: Alignment.center,
              child: Image.network(
                'https://images.unsplash.com/photo-1663784294206-9b508132baf9?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHx0ZWNobm9sb2d5JTIwdmVyaWZpY2F0aW9ufGVufDF8fHx8MTc1NjkwMjk3N3ww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
                height: 80,
                width: double.infinity,
                fit: BoxFit.cover,
              ),  
            ),
            const SizedBox(height: 16),

            // Credibility Analysis Section
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.shield_outlined, size: 20),
                      SizedBox(width: 8),
                      Text('Credibility Analysis', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Reliability score text
                  Center(
                    child: Text(
                      '${reliabilityScore.toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Center(child: Text('Reliability score', style: TextStyle(fontSize: 12, color: Colors.black54))),
                  const SizedBox(height: 8),

                  // Reliability progress bar
                  LinearProgressIndicator(
                    value: reliabilityScore / 100,
                    backgroundColor: Colors.grey.shade300,
                    color: Colors.black,
                    minHeight: 7,
                  ),
                  const SizedBox(height: 12),

                  // Verified checks grid
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: const [
                      VerifiedCheck(text: 'Verified source'),
                      VerifiedCheck(text: 'Verified data'),
                      VerifiedCheck(text: 'Recognized author'),
                      VerifiedCheck(text: 'No manipulation'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Article full text
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '''Researchers have developed advanced artificial intelligence systems capable of detecting manipulated content, deepfakes and fake news with unprecedented 98% accuracy.
This advancement represents a significant milestone in the fight against digital misinformation, which has become one of the greatest challenges of our digital era. The new algorithms use deep learning techniques to analyze subtle patterns in images, videos and text that are imperceptible to the human eye.
Verification Methodology
The system employs multiple layers of analysis:
Metadata and source origin analysis
Detection of inconsistencies in images and videos
Cross-verification with reliable databases
Semantic analysis of textual content
Preliminary results show extraordinary effectiveness in identifying false content, which could revolutionize the way we consume information online.
Impact on Society
The implementation of this technology has the potential to restore public trust in digital information sources and protect citizens from malicious disinformation campaigns.''',
                style: TextStyle(fontSize: 14, height: 1.3),
              ),
            ),
            const SizedBox(height: 16),

            // Rate this article Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('% Rate this article', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),

                  const Text('How reliable do you find this information?', style: TextStyle(fontSize: 14)),
                  const SizedBox(height: 8),

                  // Reliability rating slider mimic (non-interactive)
                  Stack(
                    children: [
                      Container(
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: userReliabilityRating / 100,
                        child: Container(
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.orange.shade700,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                      Positioned(
                        left: (userReliabilityRating / 100) * MediaQuery.of(context).size.width - 36,
                        top: -8,
                        child: Text(
                          '${userReliabilityRating.toStringAsFixed(0)}%',
                          style: TextStyle(fontSize: 12, color: Colors.orange.shade700, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Moderately reliable',
                    style: TextStyle(fontSize: 12, color: Colors.orange),
                  ),
                  const SizedBox(height: 16),

                  // Comment input
                  TextField(
                    maxLines: 3,
                    maxLength: 500,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      labelText: 'Share your opinion (optional):',
                      hintText: 'Write your comment about the credibility of this article...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                      child: const Text('Submit rating'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Source information
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Source Information', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  const Text(
                    'Tech Research Institute',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const Text(
                    'Internationally recognized technology research institute',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 12),

                  SourceInfoRow(title: 'Founded:', value: '1995'),
                  SourceInfoRow(title: 'Location:', value: 'Madrid, Spain'),
                  SourceInfoRow(title: 'Type:', value: 'Academic institution'),
                  const SizedBox(height: 12),

                  ElevatedButton.icon(
                    onPressed: () {}, // Open source link
                    icon: const Icon(Icons.open_in_new, size: 18),
                    label: const Text('View original source'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      minimumSize: const Size.fromHeight(36),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Comments Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Comments (18)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  CommentWidget(
                    userName: 'Anonymous user',
                    userComment:
                        "Excellent article. It's reassuring to know that tools exist to combat misinformation. The research seems very solid and well-documented.",
                    timeAgo: '2 hours ago',
                    ratingPercent: 92,
                    ratingColor: Colors.green,
                  ),
                  const SizedBox(height: 12),
                  CommentWidget(
                    userName: 'Anonymous user',
                    userComment:
                        "When will this technology be available to the general public? The information seems credible but needs more details about implementation.",
                    timeAgo: '4 hours ago',
                    ratingPercent: 75,
                    ratingColor: Colors.orange,
                  ),
                  const SizedBox(height: 12),
                  CommentWidget(
                    userName: 'Anonymous user',
                    userComment:
                        "This sounds too good to be true. 98% accuracy seems exaggerated and there are no specific details about the testing methodology.",
                    timeAgo: '6 hours ago',
                    ratingPercent: 25,
                    ratingColor: Colors.red,
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text('View all comments'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),

      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book_outlined), label: 'Guide'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
        currentIndex: 0, // update as needed
        onTap: (int index) {
          // navigation logic here
        },
        elevation: 8,
      ),
    );
  }
}

class VerifiedCheck extends StatelessWidget {
  final String text;
  const VerifiedCheck({required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.check_circle_outline, color: Colors.green, size: 18),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}

class SourceInfoRow extends StatelessWidget {
  final String title;
  final String value;
  const SourceInfoRow({required this.title, required this.value, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: const TextStyle(fontSize: 14), textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }
}

class CommentWidget extends StatelessWidget {
  final String userName;
  final String userComment;
  final String timeAgo;
  final int ratingPercent;
  final Color ratingColor;

  const CommentWidget({
    required this.userName,
    required this.userComment,
    required this.timeAgo,
    required this.ratingPercent,
    required this.ratingColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const CircleAvatar(radius: 16, backgroundColor: Colors.grey, child: Icon(Icons.person, size: 16)),
            const SizedBox(width: 8),
            Text(userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: ratingColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$ratingPercent%',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            )
          ],
        ),
        const SizedBox(height: 6),
        Text(userComment, style: const TextStyle(fontSize: 14), maxLines: 5, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 4),
        Text(timeAgo, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}