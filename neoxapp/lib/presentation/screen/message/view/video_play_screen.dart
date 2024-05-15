import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:neoxapp/core/theme_color.dart';
import 'package:neoxapp/core/widget.dart';
import 'package:video_player/video_player.dart';

class VideoPlayScreen extends StatefulWidget {
  final String? url;
  const VideoPlayScreen({Key? key, this.url}) : super(key: key);

  @override
  State<VideoPlayScreen> createState() => _VideoPlayScreenState();
}

class _VideoPlayScreenState extends State<VideoPlayScreen> {
  late VideoPlayerController videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;
  late final player = Player();
  late final controller = VideoController(player);
  @override
  void initState() {
    super.initState();
    player.open(Media(widget.url ?? ""));

    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.url ?? ""))..initialize().then((value) => setState(() {}));
    _customVideoPlayerController = CustomVideoPlayerController(
        context: context,
        videoPlayerController: videoPlayerController,
        customVideoPlayerSettings: const CustomVideoPlayerSettings(
          controlBarAvailable: true,
          settingsButtonAvailable: true,
          customAspectRatio: 0.52,
        ));
  }

  double getCustomAspectRatio() {
    return (MediaQuery.of(context).size.width + 100) / (MediaQuery.of(context).size.height + 100);
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("====>>>${(MediaQuery.of(context).size.width + 100) / (MediaQuery.of(context).size.height + 100)}");
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          title: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Row(
              children: [
                const SizedBox(width: 10),
                Icon(
                  Icons.arrow_back_ios_rounded,
                  size: 20,
                  color: AppColors.colorFFFFFF,
                ),
                const SizedBox(width: 10),
                getCustomFont(
                  "Back",
                  15,
                  AppColors.colorFFFFFF,
                  1,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.start,
                )
              ],
            ).paddingOnly(top: 20),
          ),
        ),
        backgroundColor: AppColors.colorBlack,
        body: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            // height: MediaQuery.of(context).size.width * 9.0 / 16.0,
            // Use [Video] widget to display video output.
            child: Video(controller: controller),
          ),
        ),
      ),
    );
  }
}
