// lib/data/wallpapers_data.dart

class Wallpaper {
  final String title;
  final String verse;
  final String reference;
  final String category;
  final String emoji;
  final String gradientType; // used for generating wallpaper colors

  const Wallpaper({
    required this.title,
    required this.verse,
    required this.reference,
    required this.category,
    required this.emoji,
    required this.gradientType,
  });
}

final List<Wallpaper> wallpapers = [
  // NATURE + VERSE
  Wallpaper(title: 'Mountain Sunrise', verse: 'I lift my eyes to the mountains — where does my help come from? My help comes from the Lord.', reference: 'Psalm 121:1-2', category: 'Nature', emoji: '⛰️', gradientType: 'sunrise'),
  Wallpaper(title: 'Ocean of Grace', verse: 'Your love, Lord, reaches to the heavens, your faithfulness to the skies.', reference: 'Psalm 36:5', category: 'Nature', emoji: '🌊', gradientType: 'ocean'),
  Wallpaper(title: 'Forest Morning', verse: 'The earth is the Lord\'s, and everything in it, the world, and all who live in it.', reference: 'Psalm 24:1', category: 'Nature', emoji: '🌲', gradientType: 'forest'),
  Wallpaper(title: 'Golden Sunset', verse: 'This is the day the Lord has made; let us rejoice and be glad in it.', reference: 'Psalm 118:24', category: 'Nature', emoji: '🌅', gradientType: 'sunset'),
  Wallpaper(title: 'Starry Night', verse: 'He determines the number of the stars and calls them each by name.', reference: 'Psalm 147:4', category: 'Nature', emoji: '⭐', gradientType: 'night'),
  Wallpaper(title: 'Still Waters', verse: 'He makes me lie down in green pastures, he leads me beside quiet waters.', reference: 'Psalm 23:2', category: 'Nature', emoji: '🌿', gradientType: 'green'),
  Wallpaper(title: 'Rainbow Promise', verse: 'I have set my rainbow in the clouds, and it will be the sign of the covenant.', reference: 'Genesis 9:13', category: 'Nature', emoji: '🌈', gradientType: 'rainbow'),
  Wallpaper(title: 'Gentle Rain', verse: 'He sends rain on the righteous and the unrighteous.', reference: 'Matthew 5:45', category: 'Nature', emoji: '🌧️', gradientType: 'rain'),
  Wallpaper(title: 'Desert Bloom', verse: 'See, I am doing a new thing! Now it springs up; do you not perceive it?', reference: 'Isaiah 43:19', category: 'Nature', emoji: '🌸', gradientType: 'desert'),
  Wallpaper(title: 'Eagle Heights', verse: 'But those who hope in the Lord will renew their strength. They will soar on wings like eagles.', reference: 'Isaiah 40:31', category: 'Nature', emoji: '🦅', gradientType: 'sky'),
  Wallpaper(title: 'Autumn Glory', verse: 'For everything there is a season, and a time for every matter under heaven.', reference: 'Ecclesiastes 3:1', category: 'Nature', emoji: '🍂', gradientType: 'autumn'),
  Wallpaper(title: 'Winter Peace', verse: 'Peace I leave with you; my peace I give you.', reference: 'John 14:27', category: 'Nature', emoji: '❄️', gradientType: 'winter'),
  Wallpaper(title: 'Spring New Life', verse: 'Therefore, if anyone is in Christ, the new creation has come: The old has gone, the new is here!', reference: '2 Corinthians 5:17', category: 'Nature', emoji: '🌱', gradientType: 'spring'),
  Wallpaper(title: 'Garden of Eden', verse: 'The Lord God made all kinds of trees grow out of the ground — trees that were pleasing to the eye and good for food.', reference: 'Genesis 2:9', category: 'Nature', emoji: '🌺', gradientType: 'garden'),
  Wallpaper(title: 'Mighty River', verse: 'As the deer pants for streams of water, so my soul pants for you, my God.', reference: 'Psalm 42:1', category: 'Nature', emoji: '🏞️', gradientType: 'river'),

  // VERSE WALLPAPERS
  Wallpaper(title: 'God\'s Love', verse: 'For God so loved the world that he gave his one and only Son, that whoever believes in him shall not perish but have eternal life.', reference: 'John 3:16', category: 'Verse', emoji: '❤️', gradientType: 'love'),
  Wallpaper(title: 'I Can Do All Things', verse: 'I can do all this through him who gives me strength.', reference: 'Philippians 4:13', category: 'Verse', emoji: '💪', gradientType: 'gold'),
  Wallpaper(title: 'Jeremiah\'s Promise', verse: 'For I know the plans I have for you, declares the Lord, plans to prosper you and not to harm you, plans to give you hope and a future.', reference: 'Jeremiah 29:11', category: 'Verse', emoji: '🌟', gradientType: 'purple'),
  Wallpaper(title: 'Trust the Lord', verse: 'Trust in the Lord with all your heart and lean not on your own understanding; in all your ways submit to him, and he will make your paths straight.', reference: 'Proverbs 3:5-6', category: 'Verse', emoji: '🙏', gradientType: 'trust'),
  Wallpaper(title: 'Be Strong', verse: 'Be strong and courageous. Do not be afraid; do not be discouraged, for the Lord your God will be with you wherever you go.', reference: 'Joshua 1:9', category: 'Verse', emoji: '⚔️', gradientType: 'courage'),
  Wallpaper(title: 'Come to Me', verse: 'Come to me, all you who are weary and burdened, and I will give you rest.', reference: 'Matthew 11:28', category: 'Verse', emoji: '🕊️', gradientType: 'rest'),
  Wallpaper(title: 'Love One Another', verse: 'A new command I give you: Love one another. As I have loved you, so you must love one another.', reference: 'John 13:34', category: 'Verse', emoji: '💝', gradientType: 'pink'),
  Wallpaper(title: 'The Lord is My Shepherd', verse: 'The Lord is my shepherd, I lack nothing. He makes me lie down in green pastures.', reference: 'Psalm 23:1-2', category: 'Verse', emoji: '🐑', gradientType: 'pastoral'),
  Wallpaper(title: 'Fear Not', verse: 'So do not fear, for I am with you; do not be dismayed, for I am your God. I will strengthen you and help you.', reference: 'Isaiah 41:10', category: 'Verse', emoji: '🛡️', gradientType: 'shield'),
  Wallpaper(title: 'Seek First', verse: 'But seek first his kingdom and his righteousness, and all these things will be given to you as well.', reference: 'Matthew 6:33', category: 'Verse', emoji: '👑', gradientType: 'kingdom'),
  Wallpaper(title: 'New Mercies', verse: 'Because of the Lord\'s great love we are not consumed, for his compassions never fail. They are new every morning.', reference: 'Lamentations 3:22-23', category: 'Verse', emoji: '🌤️', gradientType: 'morning'),
  Wallpaper(title: 'Joy in the Lord', verse: 'Rejoice in the Lord always. I will say it again: Rejoice!', reference: 'Philippians 4:4', category: 'Verse', emoji: '🎉', gradientType: 'joy'),
  Wallpaper(title: 'Nothing Separates', verse: 'For I am convinced that neither death nor life, neither angels nor demons... will be able to separate us from the love of God.', reference: 'Romans 8:38-39', category: 'Verse', emoji: '∞', gradientType: 'eternal'),
  Wallpaper(title: 'Light of the World', verse: 'You are the light of the world. A town built on a hill cannot be hidden.', reference: 'Matthew 5:14', category: 'Verse', emoji: '💡', gradientType: 'light'),
  Wallpaper(title: 'Greater Is He', verse: 'You, dear children, are from God and have overcome them, because the one who is in you is greater than the one who is in the world.', reference: '1 John 4:4', category: 'Verse', emoji: '✝️', gradientType: 'victory'),
  Wallpaper(title: 'Armour of God', verse: 'Put on the full armor of God, so that you can take your stand against the devil\'s schemes.', reference: 'Ephesians 6:11', category: 'Verse', emoji: '⚔️', gradientType: 'armor'),
];
