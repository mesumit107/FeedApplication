
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'dart:async';
import 'package:flutter/services.dart';

import 'package:percent_indicator/percent_indicator.dart';

// Entry point of the application
void main() {
  runApp(MyApp());
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(
        title: "FeedApp",
      ), 
      theme: ThemeData(
        fontFamily: 'popines',
      ),
    );
  }
  
}

// State class for MyHomePage
class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  // Simulates a loading process for 3 seconds
  void _startLoading() {
    Timer(const Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
      _navigateToNextScreen();
    });
  }

  // Navigates to the CategoryPage, replacing the current page
  void _navigateToNextScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const CategoryPage(), 
      ),
    );
  }

  @override
  // Builds the UI for MyHomePage
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ?  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   CircularPercentIndicator(
                                radius: 100.0,
                                lineWidth: 10.0,
                                percent: 1.0, // Set to 1 for full circle
                                center:  CircleAvatar(
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
            : const Text('Welcome to the Category list'),
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

  Widget _buildGridItem(BuildContext context, int index,
      ) {
    String imageName = 'Fish ${index + 1}';
    String imagePath = 'images/reel.png';

    // Check if this item is selected
    bool isSelected = _selectedItems.contains(index);

    return Card(
      elevation: 15.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 255, 255, 255), // Light color
              Color.fromARGB(255, 255, 255, 255) // Slightly darker color
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
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                            ),
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
      appBar: AppBar( 
        title: const Text('Category List'),
      ),
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
                         _navigateToNextHomePageScreen(context,);

                        }
                      : () {
                         _showAlertDialog(context);
                      },
                   
                    style: ElevatedButton.styleFrom(
                    backgroundColor: _isSubmitButtonEnabled
                        ? Colors.green
                        : Colors.grey, // Change color based on selection
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(fontSize: 18),
                  ),
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

class _HomePageScreenState extends State<HomePageScreen>  {
  late PageController _pageController;
  List<String> videoPaths = [
    'https://live-par-2-abr.livepush.io/vod/bigbuckbunnyclip.mp4',
    'https://live-par-2-abr.livepush.io/vod/bigbuckbunnyclip.mp4',
    'https://live-par-2-abr.livepush.io/vod/bigbuckbunnyclip.mp4',
    'https://live-par-2-abr.livepush.io/vod/bigbuckbunnyclip.mp4',
    'https://live-par-2-abr.livepush.io/vod/bigbuckbunnyclip.mp4',
    
  ];
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return WillPopScope(
      onWillPop: () async {
        // Handle back button press to navigate back to CategoryPage using pushReplacement
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CategoryPage()),
        );
          return false;
      },
      child: SafeArea(
      child: Scaffold(
           body: PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: videoPaths.length,
            onPageChanged: (index) {
               setState(() {
                  _currentPage = index;
                });

            },
            itemBuilder: (context, index) {
              return VideoPlayerWidget(videoPath: videoPaths[index]);
            },
          ),
        ),
      ),
    );
  }
}


class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;

  const VideoPlayerWidget({super.key, required this.videoPath});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
   late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  final int _maxVideoDurationInSeconds = 30; 

  @override
  void initState() {
    super.initState();
      _videoPlayerController = widget.videoPath.startsWith('http')
        ? VideoPlayerController.networkUrl(Uri.parse(widget.videoPath))
        : VideoPlayerController.asset(widget.videoPath);
   // ignore: avoid_single_cascade_in_expression_statements
   _videoPlayerController 
      ..initialize()
        .catchError((error) {
          print("Error initializing video: $error");
        })
        .then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        if (mounted) {
        setState(() {});
        }

        // Limit video playback to 30 seconds
        Future.delayed(Duration(seconds: _maxVideoDurationInSeconds), () {
          if (_videoPlayerController.value.isPlaying) {
            _videoPlayerController.pause();
          }
        });
      });

       _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
      allowFullScreen: true,
      allowMuting: true,
      showControls: true,
      placeholder: Container(
          color: Colors.black,
        ),
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.white,
        handleColor: Colors.white,
      ),
      
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _videoPlayerController.value.isInitialized
          ? AspectRatio(
              aspectRatio: _videoPlayerController.value.aspectRatio,
              child: Chewie(
              controller: _chewieController,
            ),
          )
          : const CircularProgressIndicator(),
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
            TextButton(onPressed:()=> Navigator.of(context).pop() , child: const Text("OK"))
          ],
        );
      },
    );
  }

  void _navigateToNextHomePageScreen(BuildContext context,) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePageScreen()),
    );
}
