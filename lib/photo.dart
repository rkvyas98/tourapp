import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';


class SimplePhotoView extends StatefulWidget {
  static const String id = 'simple';
  final String imag;
  final String img_tit;
  SimplePhotoView({Key key,this.imag,this.img_tit}): super(key: key);

  @override
  _SimplePhotoViewState createState() => _SimplePhotoViewState();
}

class _SimplePhotoViewState extends State<SimplePhotoView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(widget.img_tit),
            backgroundColor: Colors.black87
        ),
        backgroundColor: Colors.black87,
        body: PhotoView(

          imageProvider: NetworkImage(
            widget.imag,
          ),
          // Contained = the smallest possible size to fit one dimension of the screen
          minScale: PhotoViewComputedScale.contained * 0.8,
          // Covered = the smallest possible size to fit the whole screen
          maxScale: PhotoViewComputedScale.covered * 3,
          enableRotation: true,
          // Set the background color to the "classic white"
          backgroundDecoration: BoxDecoration(
            color: Colors.white10,
          ),
          loadFailedChild: Center(
            child: CircularProgressIndicator(),
          ),
        ),
    );
  }
}
