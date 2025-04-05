import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reels_viewer/reels_viewer.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'splash_screen.dart';

// Entry point of the application
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feed Application',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      home: const SplashScreen(),
    );
  }
}

class AppBloc extends Cubit<bool> {
  AppBloc() : super(true);
}

// StatefulWidget for the first page
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // Title for the page
  final String title;

  // Creates the mutable state for this widget
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// State class for MyHomePage
class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    _startLoading(context);
  }

  // Simulates a loading process for 3 seconds
  void _startLoading(BuildContext context) {
    Timer(const Duration(seconds: 3), () {
      context.read<AppBloc>().emit(false);
      _navigateToNextScreen(context);
    });
  }

  // Navigates to the CategoryPage, replacing the current page
  void _navigateToNextScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const CategoryPage()),
    );
  }

  @override
  // Builds the UI for MyHomePage
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, bool>(
      builder: (context, isLoading) {
        return _buildScaffold(isLoading);
      },
    );
  }

  Widget _buildScaffold(bool isLoading) {
    return Scaffold(
      body: Center(
        child: isLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularPercentIndicator(
                    radius: 100.0,
                    lineWidth: 10.0,
                    percent: 1.0, // Set to 1 for full circle
                    center: CircleAvatar(
                      radius: 80,
                      backgroundImage: AssetImage('images/reel.png'),
                    ),
                    progressColor: Colors.green,
                    backgroundColor: Colors.grey,
                    circularStrokeCap: CircularStrokeCap.round,
                    animation: true,
                    animationDuration: 4000,
                  ),
                ],
              )
            : const Text('Welcome to the Category list',
                style: TextStyle(fontSize: 20)),
      ),
    );
  }
}

// Stateful widget for the Category page
class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool _isSubmitButtonEnabled = false;

  // Keep track of selected item indexes
  final Set<int> _selectedItems = {};

  // Function to toggle the selection of an item
  void _toggleSelection(int index) {
    setState(() {
      if (_selectedItems.contains(index)) {
        _selectedItems.remove(index);
      } else {
        // Clear existing selections to allow only one item to be selected
        _selectedItems.clear();

        _selectedItems.add(index);
      }
      _isSubmitButtonEnabled = _selectedItems.isNotEmpty;
    });
  }

  Widget _buildGridItem(BuildContext context, int index) {
    String imageName = 'Fish ${index + 1}';
    String imagePath = 'images/reel.png';

    // Check if this item is selected
    bool isSelected = _selectedItems.contains(index);

    return Card(
      elevation: 15.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 255, 255, 255), // Light color
              Color.fromARGB(255, 255, 255, 255), // Slightly darker color
            ],
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: InkWell(
          onTap: () => _toggleSelection(index),
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
                            imagePath,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          imageName,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Category List')),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 60.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: 20,
              itemBuilder: (context, index) {
                return _buildGridItem(context, index);
              },
              cacheExtent: 20.0, // Adjust cache extent for lazy loading
              // Add a key to the list to preserve the scroll position
              key: const PageStorageKey<String>('CategoryPageList'),
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
                  onPressed: _isSubmitButtonEnabled
                      ? () {
                          //clear the  _selectedItems for next time
                          _selectedItems.clear();
                          _isSubmitButtonEnabled = false;
                          _navigateToNextHomePageScreen(context);
                        }
                      : () {
                          _showAlertDialog(context);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isSubmitButtonEnabled
                        ? Colors.green
                        : Colors.grey, // Change color based on selection
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 15,
                    ),
                  ),
                  child: const Text('Submit', style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget for the Home Page Screen
class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  List<ReelModel> reelsList = [
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
        ReelCommentModel(
          comment: 'Superr...',
          userProfilePic:
              'https://opt.toiimg.com/recuperator/img/toi/m-69257289/69257289.jpg',
          userName: 'Darshan',
          commentTime: DateTime.now(),
        ),
        ReelCommentModel(
          comment: 'Great...',
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
    return ReelsViewer(
      reelsList: reelsList,
      appbarTitle: 'Instagram Reels',
      onShare: (url) {
        // log('Shared reel url ==> $url');
      },
      onLike: (url) {
        //log('Liked reel url ==> $url');
      },
      onFollow: () {
        // log('======> Clicked on follow <======');
      },
      onComment: (comment) {
        //log('Comment on reel ==> $comment');
      },
      onClickMoreBtn: () {
        // log('======> Clicked on more option <======');
      },
      onClickBackArrow: () {
        //log('======> Clicked on back arrow <======');
      },
      onIndexChanged: (index) {
        //log('======> Current Index ======> $index <========');
      },
      showProgressIndicator: true,
      showVerifiedTick: true,
      showAppbar: true,
    );
  }
}

void _showAlertDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Alert"),
        content: const Text("Please select one list item"),
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

void _navigateToNextHomePageScreen(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const HomePageScreen()),
  );
}
