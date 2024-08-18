import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({Key? key}) : super(key: key);

  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  List<String> messages = [];
  String? selectedTopic;
  String? selectedQuestion;
  String? selectedAnswer;

  final Map<String, Map<String, String>> topicQuestions = {
    'Exercise': {
      'How often should I exercise?': 'You should exercise at least 3-4 times per week.',
      'What are some good exercises for beginners?': 'Some good exercises for beginners include walking, jogging, and body weight exercises.',
      'How can I improve my running endurance?': 'To improve your running endurance, try incorporating interval training and gradually increasing your mileage.',
      'When do i expect to see a change ?': 'Changes vary, but you might notice improvements in mood and energy within weeks, while visible changes in fitness or weight may take longer, often a few months.',
      'I always feel exhausted while exercising': 'Feeling exhausted during exercise could be due to various factors like inadequate rest, nutrition, or hydration. Ensure you\'re getting enough sleep and fueling your body properly.',
      'Should i exercise while i feel sore ?': 'It\'s generally safe to exercise while feeling sore, but listen to your body. If the soreness is mild, you can continue with lighter exercise, but if it\'s severe, consider giving your body time to recover.',
      'What should i do in my rest days ?': 'Rest days are essential for recovery. Engage in light activities like walking, yoga, or stretching to promote blood flow and muscle relaxation.',
      'I feel pain while exercising, what should i do': 'If you feel pain while exercising, stop and assess the cause. It could be due to improper form, overexertion, or an underlying issue. Consult a fitness professional if the pain persists.',
      'How can i prevent injury during exercise?': 'To prevent injury, warm up before exercising, use proper form, gradually increase intensity, wear appropriate gear, and listen to your body\'s signals to avoid overexertion.',
      'Should i do cardio ?': 'Cardio can be beneficial for heart health, calorie burning, and overall fitness. Incorporate it into your routine based on your goals and preferences.'
    },
    'Supplements': {
      'Which supplements should I take for muscle gain?': 'For muscle gain, consider taking protein powder, creatine, and branched-chain amino acids (BCAAs).',
      'Are protein shakes necessary for building muscle?': 'While protein shakes can be convenient, they are not necessary for building muscle. You can also get protein from whole foods.',
      'What is creatine and do i need it ?': 'Creatine is a compound found naturally in muscle cells and is often used as a supplement to improve exercise performance, particularly during high-intensity, short-duration activities like weightlifting or sprinting. Whether you need it depends on your fitness goals and preferences.',
      'Do i need any supplements to be fit ?': 'Supplements are not necessary to be fit if you have a well-balanced diet that provides all the nutrients your body needs. However, certain supplements like vitamin D or omega-3 fatty acids may be beneficial if you have specific deficiencies or dietary restrictions.',
      'Do i need any pills to lose weight': 'Pills for weight loss are not recommended as a primary method for losing weight. Healthy weight loss is best achieved through a combination of regular exercise, a balanced diet, adequate sleep, and stress management. Consult a healthcare professional before considering weight loss pills, as they can have side effects and may not be effective long-term.',
      'Are there any specific supplements for muscle recovery?': 'Certain supplements like protein or BCAAs may aid recovery, but they\'re not essential if you have a balanced diet.',
      'Should I consider using BCAAs for muscle growth or recovery?': 'BCAAs can support muscle recovery, but they\'re not necessary for everyone. Prioritize protein-rich foods instead.'
    },
    'Nutrition': {
      'What should I eat before and after a workout?': 'Before a workout, focus on carbohydrates for energy and a small amount of protein. After a workout, aim for a combination of protein and carbohydrates to support muscle recovery.',
      'How can I make healthy eating a habit?': 'To make healthy eating a habit, plan your meals ahead of time, choose whole foods over processed foods, and listen to your body\'s hunger and fullness cues.',
      'What are some good sources of protein?': 'Good sources of protein include lean meats, poultry, fish, eggs, dairy products, legumes, nuts, and seeds.',
      'What is my daily recommendation for protein intake?': 'Daily protein intake recommendations vary but generally aim for around 0.8 to 1 gram of protein per kilogram of body weight.',
      'How many calories am i supposed to consume ?': 'Caloric needs depend on factors like age, gender, weight, activity level, and goals. Use a calorie calculator or consult a nutritionist to determine your specific requirements.',
      'How often should i cheat meal ?': 'There\'s no strict rule for cheat meals. Some people incorporate them once a week or on special occasions, but it\'s essential to maintain balance and moderation.',
      'How much water should I drink?': 'Aim to drink enough water to stay hydrated, typically around 8 glasses (about 2 liters) per day, but individual needs may vary based on factors like activity level and climate. Pay attention to your body\'s thirst cues.',
    },
    'Other': {
      'How important is sleep for muscle recovery?': 'Sleep is crucial for muscle recovery as it allows your body to repair and grow muscle tissue. Aim for 7-9 hours of quality sleep per night.',
      'What are the benefits of stretching?': 'Stretching can improve flexibility, reduce muscle tension, and decrease the risk of injury during exercise.',
      'How can I stay motivated to exercise?': 'To stay motivated to exercise, set realistic goals, vary your routine, find activities you enjoy, and enlist support from friends or a workout buddy.'
    },
  };

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    messages.add('Please select a topic for your question:');
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Timer(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    _scrollToBottom();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to the Chatbot'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final isUserMessage = messages[index].startsWith('User');
                String msg = messages[index];
                if (isUserMessage) {
                  msg = msg.replaceAll('User: ', '');
                }
                return ListTile(
                  title: Align(
                    alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: isUserMessage ? Color(0xE83A75F3) : const Color(0xCFF37F3A),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        msg,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 200,
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                if (selectedTopic == null)
                  ...topicQuestions.keys.map(
                        (topic) => GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTopic = topic;
                          messages.add('User: $selectedTopic');
                          messages.add('Please select a question:');
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 8.0),
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Color(0xE83A75F3),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            topic,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (selectedTopic != null && selectedQuestion == null)
                  ...topicQuestions[selectedTopic!]!.keys.map(
                        (question) => GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedQuestion = question;
                          selectedAnswer = topicQuestions[selectedTopic!]?[selectedQuestion!];
                          messages.add('User: $selectedQuestion');
                          messages.add('$selectedAnswer'); // Display the answer
                          messages.add('Do you have another question?');
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: const Color(0xE83A75F3),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            question,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (selectedQuestion != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Align buttons evenly in the row
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedTopic = null;
                                selectedQuestion = null;
                                selectedAnswer = null;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xE83A75F3),
                            ),
                            child: Text('Yes'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: ElevatedButton(
                            onPressed: () {
                              Future.delayed(const Duration(milliseconds: 200), () {
                                Navigator.of(context).pop();
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xCFF37F3A),
                            ),
                            child: Text('No, end chat'),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
