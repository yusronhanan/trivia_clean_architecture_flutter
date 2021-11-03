// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:trivia_clean_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    Key? key,
  }) : super(key: key);

  @override
  State<TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  late String inputStr;
  final inputStrController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: inputStrController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              border: OutlineInputBorder(), hintText: "Input a number"),
          onChanged: (value) {
            inputStr = value;
          },
          onSubmitted: (_) {
            addConcrete();
          },
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            Expanded(
                child: ElevatedButton(
              onPressed: addConcrete,
              child: Text(
                'Search',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                  onPrimary: Theme.of(context).colorScheme.secondary),
            )),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: ElevatedButton(
              onPressed: addRandom,
              child: Text(
                'Get Random Trivia',
                style: TextStyle(color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(primary: Colors.grey),
            )),
          ],
        )
      ],
    );
  }

  void addConcrete() {
    inputStrController.clear();
    final numberTriviaBloc = context.read<NumberTriviaBloc>();
    numberTriviaBloc.add(GetTriviaForConcreteNumber(inputStr));
  }

  void addRandom() {
    inputStrController.clear();
    final numberTriviaBloc = context.read<NumberTriviaBloc>();
    numberTriviaBloc.add(GetTriviaForRandomNumber());
  }
}
