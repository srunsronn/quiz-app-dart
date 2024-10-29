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
      "What is what?", ["1. Hello", "2. Hello 2", "3. Hello 3", "4. Hello 4"], 4));
  q.addQuestion(MultipleAnswers(
      "Find x where x+3=0?", ["1. x=3", "2. x=4", "3. x=-3", "4. x=-3"], [3, 4]));

  // Participant input
  print(AnsiStyles.cyan("Enter First Name: "));
  String? firstName = stdin.readLineSync();
  print(AnsiStyles.cyan("Enter Last Name: "));
  String? lastName = stdin.readLineSync();
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
    selectedAnswers.sort();
    correctAnswers.sort();
    return selectedAnswers.length == correctAnswers.length &&
        selectedAnswers.every((answer) => correctAnswers.contains(answer));
  }
}
