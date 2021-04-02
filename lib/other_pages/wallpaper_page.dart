import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';
import 'package:wantsbucks/other_pages/loading.dart';

class WallpaperPage extends StatefulWidget {
  final String wallpaperUrl;
  WallpaperPage({this.wallpaperUrl});

  @override
  _WallpaperPageState createState() => _WallpaperPageState();
}

class _WallpaperPageState extends State<WallpaperPage> {
  bool _settingWallpaper = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Set wallpaper"),
      ),
      body: _settingWallpaper
          ? Loading()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                      padding: EdgeInsets.all(8),
                      child: Image.network(
                        widget.wallpaperUrl,
                        fit: BoxFit.cover,
                      )),
                ),
                ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _settingWallpaper = true;
                      });
                      int home = WallpaperManager.HOME_SCREEN;
                      var file = await DefaultCacheManager()
                          .getSingleFile(widget.wallpaperUrl);

                      try {
                        await WallpaperManager.setWallpaperFromFile(
                            file.path, home);
                        setState(() {
                          _settingWallpaper = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Wallpaper is set successfully!")));
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Error setting the wallpaper!")));
                      }
                    },
                    child: Text("Set As Wallpaper"))
              ],
            ),
    );
  }
}
