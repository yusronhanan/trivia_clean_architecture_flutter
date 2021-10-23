import 'package:trivia_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  const NumberTriviaModel({required String text, required int number})
      : super(text: text, number: number);

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    return NumberTriviaModel(
        text: json['text'],
        number: (json['number'] as num)
            .toInt()); //num is either double or int. accept both
  }
  Map<String, dynamic> toJson() {
    return {'text': text, 'number': number};
  }
}
