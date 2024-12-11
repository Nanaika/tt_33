import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tt33/bloc/mood_bloc.dart';
import 'package:tt33/pages/create_mood_page_view.dart';

class CreateMoodPage extends StatelessWidget {
  const CreateMoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MoodBloc(),
      child: Scaffold(
        body: CreateMoodPageView(),
      ),
    );
  }
}
