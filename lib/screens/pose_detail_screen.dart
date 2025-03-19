import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../models/pose.dart';

class PoseDetailScreen extends StatefulWidget {
  final Pose pose;

  PoseDetailScreen({required this.pose});

  @override
  _PoseDetailScreenState createState() => _PoseDetailScreenState();
}

class _PoseDetailScreenState extends State<PoseDetailScreen> {
  late YoutubePlayerController _controller;
  bool _isReadMore = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.pose.youtubeVideoId,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: true,
        forceHD: false,
        hideControls: false,
        hideThumbnail: false,
        disableDragSeek: false,
        loop: false,
        controlsVisibleAtStart: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Parse steps from description
    List<String> steps = [];
    if (widget.pose.description.contains("STEPS - ")) {
      String stepsText = widget.pose.description.replaceAll("STEPS - ", "");
      steps = stepsText.split('\n').where((step) => step.trim().isNotEmpty).toList();
    } else {
      steps = widget.pose.description.split('\n').where((step) => step.trim().isNotEmpty).toList();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Custom app bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    widget.pose.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.favorite_border_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      // Add favorite functionality later
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Added to favorites"),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Theme.of(context).colorScheme.primary,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Video player with decorative elements
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                          ),
                          child: YoutubePlayer(
                            controller: _controller,
                            showVideoProgressIndicator: true,
                            progressIndicatorColor: Theme.of(context).colorScheme.primary,
                            progressColors: ProgressBarColors(
                              playedColor: Theme.of(context).colorScheme.primary,
                              handleColor: Theme.of(context).colorScheme.primary,
                            ),
                            onReady: () {
                              print('YouTube Player is ready for ${widget.pose.name}');
                            },
                            onEnded: (data) {
                              // Video ended
                            },
                            thumbnail: Image.asset(
                              widget.pose.imageUrl,
                              fit: BoxFit.cover,
                              height: 220,
                            ),
                          ),
                        ),
                        // Decorative elements
                        Positioned(
                          bottom: -30,
                          left: -30,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).colorScheme.tertiary.withOpacity(0.1),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    // Pose details
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title and image
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.pose.name,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    widget.pose.imageUrl,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          SizedBox(height: 20),
                          
                          // Benefits
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.spa_rounded,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Benefits",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        _getBenefits(widget.pose.name),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          SizedBox(height: 24),
                          
                          // Steps title
                          Text(
                            "Step-by-Step Instructions",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          
                          SizedBox(height: 16),
                          
                          // Steps
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _isReadMore ? steps.length : min(5, steps.length),
                            itemBuilder: (context, index) {
                              String step = steps[index];
                              // Remove numbering if present
                              if (RegExp(r'^\d+\.').hasMatch(step)) {
                                step = step.replaceFirst(RegExp(r'^\d+\.\s*'), '');
                              }
                              
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 4),
                                      width: 22,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          "${index + 1}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        step,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey.shade800,
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          
                          // Read more button if needed
                          if (steps.length > 5)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isReadMore = !_isReadMore;
                                });
                              },
                              child: Text(
                                _isReadMore ? "Show Less" : "Read More",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  String _getBenefits(String poseName) {
    // Return benefits based on pose name
    Map<String, String> poseBenefits = {
      "Mountain Pose": "Improves posture, strengthens thighs, ankles, and core, relieves sciatica.",
      "Downward Facing Dog": "Strengthens arms and legs, stretches shoulders and hamstrings, energizes the body.",
      "Warrior Pose": "Builds strength in legs and core, improves focus and balance, opens hips and chest.",
      "Tree Pose": "Improves balance and concentration, strengthens ankles and calves, opens hips.",
      "Tree With Arm Up": "Enhances balance, stretches side body, strengthens core and legs, improves focus.",
      "Pyramid Pose": "Stretches hamstrings and spine, calms the mind, improves digestion.",
      "Triangle Pose": "Stretches legs, hips and spine, relieves stress, improves digestion.",
      "Bow Pose": "Opens chest and shoulders, strengthens back muscles, improves posture.",
      "Half Moon Pose": "Improves balance, strengthens ankles, legs, and core, opens hips and chest.",
    };
    
    return poseBenefits[poseName] ?? "Improves flexibility, strength, and mental focus.";
  }
  
  int min(int a, int b) {
    return a < b ? a : b;
  }
}
