import 'package:flutter/material.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/features/zipcode_info/domain/entities/zipcode_info.dart';

class InfoDisplay extends StatelessWidget {
  final ZipcodeInfo zipcodeInfo;

  const InfoDisplay({
    Key? key,
    required this.zipcodeInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        children: <Widget>[
          Text(
            zipcodeInfo.zipcode.toString(),
            style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Text(
                  '${zipcodeInfo.city + ', ' + zipcodeInfo.state}',
                  style: TextStyle(fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
