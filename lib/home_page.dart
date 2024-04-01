import 'package:animate_do/animate_do.dart';
import 'package:chat_gen_ai_app/feature_box.dart';
import 'package:chat_gen_ai_app/openai_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final flutterTts = FlutterTts();
  String? generatedContent;
  String? genneratedImageUrl;
  final OpenAIService openAIService = OpenAIService();
  String? lastWords;
  final speechToText = SpeechToText();
  int start = 200;
  int delay = 200;

  @override
  void initState() {
    super.initState();
    initSpeechToText();
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: BounceInDown(
          child: const Text(
            'Chat Champ',
            style: TextStyle(fontFamily: 'Cera Pro'),
          ),
        ),
        centerTitle: true,
        leading: const Icon(Icons.menu),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: ZoomIn(
                child: Stack(
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white60,
                      ),
                    ),
                    const CircleAvatar(
                      backgroundImage: AssetImage(
                          'assets/images/robot-removebg-preview.png'),
                      radius: 79,
                    ),
                  ],
                ),
              ),
            ),
            FadeInRight(
              child: Visibility(
                visible: genneratedImageUrl == null,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 40).copyWith(
                    top: 30,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white60),
                    color: Colors.white60,
                    borderRadius: BorderRadius.circular(20).copyWith(
                      topLeft: Radius.zero,
                    ),
                  ),
                  child: generatedContent == null
                      ? const Text(
                          'Welcome to Chat Champ, how may I help you?',
                          style:
                              TextStyle(fontFamily: 'Cera Pro', fontSize: 15),
                        )
                      : Text(
                          generatedContent.toString(),
                          style: const TextStyle(
                            fontFamily: 'Cera Pro',
                          ),
                        ),
                ),
              ),
            ),
            if (genneratedImageUrl != null)
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    genneratedImageUrl!,
                    scale: 0.5,
                  ),
                ),
              ),
            SlideInLeft(
              child: Visibility(
                visible: generatedContent == null && genneratedImageUrl == null,
                child: const Padding(
                  padding: EdgeInsets.only(left: 30, top: 24, bottom: 10),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Explore',
                      style: TextStyle(
                        fontFamily: 'Cera Pro',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: generatedContent == null && genneratedImageUrl == null,
              child: Column(
                children: [
                  SlideInLeft(
                    delay: Duration(milliseconds: start),
                    child: const FeatureBox(
                      color: Color.fromARGB(255, 149, 166, 229),
                      headerText: 'ChatGPT',
                      descriptionText:
                          'It is trained to follow an instruction in a prompt and provide a detailed response.',
                    ),
                  ),
                  SlideInLeft(
                    delay: Duration(milliseconds: start + delay),
                    child: const FeatureBox(
                      color: Color.fromRGBO(126, 107, 210, 1),
                      headerText: 'Dall-E',
                      descriptionText:
                          'It extends the capabilities of image generation by their input descriptions.',
                    ),
                  ),
                  SlideInLeft(
                    delay: Duration(milliseconds: start + 2 * delay),
                    child: const FeatureBox(
                      color: Color.fromARGB(255, 173, 187, 235),
                      headerText: 'Smart Assistant',
                      descriptionText:
                          'It extends the capabilities of image generation by their input descriptions.',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ZoomIn(
        delay: Duration(milliseconds: start + delay * 3),
        child: FloatingActionButton(
          onPressed: () async {
            if (await speechToText.hasPermission &&
                speechToText.isNotListening) {
              await startListening();
            } else if (speechToText.isListening) {
              final speech =
                  await openAIService.apiDecider(lastWords.toString());
              print(speech);
              if (speech.contains('https')) {
                genneratedImageUrl = speech;
                generatedContent = null;
                setState(() {});
              } else {
                generatedContent = speech;
                genneratedImageUrl = null;
                setState(() {});
                await systemSpeak(speech);
              }
              await stopListening();
            } else {
              initSpeechToText();
            }
          },
          backgroundColor: const Color.fromARGB(255, 149, 166, 229),
          child: speechToText.isListening == true
              ? const Icon(Icons.stop)
              : const Icon(
                  Icons.mic,
                  size: 30,
                ),
        ),
      ),
    );
  }
}
