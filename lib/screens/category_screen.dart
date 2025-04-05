import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/category_bloc.dart';
import '../bloc/reels_bloc.dart';
import 'reels_screen.dart';
import '../services/firebase_service.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Category'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CategoryLoaded) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 60.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: state.categories.length,
                    itemBuilder: (context, index) => _buildGridItem(
                      context,
                      index,
                      state.categories[index],
                      state.selectedIndex == index,
                    ),
                    padding: const EdgeInsets.all(12.0),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state.selectedIndex != null
                            ? () => _navigateToReelsScreen(context)
                            : () => _showAlertDialog(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: state.selectedIndex != null
                              ? Colors.green
                              : Colors.grey,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 15,
                          ),
                        ),
                        child: const Text('Submit',
                            style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text('No categories available'));
        },
      ),
    );
  }

  Widget _buildGridItem(
    BuildContext context,
    int index,
    String categoryName,
    bool isSelected,
  ) {
    return Card(
      elevation: 15.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255),
            ],
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: InkWell(
          onTap: () => context.read<CategoryBloc>().add(SelectCategory(index)),
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: ClipOval(
                          child: Image.asset(
                            'images/reel.png',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          categoryName,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isSelected)
                const Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Icon(Icons.check_circle, color: Colors.green),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Alert"),
          content: const Text("Please select one category"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _navigateToReelsScreen(BuildContext context) {
    final categoryState = context.read<CategoryBloc>().state;
    if (categoryState is CategoryLoaded &&
        categoryState.selectedIndex != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => ReelsBloc(FirebaseService())
              ..add(LoadReels(
                  categoryState.categories[categoryState.selectedIndex!])),
            child: const ReelsScreen(),
          ),
        ),
      );
    }
  }
}
