import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/core/util/buttonConverter.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/features/zipcode_info/presentation/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InfoControls extends StatefulWidget {
  const InfoControls({
    Key? key,
  }) : super(key: key);

  @override
  _InfoControlsState createState() => _InfoControlsState();
}

class _InfoControlsState extends State<InfoControls> {
  final controller = TextEditingController();
  late String inputStr;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Input a zip code',
          ),
          onChanged: (value) {
            inputStr = value;
          },
          onSubmitted: (_) {
            dispatchFixed();
          },
        ),
        SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: RaisedButtonX(
                childx: Text('Search'),
                textColorx: Colors.black,
                colorx: Theme.of(context).colorScheme.secondary,
                onPressedx: dispatchFixed,
              ),
            ),
          ],
        )
      ],
    );
  }

  void dispatchFixed() {
    controller.clear();
    BlocProvider.of<ZipcodeInfoBloc>(context)
        .add(GetInfoForFixedZipcode(inputStr));
  }

  void dispatchRandom() {
    controller.clear();
    BlocProvider.of<ZipcodeInfoBloc>(context).add(GetInfoForRandomZipcode());
  }
}
