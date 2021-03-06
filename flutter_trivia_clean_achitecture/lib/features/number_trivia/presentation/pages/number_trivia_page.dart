import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_trivia_clean_achitecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_trivia_clean_achitecture/features/number_trivia/presentation/widgets/widgets.dart';
import 'package:flutter_trivia_clean_achitecture/injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
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
            const SizedBox(
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
                  return const MessageDisplay(
                    message: "Start Searching!",
                  );
                } else if (state is NumberTriviaLoading) {
                  return const LoadingWidget();
                } else if (state is NumberTriviaLoaded) {
                  return TriviaDisplay(
                    numberTrivia: state.trivia,
                  );
                } else {
                  return Container();
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            const TriviaControls(),
          ],
        ),
      ),
    );
  }
}
