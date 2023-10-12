import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gif_live_searcher/data/remote/dto/gif_data.dart';
import 'package:gif_live_searcher/utils/locator.dart';
import 'package:gif_live_searcher/utils/network_manager.dart';
import 'package:gif_live_searcher/utils/retainable_scroll.dart';
import 'package:gif_live_searcher/utils/theme_utils.dart';
import 'package:gif_live_searcher/widget/circular_loader.dart';

import 'bloc/home_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeCubit>(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView({Key? key}) : super(key: key);

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  late final RetainableScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = RetainableScrollController()..addListener(onScroll);
  }

  @override
  void dispose() {
    controller
      ..removeListener(onScroll)
      ..dispose();
    super.dispose();
  }

  void onScroll() {
    if (controller.position.maxScrollExtent - controller.position.pixels < 900) {
      context.read<HomeCubit>().add(const NextPageEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: BlocConsumer<HomeCubit, HomeState>(
            listener: (context, state) {
              state.maybeWhen(
                requestFailure: (type, _, __, ___) {
                  final String msg;
                  switch (type) {
                    case FailureType.noInternet:
                      msg = 'No internet';
                      break;
                    case FailureType.unknown:
                      msg = 'Unknown error';
                      break;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(msg),
                  ));
                  context.read<HomeCubit>().add(const HandledErrorEvent());
                },
                orElse: () => null,
              );
            },
            builder: (context, state) {
              return CustomScrollView(
                controller: controller,
                slivers: [
                  SliverAppBar(
                    floating: true,
                    backgroundColor: Colors.white70,
                    expandedHeight: 125,
                    flexibleSpace: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Center(
                        child: TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Search for ...',
                          ),
                          onChanged: (query) => context.read<HomeCubit>().add(InputEvent(query)),
                          enabled: state.maybeMap(paginationLoading: (_) => false, orElse: () => true),
                        ),
                      ),
                    ),
                  ),
                  _Content(state.gifs),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Content extends StatefulWidget {
  const _Content(this.data, {Key? key}) : super(key: key);

  final List<GifData> data;

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Text('No gifs are here'),
        ),
      );
    }
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return _Gif(widget.data[index]);
        },
        childCount: widget.data.length,
      ),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: screenWidth / 2, mainAxisExtent: screenWidth / 2),
    );
  }
}

class _Gif extends StatelessWidget {
  const _Gif(this.data, {Key? key}) : super(key: key);

  final GifData data;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: NetworkManager.combineGifUrl(data.id),
      fit: BoxFit.cover,
      progressIndicatorBuilder: (context, url, downloadProgress) => CircularLoader(
        loadingProgress: downloadProgress.progress,
      ),
      errorWidget: (_, __, ___) => const Text(
        '😞',
        textAlign: TextAlign.center,
      ),
    );
  }
}
