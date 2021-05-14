import 'package:grid_images_bloc_test/models/model.dart';

abstract class ImageState {}

class InitialState extends ImageState {}

class LoadingState extends ImageState {}

class LoadedState extends ImageState {
  final List<Model> images;
  LoadedState({required this.images});
}

class ErrorState extends ImageState {
  final String errorMessage;
  ErrorState({required this.errorMessage});
}
