import 'dart:io';
import 'package:ansi_styles/ansi_styles.dart';

void main(List<String> args) {
  print(AnsiStyles.blue.bold(
      "📘  ========================================================="));
  print(AnsiStyles.blue.bold(
      "📘                  WELCOME TO THE QUIZ!                     "));
  print(AnsiStyles.blue.bold(
      "📘  =========================================================\n"));

  Quiz q = Quiz();

  // Adding questions to the quiz
  q.addQuestion(SingleAnswer(
      "What is 2+2?", ["1. 4", "2. 3", "3. 2", "4. 1"], 1));
  q.addQuestion(MultipleAnswers(
      "Find x where x+3=0?", ["1. x=3", "2. x=4", "3. x=-3", "4. x=-3"], [3, 4]));
  q.addQuestion(SingleAnswer("How many loop in programming?", ["1. 2","2. 3", "3. 1","4. 1"], 2));

  // Participant input
  // validate user input 
  // Regular expression to match only alphabetic characters (no numbers or special characters)
  final nameRegex = RegExp(r'^[a-zA-Z]+$');

  // Participant input
  String? firstName;
  while (firstName == null || !nameRegex.hasMatch(firstName)) {
    print(AnsiStyles.cyan("Enter First Name: "));
    firstName = stdin.readLineSync();
    if (firstName == null || !nameRegex.hasMatch(firstName)) {
      print(AnsiStyles.red("Invalid input. First Name should contain only letters."));
    }
  }

  String? lastName;
  while (lastName == null || !nameRegex.hasMatch(lastName)) {
    print(AnsiStyles.cyan("Enter Last Name: "));
    lastName = stdin.readLineSync();
    if (lastName == null || !nameRegex.hasMatch(lastName)) {
      print(AnsiStyles.red("Invalid input. Last Name should contain only letters."));
    }
  }
  Participant p = Participant(firstName, lastName);
  q.addParticipant(p);

  print(AnsiStyles.magenta("\nStarting the Quiz...\n"));

  // Iterating through questions
  int questionCount = 1;
  for (var question in q.questions) {
    print(AnsiStyles.yellow.bold("Q$questionCount: ${question.title}\n"));
    question.optionAnswers.forEach((option) => print("   $option"));
    questionCount++;

    if (question is SingleAnswer) {
      print(AnsiStyles.green("\nEnter your answer (e.g., 1): "));
      int selectedAns = int.parse(stdin.readLineSync()!);
      if (question.isCorrectAnswer(selectedAns)) {
        // update score 
        p.updateScore(1);
        print(AnsiStyles.green("Correct!\n"));
      } else {
        print(AnsiStyles.red("Incorrect.\n"));
      }
    } else if (question is MultipleAnswers) {
      print(AnsiStyles.green("\nEnter your answers, separated by commas (e.g., 1, 3): "));
      List<String> selectedAns = stdin.readLineSync()!.split(RegExp(r",\s*"));
      List<int> selected = selectedAns.map(int.parse).toList();

      if (question.isCorrectAnswer(selected)) {
        // update score for multiple answers
        p.updateScore(1);
        print(AnsiStyles.green("Correct!\n"));
      } else {
        print(AnsiStyles.red("Incorrect.\n"));
      }
    }
  }

  // Displaying final results in a tabular format
  print(AnsiStyles.blue.bold(
      "📘  ========================================================="));
  print(AnsiStyles.blue.bold(
      "|                          QUIZ RESULTS                     |"));
  print(AnsiStyles.blue.bold(
      "📘  ========================================================="));
  
  // Header with different color
  print(AnsiStyles.yellow.bold(
      "|    Participant                |     Score                 |"));
  print(AnsiStyles.blue.bold(
      "📘  ---------------------------------------------------------"));

  // Ensuring proper spacing and alignment for participant name and score
  String participantName = "${p.firstName ?? ''} ${p.lastName ?? ''}";
  String score = "${p.score}";

  // Use padRight for proper alignment
  print(
      "|    ${participantName.padRight(26)} |     ${score.padRight(21)} |"
  );
  print(AnsiStyles.blue.bold(
      "📘  =========================================================\n"));
}

class Participant {
  String? firstName;
  String? lastName;
  int score = 0;

  Participant(this.firstName, this.lastName);

  void updateScore(int pts) {
    score += pts;
  }
}

class Quiz {
  List<Participant> participants = [];
  List<Question> questions = [];

  void addParticipant(Participant participant) {
    participants.add(participant);
  }

  void addQuestion(Question question) {
    questions.add(question);
  }
}

class Question {
  String title;
  List<String> optionAnswers;

  Question(this.title, this.optionAnswers);
}

class SingleAnswer extends Question {
  int correctAnswer;

  SingleAnswer(super.title, super.optionAnswers, this.correctAnswer);

  bool isCorrectAnswer(int selectedAnswer) {
    return selectedAnswer == correctAnswer;
  }
}

class MultipleAnswers extends Question {
  List<int> correctAnswers;

  MultipleAnswers(super.title, super.optionAnswers, this.correctAnswers);

  bool isCorrectAnswer(List<int> selectedAnswers) {
    //we sort selectAnsers and CorrectAnswer for make have the same order of elements
    selectedAnswers.sort();
    //print("slecterAns Sort: $selectedAnswers");
    correctAnswers.sort();
    //print("slecterAns Sort: $correctAnswers");

    return selectedAnswers.length == correctAnswers.length &&
        // every function we use to check every elements in order. 
        selectedAnswers.every((answer) => correctAnswers.contains(answer));
  }
}
