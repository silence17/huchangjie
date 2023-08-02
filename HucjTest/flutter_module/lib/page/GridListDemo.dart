// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import '../material_demo_types.dart';

// BEGIN gridListsDemo

class GridListDemo extends StatelessWidget {
  const GridListDemo({super.key, required this.type});

  final GridListDemoType type;

  List<_Photo> _photos(BuildContext context) {
    return [
      _Photo(
        assetName: 'assets/images/pic.jpg',
        title: 'l',
        subtitle: 'm',
      ),
      _Photo(
        assetName: 'assets/images/pic1.jpg',
        title: 'h',
        subtitle: 'i',
      ),
      _Photo(
        assetName: 'assets/images/pic2.jpg',
        title: 'e',
        subtitle: 'f',
      ),
      _Photo(
        assetName: 'assets/images/pic1.jpg',
        title: 'a',
        subtitle: 'b',
      ),
      _Photo(
        assetName: 'assets/images/pic3.jpg',
        title: 'c',
        subtitle: 'd',
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: Text('demoGridListsTitle'),
      // ),
      body: GridView.count(
        restorationId: 'grid_view_demo_grid_offset',
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        padding: const EdgeInsets.all(8),
        childAspectRatio: 1,
        children: _photos(context).map<Widget>((photo) {
          return _GridDemoPhotoItem(
            photo: photo,
            tileStyle: type,
          );
        }).toList(),
      ),
    );
  }
}

class _Photo {
  _Photo({
    required this.assetName,
    required this.title,
    required this.subtitle,
  });

  final String assetName;
  final String title;
  final String subtitle;
}

/// Allow the text size to shrink to fit in the space
class _GridTitleText extends StatelessWidget {
  const _GridTitleText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: AlignmentDirectional.centerStart,
      child: Text(text),
    );
  }
}

/*
 * item
 */
class _GridDemoPhotoItem extends StatelessWidget {
  final _Photo photo;
  final GridListDemoType tileStyle;

  const _GridDemoPhotoItem({
    required this.photo,
    required this.tileStyle,
  });

  @override
  Widget build(BuildContext context) {
    final Widget image = Semantics(
      label: '${photo.title} ${photo.subtitle}',
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        clipBehavior: Clip.antiAlias,
        child: GestureDetector(
          child: Image.asset(
            photo.assetName,
            // package: 'flutter_gallery_assets',
            fit: BoxFit.cover,
          ),
          onTap: () {
            if (photo.assetName.contains('pic2')) {
              Navigator.of(context).pushNamed('/eight');
            } else {
              Navigator.of(context).pushNamed('/nine');
            }
          },
        ),
      ),
    );

    switch (tileStyle) {
      case GridListDemoType.imageOnly:
        return image;
      case GridListDemoType.header:
        return GridTile(
          header: Material(
            color: Colors.red,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
            ),
            clipBehavior: Clip.antiAlias,
            child: GridTileBar(
              title: _GridTitleText(photo.title),
              backgroundColor: Colors.black45,
            ),
          ),
          child: image,
        );
      case GridListDemoType.footer:
        return GridTile(
          footer: Material(
            color: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(4)),
            ),
            clipBehavior: Clip.antiAlias,
            child: GridTileBar(
              backgroundColor: Colors.black45,
              title: _GridTitleText(photo.title),
              subtitle: _GridTitleText(photo.subtitle),
            ),
          ),
          child: image,
        );
    }
  }
}
