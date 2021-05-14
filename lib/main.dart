import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grid_images_bloc_test/bloc/bloc.dart';
import 'package:grid_images_bloc_test/bloc/event.dart';
import 'package:grid_images_bloc_test/bloc/state.dart';
import 'package:grid_images_bloc_test/home_page.dart';
import 'package:grid_images_bloc_test/image_page.dart';
import 'package:grid_images_bloc_test/repository/repository.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar:
              PreferredSize(preferredSize: Size.fromHeight(0), child: AppBar()),
          body: BlocProvider<ImageBloc>(
            create: (context) =>
                ImageBloc(InitialState(), repository: Repository())
                  ..add(FetchEvent()),
            child: Scaffold(
              body: HomePage(),
            ),
          )),
      onGenerateRoute: (setting) {
        if (setting.name == ImagePage.routeName) {
          return MaterialPageRoute(
              builder: (context) => ImagePage(
                    imageUrl: setting.arguments as String,
                  ));
        }
      },
    );
  }
}
