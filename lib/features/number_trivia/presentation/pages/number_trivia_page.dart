// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_clean_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:trivia_clean_architecture/features/number_trivia/presentation/widgets/widgets.dart';
import 'package:trivia_clean_architecture/injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
      ),
      body: SingleChildScrollView(child: buildBody(context)),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NumberTriviaBloc>(),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            BlocConsumer<NumberTriviaBloc, NumberTriviaState>(
              listener: (context, state) {
                if (state is NumberTriviaError) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                if (state is NumberTriviaInitial) {
                  return MessageDisplay(
                    message: "Start Searching!",
                  );
                } else if (state is NumberTriviaLoading) {
                  return LoadingWidget();
                } else if (state is NumberTriviaLoaded) {
                  return TriviaDisplay(
                    numberTrivia: state.trivia,
                  );
                } else {
                  return Container();
                }
              },
            ),
            SizedBox(
              height: 20,
            ),
            TriviaControls(),
          ],
        ),
      ),
    );
  }
}
