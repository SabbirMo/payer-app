// lib/data/bible_data.dart

class BibleStory {
  final String id;
  final String title;
  final String reference;
  final String story;
  final String lesson;
  final String emoji;
  final String category;

  const BibleStory({
    required this.id,
    required this.title,
    required this.reference,
    required this.story,
    required this.lesson,
    required this.emoji,
    required this.category,
  });
}

class BibleVerse {
  final String verse;
  final String reference;
  final String theme;

  const BibleVerse({
    required this.verse,
    required this.reference,
    required this.theme,
  });
}

final List<BibleStory> bibleStories = [
  BibleStory(
    id: '1',
    title: 'Noah and the Ark',
    reference: 'Genesis 6-9',
    emoji: '🚢',
    category: 'Old Testament',
    story: '''Long ago, God saw that people on earth were doing many bad things. But Noah was a good man who loved God with all his heart.\n\nGod told Noah: "Build a great big boat called an ark. Make it 300 cubits long, 50 cubits wide, and 30 cubits tall." Noah trusted God and obeyed, even when his neighbors laughed at him.\n\nThen God told Noah to bring two of every animal — lions, elephants, giraffes, birds, and even tiny bugs — into the ark. Noah's family came too.\n\nFor 40 days and 40 nights, rain poured down. The whole earth was covered with water. But Noah, his family, and all the animals were safe inside the ark.\n\nWhen the waters went down, God put a beautiful rainbow in the sky as a promise: "I will never flood the whole earth again." The rainbow is still God's promise to us today!''',
    lesson: 'Trust God even when things seem impossible. He protects those who love Him.',
  ),
  BibleStory(
    id: '2',
    title: 'David and Goliath',
    reference: '1 Samuel 17',
    emoji: '⚔️',
    category: 'Old Testament',
    story: '''There was a giant named Goliath — 9 feet tall! He wore heavy armor and carried a huge spear. Every day he challenged the Israelite soldiers: "Send me your best fighter!" Everyone was afraid.\n\nBut young David, a shepherd boy, said: "I will fight him! God helped me protect my sheep from lions and bears. He will help me now too!"\n\nKing Saul tried to put heavy armor on David, but David said no. He went to a stream and picked up 5 smooth stones. With his sling and one stone — WHOOSH! — the stone hit Goliath right in the forehead. The giant fell down!\n\nThe whole army cheered. David proved that with God, even a small boy can do mighty things!''',
    lesson: 'With God on your side, you are never too small to face big challenges.',
  ),
  BibleStory(
    id: '3',
    title: 'Jesus Feeds 5,000',
    reference: 'John 6:1-14',
    emoji: '🐟',
    category: 'New Testament',
    story: '''One day, 5,000 people followed Jesus to hear Him teach. When evening came, everyone was hungry — but there was no food!\n\nA young boy came forward with his lunch: just 5 small loaves of bread and 2 little fish. It seemed like nothing compared to 5,000 hungry people.\n\nBut Jesus took the food, looked up to heaven, and said thank you to God. Then He broke the bread and fish and gave it to His disciples to hand out.\n\nAmazingly, everyone ate until they were full! When they gathered the leftover pieces, there were 12 full baskets! Jesus had turned a small boy\'s lunch into a feast for thousands.\n\nThe people said: "This must truly be the Prophet sent by God!"''',
    lesson: 'When we give what little we have to Jesus, He can do miracles with it.',
  ),
  BibleStory(
    id: '4',
    title: 'The Good Samaritan',
    reference: 'Luke 10:25-37',
    emoji: '🤝',
    category: 'New Testament',
    story: '''Jesus told this story: A man was walking from Jerusalem to Jericho when robbers attacked him. They took everything and left him hurt on the road.\n\nA priest came by, saw the man, and walked to the other side. Then a temple helper came — he also walked away.\n\nFinally, a Samaritan came. In those days, Samaritans and Jews didn\'t get along. But this Samaritan stopped! He cleaned the man\'s wounds, put him on his donkey, took him to an inn, and paid for his care. He even said, "If it costs more, I will pay you when I return."\n\nJesus asked: "Which one was a true neighbor?" The answer was the one who showed kindness.\n\n"Go and do the same," Jesus said.''',
    lesson: 'Love your neighbor — anyone who needs your help is your neighbor.',
  ),
  BibleStory(
    id: '5',
    title: 'The Prodigal Son',
    reference: 'Luke 15:11-32',
    emoji: '🏃',
    category: 'New Testament',
    story: '''A father had two sons. The younger one said, "Give me my share of the money now!" He took the money and went far away, where he wasted it all on foolish living.\n\nSoon he had nothing. He was so hungry he wanted to eat the food he was feeding to pigs! Then he remembered home. "Even my father\'s servants eat well. I will go home and say I\'m sorry — I don\'t deserve to be his son anymore."\n\nWhile he was still far away, his father SAW him coming. He ran to meet him, hugged him, and threw a big party!\n\nThe older brother was upset: "I always obeyed and you never threw me a party!" The father said, "Son, everything I have is yours. But your brother was lost, and now he\'s found. We have to celebrate!"''',
    lesson: 'God is like that father — He runs to welcome us home when we turn back to Him.',
  ),
  BibleStory(
    id: '6',
    title: 'Moses Parts the Red Sea',
    reference: 'Exodus 14',
    emoji: '🌊',
    category: 'Old Testament',
    story: '''The Israelites were finally free from Egypt! But Pharaoh changed his mind and sent his whole army with 600 chariots to chase them.\n\nThe Israelites reached the Red Sea — water in front, army behind! They were terrified and cried out to Moses.\n\nMoses said: "Don\'t be afraid! Stand firm and watch what God will do today!"\n\nGod told Moses to raise his staff over the sea. A mighty wind blew all night, and the waters SPLIT apart! The Israelites walked through on dry ground, with walls of water on both sides.\n\nWhen Pharaoh\'s army tried to follow, the waters came crashing back together. The Israelites were safe on the other side, singing and dancing in praise to God!''',
    lesson: 'When you are surrounded by problems, God can make a way where there seems to be no way.',
  ),
  BibleStory(
    id: '7',
    title: 'The Birth of Jesus',
    reference: 'Luke 2:1-20',
    emoji: '⭐',
    category: 'New Testament',
    story: '''Long ago in Bethlehem, something wonderful happened. Mary and Joseph had traveled far, but every inn was full. The only place they could stay was a stable — a place for animals.\n\nThere, among the hay and animals, baby Jesus was born! Mary wrapped Him in soft cloths and laid Him in a manger.\n\nIn the fields nearby, shepherds were watching their sheep at night. Suddenly, a bright angel appeared! The shepherds were terrified.\n\n"Don\'t be afraid!" the angel said. "I bring you good news of great joy! Today in Bethlehem, a Savior has been born — Christ the Lord!"\n\nThen the whole sky filled with angels singing: "Glory to God in the highest!"\n\nThe shepherds ran to find baby Jesus. When they saw Him, they told everyone what the angels had said. Mary kept all these things in her heart.''',
    lesson: 'Jesus came for everyone — from powerful kings to simple shepherds. He is a gift for all.',
  ),
  BibleStory(
    id: '8',
    title: 'Daniel in the Lion\'s Den',
    reference: 'Daniel 6',
    emoji: '🦁',
    category: 'Old Testament',
    story: '''Daniel loved God so much that he prayed three times every day. But some jealous men made a law: "No one can pray to any god — only to the king!" If anyone disobeyed, they would be thrown to the lions.\n\nDaniel knew about the law — but he still opened his window and prayed to God, just like always.\n\nThe jealous men caught him and told the king. Even the king, who liked Daniel, had to follow his own law. Sadly, he had Daniel thrown into the den of hungry lions.\n\nThe king couldn\'t sleep all night. In the morning, he ran to the den and called out: "Daniel! Did your God save you?"\n\nDaniel\'s voice came back: "My God sent His angel to shut the lions\' mouths! I am safe!"\n\nThe king was overjoyed and told everyone in the kingdom: "Daniel\'s God is the living God!"''',
    lesson: 'Stay faithful to God even when it\'s hard. He will never abandon those who trust in Him.',
  ),
];

final List<BibleVerse> dailyVerses = [
  BibleVerse(
    verse: "For God so loved the world that he gave his one and only Son, that whoever believes in him shall not perish but have eternal life.",
    reference: "John 3:16",
    theme: "Love",
  ),
  BibleVerse(
    verse: "I can do all things through Christ who strengthens me.",
    reference: "Philippians 4:13",
    theme: "Strength",
  ),
  BibleVerse(
    verse: "The Lord is my shepherd; I shall not want.",
    reference: "Psalm 23:1",
    theme: "Peace",
  ),
  BibleVerse(
    verse: "Trust in the Lord with all your heart and lean not on your own understanding.",
    reference: "Proverbs 3:5",
    theme: "Faith",
  ),
  BibleVerse(
    verse: "Be strong and courageous. Do not be afraid; do not be discouraged, for the Lord your God will be with you wherever you go.",
    reference: "Joshua 1:9",
    theme: "Courage",
  ),
  BibleVerse(
    verse: "For I know the plans I have for you, declares the Lord, plans to prosper you and not to harm you, plans to give you hope and a future.",
    reference: "Jeremiah 29:11",
    theme: "Hope",
  ),
  BibleVerse(
    verse: "Come to me, all you who are weary and burdened, and I will give you rest.",
    reference: "Matthew 11:28",
    theme: "Rest",
  ),
  BibleVerse(
    verse: "Love is patient, love is kind. It does not envy, it does not boast, it is not proud.",
    reference: "1 Corinthians 13:4",
    theme: "Love",
  ),
  BibleVerse(
    verse: "The Lord is my light and my salvation — whom shall I fear?",
    reference: "Psalm 27:1",
    theme: "Courage",
  ),
  BibleVerse(
    verse: "Give thanks to the Lord, for he is good; his love endures forever.",
    reference: "Psalm 107:1",
    theme: "Gratitude",
  ),
];

final List<Map<String, String>> prayers = [
  {
    'title': 'Morning Prayer',
    'time': 'Start your day with God',
    'emoji': '🌅',
    'prayer': '''Heavenly Father,\n\nThank You for this new day You have given me. As I rise this morning, I give You all my worries, fears, and plans. \n\nGuide my steps today. Let Your light shine through me so that others may see Your love. Give me wisdom in my decisions, patience in my trials, and joy in my heart.\n\nThank You for Your mercies that are new every morning. I trust You with this day.\n\nIn Jesus' name, Amen. 🙏'''
  },
  {
    'title': 'Evening Prayer',
    'time': 'Rest in His arms tonight',
    'emoji': '🌙',
    'prayer': '''Dear Lord,\n\nThank You for walking with me through this day. Forgive me for the moments I fell short. I am grateful for Your grace that covers all my mistakes.\n\nAs I lay down to rest, I surrender everything to You. Watch over my family and loved ones tonight. Bring peace to troubled hearts and healing to the sick.\n\nThank You for Your faithful love that never ends. I rest safely in Your care.\n\nIn Jesus' name, Amen. 🙏'''
  },
  {
    'title': 'Prayer for Children',
    'time': 'Bless the little ones',
    'emoji': '👶',
    'prayer': '''Lord Jesus,\n\nI bring the children before You today. You said let the little ones come to You, for theirs is the Kingdom of Heaven.\n\nProtect them from harm and danger. Guide their young minds toward truth and goodness. Surround them with Your angels. Help them grow in wisdom, in stature, and in favor with God and people.\n\nBless especially the newborns and babies — so precious and new. Hold them gently in Your hands, Lord.\n\nIn Jesus' name, Amen. 🙏'''
  },
  {
    'title': 'Prayer for Strength',
    'time': 'When you feel weak',
    'emoji': '💪',
    'prayer': '''Father God,\n\nI am tired and weak today. The burdens feel heavy and I don\'t know how to carry on. But I remember Your Word says that when I am weak, You are strong.\n\nRenew my strength like the eagle. Help me run and not grow weary. Let Your Spirit lift me up above my circumstances.\n\nI choose to trust You even when I don\'t understand. You are my refuge and strength, an ever-present help in trouble.\n\nIn Jesus' name, Amen. 🙏'''
  },
  {
    'title': 'Prayer for Family',
    'time': 'Bless your household',
    'emoji': '👨‍👩‍👧‍👦',
    'prayer': '''Heavenly Father,\n\nI lift up my family to You today. You know every need, every hurt, every dream within our home.\n\nBind us together with cords of love that cannot be broken. Bring healing where there is pain, forgiveness where there is hurt, and joy where there is sorrow.\n\nMay our home be a place where Your presence dwells. Let us love one another as You have loved us.\n\nProtect each member of my family — the young ones, the elderly, and everyone in between.\n\nIn Jesus' name, Amen. 🙏'''
  },
  {
    'title': 'Prayer of Gratitude',
    'time': 'Count your blessings',
    'emoji': '🙏',
    'prayer': '''Thank You, Lord,\n\nFor breath in my lungs and a beating heart. For food on my table and a roof over my head. For family, for friends, for the beauty of Your creation.\n\nThank You for sending Jesus, for the forgiveness of sins, and for the hope of eternal life. Thank You that Your mercies are new every morning.\n\nHelp me never to take Your blessings for granted. Keep my heart grateful in every season — in abundance and in need.\n\nYou are so good, Lord. Thank You.\n\nIn Jesus' name, Amen. 🙏'''
  },
];
