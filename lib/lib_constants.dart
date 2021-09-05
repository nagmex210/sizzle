import 'package:flutter/material.dart';

const Color kpurple = Color(0xFF3A2E78);
const Color kblue = Color(0xFF3BBEF0);
const Color kyellow = Color(0xFFFED214);
const Color kgreen = Color(0xFF45E0A2);

const kTextfieldecoration =InputDecoration(
  hintText: 'Enter your email',
  hintStyle: TextStyle( color: Colors.grey),
  contentPadding:
  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kpurple, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kpurple, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

const List<String> questionsRn1 = [
  'a',
  'b',
  'c',
  'd,',
  'e',
];
const List<String> questionsRn = [
  'How important do you think sex is to a relationship?',
  'How would define the "perfect" relationship?',
  'What\'s the ultimate dealbreaker in a relationship?',
  'How soon is too soon to meet the parents?',
  'How would you feel if I didn\'t like one of your friends?',
  'What have you done that makes you the proudest?',
  'Who was your biggest role model when you were growing up?',
  'Do you think it\'s better to make a lot of money in a job you hate or make less money in a job you love?',
  'What scares you most?',
  'How important is family to you?',
  'What does equality look like to you?',
  'Do you think cheating is a dealbreaker or do you believe it can be worked through?',
  'How do you define success?',
  'How often do you question your decisions?',
  'Do you judge people before you get to know them?',
  'What social issues are most important to you?',
  'Do you have any regrets?',
  'What do you dream about?',
  'If we could be together anywhere right now, where would it be?',
  'What is one word that describes how you’re feeling right now?',
  'Have you ever cheated on a boyfriend or girlfriend because you just couldn’t help yourself?',
  'AAAAAADo you have a go-to masturbation fantasy?',
  'When’s the last time you had a vivid sex dream?',
  'Have you ever had a naughty dream about a close friend or family member?',
  'What’s the dirtiest text you’ve ever sent or received?',
  'What makes you feel good?',
  'Dog or cat person ?',
  'Something you can say both in traffic and bed',
  'Something you can say both at hospital and bed',
  'What\'s your spirit animal',
  'What\'s your idea of a romantic evening',
  'How do you impress a date\'s parents',
  'If  you could be anyone in this world, who would you be ?',
  'Describe yourself in 3 words',
  'What\'s your favorite drink?',
  'What\'s your most bizzare talent',
  'What are you known for?',
  'How many times have you fell in love?',
  'What\'s the stupidest thing you have ever done?',
  'What\'s one song you really relate to?',
  'What has been your biggest accomplishment in life?',
  'Do you have any nicknames please state if you have one?',
  'Do you have aby special talents',
  'If you just won 1 million dollars what would you do with it?',
  'Were ross and rachel on a break?',
  'Which 3 people would you invite to a dinner party (dead or alive)?',
  'What would your superpower be',
  'What would be your superhero name',
  'Favorite beer?',
  'Favorite drink?',
  'Whats your body count?',
  'Whats your dream job',
  'Favorite pokemon character?',
  'Whats your favorite series',
  'Whats your favorite movie?',
  'Whats your favorite restaurant?',
  'Whats expensive but totally worth it',
  'Who is your favorite character from a tv show',
  'Who is your favorite character from a movie',
  'What\'s your favorite smell',
  'What\'s your favorite food',
  'Where would you like to retire?',
  'Which vaccine would you prefer?',
  'What\'s your favorite holiday',
  'Where would you like to go on a vacation',
  'What\'s the most spontaneous thing you have ever done',
  'What do you never get tired of',
  'How many social media followers do you have',
  'Whats your favorite quote',
  'What took you way too long to figure out',
  'What\'s your favorite book',
  'What bullet have you recently dodged',
  'What\'s the perfect way to ask someone out?',
  'If we went on a date, what would we do ?',
  'Describe yourself with 3 words',
  'Are you more drawn to brains or looks?',
  'Whats your passion',
  'What excites you',
  'What would you name your child',
  'Who is your celebrity crush',
  'Whats your worst pickup line you have ever used',
  'Would you go for money or love and why?',
  'Favorite artist?',
  'What\'s the biggest turn on ?',
  'What tattoo would you get?',
  'What do you value in a relationship?',
  'Which team do you support',
  'How long did your last relationship last?',
  'How long dou you last in bed',
  'What kind of memories dou you want to make together?',
  'What kind of outfit would you like to see me in',
  'Where would we get married',
  'What is your type?',
  'What would you like to know about me?',
  'What\'s a sexual act you have never done, but want to try?',
  'Do you have any fantasies, kinks, or fetishes you\'d like to share and/or indulge in?',
  'What sort of role play would turn you on most?',
  'Have you ever wanted to role-play?',
  'Would you ever use bondage?',
  'What is one outfit you’d like to see me in?',
  'At what age did you lose your virginity?',
  'How many people have you slept with?',
  'Do you have any secret fantasies?',
  'What is your favorite position?',
  'Have you ever done it in a public place?',
  'Do you want to do it in a public place?',
  'Would you rather possess good looks or intelligence?',
  'What position do you like the most?',
  'What position would you like to try the next time we make love?',
  'What’s your dirtiest fantasy?',
  'What gets you turned on the fastest?',
  'Have you ever fantasized about fucking one of your teachers?',
  'What kind of porn turns you on?',
  'What’s a fantasy that you’ve always been curious about?',

];



const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Color(0xFFF2101C), width: 2.0),
  ),
);

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFF2101C), width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFF2101C), width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

const kSendButtonTextStyle = TextStyle(
  color: Color(0xFFF2101C),
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);




// level 2 sorular azgın 20 li yaşlarında kişiler için vardır bu srulardan bazıları asıl hedef kitlemiz için olan soru bandına girebilir fakat genelde bu kategoriden
// 1 soru kafidi