import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/features/zipcode_info/presentation/bloc/bloc.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/features/zipcode_info/presentation/widgets/widgets.dart';

import '../../../../injection_container.dart';

class ZipcodeInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zip code info'),
      ),
      body: SingleChildScrollView(
        child: buildBody(context),
      ),
    );
  }

  BlocProvider<ZipcodeInfoBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ZipcodeInfoBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              // Top half
              BlocBuilder<ZipcodeInfoBloc, ZipcodeInfoState>(
                builder: (context, state) {
                  if (state is EmptyZip) {
                    return MessageDisplay(
                      message: 'Get city from a Zip Code!',
                    );
                  } else if (state is LoadingZip) {
                    return LoadingWidget();
                  } else if (state is LoadedZip) {
                    return InfoDisplay(zipcodeInfo: state.info);
                  } else if (state is ErrorZip) {
                    return MessageDisplay(
                      message: state.message,
                    );
                  } else {
                    return MessageDisplay(
                      message: 'Something went very wrong!',
                    );
                  }
                },
              ),
              SizedBox(height: 20),
              InfoControls()
            ],
          ),
        ),
      ),
    );
  }
}
