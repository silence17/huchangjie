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
        assetName: 'places/india_chettinad_silk_maker.png',
        title: 'l',
        subtitle: 'm',
      ),
      _Photo(
        assetName: 'places/india_chettinad_produce.png',
        title: 'h',
        subtitle: 'i',
      ),
      _Photo(
        assetName: 'places/india_tanjore_market_technology.png',
        title: 'e',
        subtitle: 'f',
      ),
      _Photo(
        assetName: 'places/india_pondicherry_beach.png',
        title: 'a',
        subtitle: 'b',
      ),
      _Photo(
        assetName: 'places/india_pondicherry_fisherman.png',
        title: 'c',
        subtitle: 'd',
      ),
      _Photo(
        assetName: 'places/india_pondicherry_fisherman.png',
        title: 'c342',
        subtitle: 'd',
      ),
      _Photo(
        assetName: 'places/india_pondicherry_fisherman.png',
        title: 'g3423',
        subtitle: 'd',
      ),
      _Photo(
        assetName: 'places/india_pondicherry_fisherman.png',
        title: 'j2342',
        subtitle: 'd',
      ),
      _Photo(
        assetName: 'places/india_pondicherry_fisherman.png',
        title: 'p342',
        subtitle: 'd',
      ),
      _Photo(
        assetName: 'places/india_pondicherry_fisherman.png',
        title: 'o42',
        subtitle: 'd',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('demoGridListsTitle'),
      ),
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
        child: Image.asset(
          photo.assetName,
          package: 'flutter_gallery_assets',
          fit: BoxFit.cover,
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
