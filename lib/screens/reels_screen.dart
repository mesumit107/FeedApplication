import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reels_viewer/reels_viewer.dart';
import '../bloc/reels_bloc.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return BlocBuilder<ReelsBloc, ReelsState>(
      builder: (context, state) {
        if (state is ReelsLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is ReelsLoaded) {
          return ReelsViewer(
            reelsList: state.reels,
            appbarTitle: 'Feed Reels',
            onShare: (url) {
              // Handle share
            },
            onLike: (url) {
              context.read<ReelsBloc>().add(LikeReel(url));
            },
            onFollow: () {
              // Handle follow
            },
            onComment: (comment) {
              // Handle comment
            },
            onClickMoreBtn: () {
              // Handle more button
            },
            onClickBackArrow: () {
              Navigator.pop(context);
            },
            onIndexChanged: (index) {
              // Handle index change
            },
            showProgressIndicator: true,
            showVerifiedTick: true,
            showAppbar: true,
          );
        }
        return const Scaffold(
          body: Center(child: Text('No reels available')),
        );
      },
    );
  }
}
