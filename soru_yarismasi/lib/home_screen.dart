import 'package:flutter/material.dart';
import 'constants.dart';
import 'question_model.dart';
import 'question_widget.dart';
import 'next_button.dart';
import 'option_card.dart';
import 'result_box.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key?key}):super(key:key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Question> _questions=[
    Question(id: '1', title: '2023 Cannes Film Festivalinde En İyi Kadın Oyuncu olan ilk Türk Kadın Oyuncumuz kimdir?' , options: {'Özge Özpirinçci':false,'Merve Dizdar':true,'Bennu Yıldırımlar':false,'Filiz Akın':false}),
    Question(id: '2', title: 'Avrupa Kadınlar Voleybol Şampiyonasının en değerli oyuncusu(MVP) seçilen milli sporcumuz kimdir?', options: {'Zehra Güneş':false,'Saliha Şahin':false,'Gizem Örge':false,'Melissa Vargas':true}),
    Question(id: '3', title: '2023 Nobel Fizik Ödülü hangi bilim insanına verilmemiştir?', options: {'Pierre Agostini':false,'Ferenc Krausz':false,'Alain Aspect':true,'Anne LHuillier':false}),
    Question(id: '4', title: '2023 yılının en iyi şarkısı hangisi oldu?', options: {'Flowers':true,'As It Was':false,'Cruel Summer':false,'Calm Down':false})
  ];
  int index=0;
  int score=0;
  bool isPressed=false;
  bool isAlreadySelected=false;
  void nextQuestion(){
    if(index==_questions.length-1){
      showDialog(context: context,
          barrierDismissible: false,
          builder: (ctx)=>ResultBox(result: score,
      questionLength: _questions.length,
          onPressed: startOver,));
    }else{
      if(isPressed){
        setState(() {
          index++;
          isPressed=false;
          isAlreadySelected=false;
        });
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lütfen bir seçenek işaretleyin!'),behavior:
            SnackBarBehavior.floating,margin: EdgeInsets.symmetric(vertical: 20.0),)
        );
      }
    }
  }
  void checkAnswerAndUpdate(bool value){
    if(isAlreadySelected) {
      return;
    }else{
      if(value==true){
        score++;
      }
      setState(() {
        isPressed=true;
        isAlreadySelected=true;
      });
    }
  }
  void startOver(){
    setState(() {
      index=0;
      score=0;
      isPressed=false;
      isAlreadySelected=false;
    });
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Bilgi Cepte'),
        backgroundColor: background,
        shadowColor: Colors.transparent,
        actions: [
          Padding(padding: const EdgeInsets.all(18.0),child: Text('Puanınız: $score',
          style: const TextStyle(fontSize: 18.0),),)
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            QuestionWidget(indexAction: index,question: _questions[index].title,
            totalQuestions: _questions.length,),
            const Divider(color: neutral),
            const SizedBox(height: 25.0,),
            for(int i=0;i<_questions[index].options.length;i++)
              GestureDetector(
                onTap:()=>checkAnswerAndUpdate(_questions[index].options.values.toList()[i]),
                child: OptionCard(option: _questions[index].options.keys.toList()[i],
                color:isPressed? _questions[index].options.values.toList()[i]==true?
                  correct:incorrect:Colors.cyan,
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: NextButton(nextQuestion: nextQuestion,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
