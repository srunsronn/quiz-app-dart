import 'dart:io';

void main(List<String> args) {
  Quiz q = Quiz();

  q.addQuestion(SingleAnswer("What is what?",
      ["1. Hello", "2. Hello 2", "3. Hello 3", "4. Hello 4"], 4));

  q.addQuestion(MultipleAnswers("Find x where x+3=0?",
      ["1. x=3", "2. x=4", "3. x=-3", "4. x=-3"], [3, 4]));
  print("Enter First Name: ");
  String? firstName = stdin.readLineSync();
  print("Enter Last Name: ");
  String? lastName = stdin.readLineSync();
  Participant p = Participant(firstName, lastName);
  q.addParticipant(p);

  print(q);

  for (var question in q.questions) {
    print("Q1 ${question.title}");

    //display option
    for (int i = 0; i < question.optionAnswers.length; i++) {
      print("${question.optionAnswers[i]}");
    }

    if (question is SingleAnswer) {
      print("Enter your answer: ");
      int selectedAns = int.parse(stdin.readLineSync()!);
      if (selectedAns == question.correctAnswer) {
        print("correct");
      }
    } else if (question is MultipleAnswers) {
      print("Enter your answer: ");
      List<String> selectedAns = stdin.readLineSync()!.split(", ").toList();

      print("selectedAns ${selectedAns}");
      var r = question.correctAnswers;
      print(r);
      if (selectedAns == r) {
        print("Correct answer");
      }
    }
  }
}

class Participant {
  String? firstName;
  String? lastName;

  //Participant();
  Participant(this.firstName, this.lastName);

  @override
  String toString() {
    return "$firstName $lastName";
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

  @override
  String toString() {
    return participants.map((part) => part.toString()).join(", ");
  }
}

class Question {
  String title;
  List<String> optionAnswers;

  Question(this.title, this.optionAnswers);

  //method
  // bool isCorrectAnswer(List<int> selectedAnswers) {
  //   return false;
  // }

  @override
  String toString() {
    return "$title $optionAnswers ";
  }
}

class SingleAnswer extends Question {
  int correctAnswer;
  SingleAnswer(super.title, super.optionAnswers, this.correctAnswer);

  @override
  bool isCorrectAnswer(List<int> selectedAnswers) {
    return selectedAnswers[0] == correctAnswer;
  }
}

class MultipleAnswers extends Question {
  List<int> correctAnswers;
  MultipleAnswers(super.title, super.optionAnswers, this.correctAnswers);

  // @override
  // bool isCorrectAnswer(List<int> selectedAnswer) {
  //   selectedAnswer.sort();
  //   correctAnswers.sort();

  // }
}
