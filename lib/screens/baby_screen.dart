// lib/screens/baby_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BabyScreen extends StatelessWidget {
  const BabyScreen({super.key});

  static const List<Map<String, dynamic>> babyContent = [
    {
      'emoji': '👶',
      'title': 'Welcome, Little One!',
      'subtitle': 'Prayers for Newborns',
      'color': Color(0xFFFF6B9D),
      'content': [
        {
          'title': 'Prayer for a Newborn',
          'text': '''Lord Jesus,\n\nWelcome this precious baby into the world You made. Thank You for the miracle of new life — so small, so perfect, so loved.\n\nProtect this little one from all harm. Surround them with Your angels. Bless their tiny hands and feet, their curious eyes, their gentle heart that is just beginning to know love.\n\nMay this child grow to know You, to love You, and to walk in Your ways all the days of their life.\n\nIn Jesus' name, Amen. 🙏''',
        },
        {
          'title': 'Prayer for New Parents',
          'text': '''Heavenly Father,\n\nThank You for entrusting this precious soul to these parents. Give them wisdom beyond their years. Grant them patience when the nights are long, strength when they are weary, and joy that overflows.\n\nMay they raise this child in the love and knowledge of You. Bless their family and fill their home with Your presence.\n\nIn Jesus' name, Amen. 🙏''',
        },
        {
          'title': 'Blessing for Baby',
          'text': '''May God bless you, little one,\nWith eyes that see His beauty,\nWith ears that hear His voice,\nWith hands that do His work,\nWith a heart that loves His people.\n\nMay the Lord bless you and keep you.\nMay His face shine upon you.\nMay He grant you peace all your days.\n\nNumbers 6:24-26 🌟''',
        },
      ],
    },
    {
      'emoji': '✝️',
      'title': 'Baby Baptism',
      'subtitle': 'Christening Traditions & Prayers',
      'color': Color(0xFF6B4EFF),
      'content': [
        {
          'title': 'What is Baptism?',
          'text': '''Baptism is one of the most important moments in a Christian\'s life. In baptism, a child is welcomed into the family of God and the Christian community.\n\nJesus himself was baptized by John in the Jordan River, and He commanded His followers: "Go and make disciples of all nations, baptizing them in the name of the Father, and of the Son, and of the Holy Spirit." (Matthew 28:19)\n\nFor babies, baptism is a gift of grace — parents and the church commit to raising the child in the faith.''',
        },
        {
          'title': 'Baptism Prayer',
          'text': '''Lord God,\n\nAs we bring this child to You in baptism, we make a promise: to raise them in Your love, to teach them Your Word, to show them Your ways.\n\nReceive this child into Your family. Place Your hand upon them. Fill them with Your Spirit from their earliest days.\n\nMay their baptism mark the beginning of a lifetime journey with You.\n\nIn Jesus' name, Amen. 🙏''',
        },
        {
          'title': 'Scripture for Baptism',
          'text': '''"Let the little children come to me, and do not hinder them, for the kingdom of heaven belongs to such as these."\n— Matthew 19:14\n\n"For you created my inmost being; you knit me together in my mother\'s womb. I praise you because I am fearfully and wonderfully made."\n— Psalm 139:13-14''',
        },
      ],
    },
    {
      'emoji': '🎀',
      'title': 'Baby Girl',
      'subtitle': 'She is a gift from God',
      'color': Color(0xFFFF8FAB),
      'content': [
        {
          'title': 'Prayer for a Baby Girl',
          'text': '''Lord,\n\nThank You for this precious daughter. She is fearfully and wonderfully made — crafted by Your hands with love and purpose.\n\nMay she grow to be a woman of strength and grace, like the virtuous woman of Proverbs 31. May she know her worth is not in the eyes of the world but in Your eyes.\n\nProtect her heart, her mind, and her future. Let her shine Your light wherever she goes.\n\nIn Jesus' name, Amen. 🙏''',
        },
        {
          'title': 'Bible Verse for Girls',
          'text': '''"She is clothed with strength and dignity, and she laughs without fear of the future."\n— Proverbs 31:25\n\n"The LORD your God is with you, the Mighty Warrior who saves. He will take great delight in you; in his love he will no longer rebuke you, but will rejoice over you with singing."\n— Zephaniah 3:17''',
        },
      ],
    },
    {
      'emoji': '💙',
      'title': 'Baby Boy',
      'subtitle': 'He is a mighty blessing',
      'color': Color(0xFF4EC9FF),
      'content': [
        {
          'title': 'Prayer for a Baby Boy',
          'text': '''Father God,\n\nThank You for this son. Like David and Daniel before him, may he grow to be a man after Your own heart.\n\nGive him courage to stand for what is right, wisdom to make good choices, and compassion to care for others. May he lead with love and serve with joy.\n\nProtect him from the enemy\'s schemes. Guide his steps. Let him walk in righteousness all the days of his life.\n\nIn Jesus' name, Amen. 🙏''',
        },
        {
          'title': 'Bible Verse for Boys',
          'text': '''"Be strong and courageous. Do not be afraid; do not be discouraged, for the LORD your God will be with you wherever you go."\n— Joshua 1:9\n\n"Even a young man is known by his actions, by whether his behavior is pure and upright."\n— Proverbs 20:11''',
        },
      ],
    },
    {
      'emoji': '🌟',
      'title': 'Baby Names',
      'subtitle': 'Beautiful Christian Names',
      'color': Color(0xFFD4A017),
      'content': [
        {
          'title': 'Christian Names for Girls',
          'text': '''✨ Grace — God\'s favor and blessing\n✨ Faith — Complete trust in God\n✨ Hope — Confident expectation in God\n✨ Joy — Delight that comes from God\n✨ Naomi — Pleasantness, sweetness\n✨ Ruth — Friend, companion\n✨ Esther — Star, hidden\n✨ Miriam — Beloved, wished-for\n✨ Abigail — Father\'s joy\n✨ Deborah — Bee, to speak kind words\n✨ Lydia — Noble woman\n✨ Mary — Beloved, loved by God''',
        },
        {
          'title': 'Christian Names for Boys',
          'text': '''✨ Elijah — My God is the Lord\n✨ Gabriel — God is my strength\n✨ Samuel — God has heard\n✨ David — Beloved\n✨ Joshua — God is salvation\n✨ Isaiah — God is salvation\n✨ Nathan — He gave\n✨ Caleb — Faithful, devoted\n✨ Ezra — Help\n✨ Micah — Who is like God?\n✨ Noah — Rest, comfort\n✨ Benjamin — Son of the right hand''',
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      appBar: AppBar(
        title: const Text('Baby Corner'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFFF6B9D).withOpacity(0.15),
                  const Color(0xFF6B4EFF).withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFFF6B9D).withOpacity(0.3),
              ),
            ),
            child: Column(
              children: [
                const Text('👶🙏✝️', style: TextStyle(fontSize: 40)),
                const SizedBox(height: 12),
                Text(
                  'Welcome, Little Blessing!',
                  style: GoogleFonts.cinzel(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '"Children are a gift from the Lord; they are a reward from him."\n— Psalm 127:3',
                  style: GoogleFonts.cormorantGaramond(
                    color: Colors.white70,
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          ...babyContent.map((section) {
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BabySectionScreen(section: section),
                ),
              ),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      (section['color'] as Color).withOpacity(0.15),
                      const Color(0xFF0F0F20),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: (section['color'] as Color).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      section['emoji'] as String,
                      style: const TextStyle(fontSize: 40),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            section['title'] as String,
                            style: GoogleFonts.cinzel(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            section['subtitle'] as String,
                            style: GoogleFonts.cormorantGaramond(
                              color: section['color'] as Color,
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: section['color'] as Color,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class BabySectionScreen extends StatelessWidget {
  final Map<String, dynamic> section;

  const BabySectionScreen({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    final contents = section['content'] as List<Map<String, String>>;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      appBar: AppBar(
        title: Text(section['title'] as String),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: contents.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Center(
                child: Text(
                  section['emoji'] as String,
                  style: const TextStyle(fontSize: 70),
                ),
              ),
            );
          }
          final content = contents[index - 1];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  (section['color'] as Color).withOpacity(0.1),
                  const Color(0xFF0F0F20),
                ],
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: (section['color'] as Color).withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content['title']!,
                  style: GoogleFonts.cinzel(
                    color: section['color'] as Color,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  content['text']!,
                  style: GoogleFonts.cormorantGaramond(
                    color: Colors.white,
                    fontSize: 17,
                    height: 1.8,
                    fontStyle: FontStyle.italic,
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
