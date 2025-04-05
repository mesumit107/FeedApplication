import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:reels_viewer/reels_viewer.dart';

// Events
abstract class ReelsEvent extends Equatable {
  const ReelsEvent();

  @override
  List<Object> get props => [];
}

class LoadReels extends ReelsEvent {}

class LikeReel extends ReelsEvent {
  final String url;

  const LikeReel(this.url);

  @override
  List<Object> get props => [url];
}

// States
abstract class ReelsState extends Equatable {
  const ReelsState();

  @override
  List<Object> get props => [];
}

class ReelsInitial extends ReelsState {}

class ReelsLoading extends ReelsState {}

class ReelsLoaded extends ReelsState {
  final List<ReelModel> reels;

  const ReelsLoaded(this.reels);

  @override
  List<Object> get props => [reels];
}

// Bloc
class ReelsBloc extends Bloc<ReelsEvent, ReelsState> {
  ReelsBloc() : super(ReelsInitial()) {
    on<LoadReels>(_onLoadReels);
    on<LikeReel>(_onLikeReel);
  }

  Future<void> _onLoadReels(LoadReels event, Emitter<ReelsState> emit) async {
    emit(ReelsLoading());
    // Simulate loading reels
    await Future.delayed(const Duration(milliseconds: 500));
    final reels = [
      ReelModel(
        'https://opt.toiimg.com/recuperator/img/toi/m-69257289/69257289.jpg',
        'Darshan Patil',
        likeCount: 2000,
        isLiked: true,
        musicName: 'In the name of Love',
        reelDescription: "Life is better when you're laughing.",
        profileUrl:
            'https://opt.toiimg.com/recuperator/img/toi/m-69257289/69257289.jpg',
        commentList: [
          ReelCommentModel(
            comment: 'Nice...',
            userProfilePic:
                'https://opt.toiimg.com/recuperator/img/toi/m-69257289/69257289.jpg',
            userName: 'Darshan',
            commentTime: DateTime.now(),
          ),
        ],
      ),
      ReelModel(
        'https://assets.mixkit.co/videos/preview/mixkit-mother-with-her-little-daughter-eating-a-marshmallow-in-nature-39764-large.mp4',
        'Rahul',
        musicName: 'In the name of Love',
        reelDescription: "Life is better when you're laughing.",
        profileUrl:
            'https://opt.toiimg.com/recuperator/img/toi/m-69257289/69257289.jpg',
      ),
    ];
    emit(ReelsLoaded(reels));
  }

  void _onLikeReel(LikeReel event, Emitter<ReelsState> emit) {
    if (state is ReelsLoaded) {
      final currentState = state as ReelsLoaded;
      // Handle like action
      emit(ReelsLoaded(currentState.reels));
    }
  }
}
