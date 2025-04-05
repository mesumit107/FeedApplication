import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class LoadCategories extends CategoryEvent {}

class SelectCategory extends CategoryEvent {
  final int index;

  const SelectCategory(this.index);

  @override
  List<Object> get props => [index];
}

// States
abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<String> categories;
  final int? selectedIndex;

  const CategoryLoaded({
    required this.categories,
    this.selectedIndex,
  });

  @override
  List<Object> get props => [categories, selectedIndex ?? -1];
}

// Bloc
class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryInitial()) {
    on<LoadCategories>(_onLoadCategories);
    on<SelectCategory>(_onSelectCategory);
  }

  Future<void> _onLoadCategories(
      LoadCategories event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    // Simulate loading categories
    await Future.delayed(const Duration(milliseconds: 500));
    final categories = List.generate(20, (index) => 'Category ${index + 1}');
    emit(CategoryLoaded(categories: categories));
  }

  void _onSelectCategory(SelectCategory event, Emitter<CategoryState> emit) {
    if (state is CategoryLoaded) {
      final currentState = state as CategoryLoaded;
      emit(CategoryLoaded(
        categories: currentState.categories,
        selectedIndex: event.index,
      ));
    }
  }
}
