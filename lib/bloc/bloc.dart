import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grid_images_bloc_test/bloc/event.dart';
import 'package:grid_images_bloc_test/bloc/state.dart';
import 'package:grid_images_bloc_test/models/model.dart';
import 'package:grid_images_bloc_test/repository/repository.dart';
import 'package:http/http.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final Repository repository;
  int page = 1;
  bool isFetching = false;

  ImageBloc(ImageState initialState, {required this.repository})
      : super(initialState);

  @override
  Stream<ImageState> mapEventToState(ImageEvent event) async* {
    if (event is FetchEvent && page <= 10) {
      final response = await repository.getImages(page: page);
      if (response is Response) {
        if (response.statusCode == 200) {
          final List<dynamic> images = jsonDecode(response.body);
          yield LoadedState(
              images: images.map((json) => Model.fromJson(json)).toList());
          page++;
        } else {
          yield ErrorState(errorMessage: response.body);
        }
      } else if (response is String) {
        yield ErrorState(errorMessage: response);
      }
    } else {
      yield LoadedState(images: []);
    }
  }
}
