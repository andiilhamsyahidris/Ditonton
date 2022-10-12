import 'package:ditonton/common/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomInformation extends StatelessWidget {
  final String asset;
  final String title;
  final String subtitle;

  const CustomInformation({
    Key? key,
    required this.asset,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            asset,
            width: 80,
            fit: BoxFit.fill,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: kHeading6,
          ),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: kBodyText.copyWith(color: kDavysGrey),
          ),
          const SizedBox(
            height: 16,
          )
        ],
      ),
    );
  }
}
