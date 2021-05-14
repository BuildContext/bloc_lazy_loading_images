import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grid_images_bloc_test/bloc/bloc.dart';
import 'package:grid_images_bloc_test/bloc/event.dart';
import 'package:grid_images_bloc_test/bloc/state.dart';
import 'package:grid_images_bloc_test/image_page.dart';
import 'package:grid_images_bloc_test/widgets/network_image_widget.dart';

import 'models/model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Model> _images = [];
  final ScrollController _scrollController = ScrollController();
  bool isFirstLoad = true;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageBloc = BlocProvider.of<ImageBloc>(context);
    return BlocConsumer<ImageBloc, ImageState>(
      listener: (BuildContext context, Object? state) {
        if (state is LoadedState && state.images.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("end of story"),
            duration: Duration(milliseconds: 700),
          ));
        }
      },
      builder: (BuildContext context, state) {
        if (state is InitialState || state is LoadingState && _images.isEmpty) {
          return Center(
              child: CircularProgressIndicator(
            backgroundColor: Colors.red,
          ));
        } else if (state is LoadedState) {
          _images.addAll(state.images);
          imageBloc.isFetching = false;
          if (isFirstLoad) {
            isFirstLoad = false;
            imageBloc
              ..isFetching = true
              ..add(FetchEvent());
          }
        } else if (state is ErrorState && _images.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  imageBloc
                    ..isFetching = true
                    ..add(FetchEvent());
                },
                icon: Icon(Icons.refresh),
              ),
              const SizedBox(height: 15),
              Text(state.errorMessage, textAlign: TextAlign.center),
            ],
          );
        }
        return OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            return CustomScrollView(
              controller: _scrollController
                ..addListener(() {
                  if (_scrollController.offset ==
                          _scrollController.position.maxScrollExtent &&
                      !imageBloc.isFetching) {
                    imageBloc
                      ..isFetching = true
                      ..add(FetchEvent());
                  }
                }),
              slivers: [
                SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return NetworkImageWidget(
                        imageUrl: _images[index].imageUrl,
                        toRoute: ImagePage.routeName);
                  }, childCount: _images.length),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        (orientation == Orientation.portrait) ? 3 : 5,
                    mainAxisSpacing: 50,
                  ),
                ),
                SliverToBoxAdapter(
                  child: state is LoadedState && state.images.isNotEmpty
                      ? Container(
                          height: 100,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : SizedBox.shrink(),
                )
              ],
            );
          },
        );
      },
    );
  }
}
