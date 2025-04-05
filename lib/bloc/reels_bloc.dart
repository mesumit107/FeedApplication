import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:reels_viewer/reels_viewer.dart';
import '../services/firebase_service.dart';

// Events
abstract class ReelsEvent extends Equatable {
  const ReelsEvent();

  @override
  List<Object> get props => [];
}

class LoadReels extends ReelsEvent {
  final String category;
  const LoadReels(this.category);
}

class LikeReel extends ReelsEvent {
  final String reelId;
  const LikeReel(this.reelId);
}

// States
abstract class ReelsState extends Equatable {
  const ReelsState();

  @override
  List<Object> get props => [];
}

class ReelsLoading extends ReelsState {}

class ReelsLoaded extends ReelsState {
  final List<ReelModel> reels;
  const ReelsLoaded(this.reels);
}

class ReelsError extends ReelsState {
  final String message;
  const ReelsError(this.message);
}

// Bloc
class ReelsBloc extends Bloc<ReelsEvent, ReelsState> {
  final FirebaseService _firebaseService;

  ReelsBloc(this._firebaseService) : super(ReelsLoading()) {
    on<LoadReels>(_onLoadReels);
    on<LikeReel>(_onLikeReel);
  }

  Future<void> _onLoadReels(LoadReels event, Emitter<ReelsState> emit) async {
    try {
      emit(ReelsLoading());

      _firebaseService.getReelsByCategory(event.category).listen((snapshot) {
        final reels = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return ReelModel(
            data['videoUrl'] ?? '',
            data['title'] ?? 'Unknown',
            likeCount: data['likes'] ?? 0,
            musicName: data['musicName'] ?? '',
            reelDescription: data['description'] ?? '',
            profileUrl: data['profileUrl'] ?? '',
          );
        }).toList();
        emit(ReelsLoaded(reels));
      });
    } catch (e) {
      emit(ReelsError(e.toString()));
    }
  }

  Future<void> _onLikeReel(LikeReel event, Emitter<ReelsState> emit) async {
    try {
      await _firebaseService.likeReel(event.reelId);
    } catch (e) {
      emit(ReelsError(e.toString()));
    }
  }
}
