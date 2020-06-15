import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class CustomNavBarWidget extends StatelessWidget {
  final int selectedIndex;
  final List<PersistentBottomNavBarItem> items;
  final ValueChanged<int> onItemSelected;
  final Function onButtonTap;

  CustomNavBarWidget(
      {Key key,
      this.selectedIndex,
      @required this.items,
      this.onItemSelected,
      this.onButtonTap});

  Widget _buildItem(PersistentBottomNavBarItem item, bool isSelected) {
    return Container(
      alignment: Alignment.center,
      height: kBottomNavigationBarHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: IconTheme(
              data: IconThemeData(
                  size: 26.0,
                  color: isSelected
                      ? (item.activeContentColor == null
                          ? item.activeColor
                          : item.activeContentColor)
                      : item.inactiveColor == null
                          ? item.activeColor
                          : item.inactiveColor),
              child: item.icon,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Container(
        width: double.infinity,
        height: kBottomNavigationBarHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Flexible(
              child: GestureDetector(
                onTap: () {
                  this.onItemSelected(0);
                },
                child: _buildItem(items[0], selectedIndex == 0),
              ),
            ),
            Flexible(
              child: GestureDetector(
                onTap: () {
                  this.onItemSelected(1);
                },
                child: _buildItem(items[1], selectedIndex == 1),
              ),
            ),
            Flexible(
              child: Card(
                color: Colors.indigoAccent,
                shadowColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                child: IconButton(
                  onPressed: () {
                    this.onButtonTap();
                  },
                  icon: Icon(Icons.camera_alt),
                  color: Colors.white,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
              ),
            ),
            Flexible(
              child: GestureDetector(
                onTap: () {
                  this.onItemSelected(2);
                },
                child: _buildItem(items[2], selectedIndex == 2),
              ),
            ),
            Flexible(
              child: GestureDetector(
                onTap: () {
                  this.onItemSelected(3);
                },
                child: _buildItem(items[3], selectedIndex == 3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
