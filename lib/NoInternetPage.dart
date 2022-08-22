import 'package:flutter/material.dart';

class NoInternetPage extends StatelessWidget {
  Function? onButtonClick;
  NoInternetPage({
    Key? key,
    @required this.onButtonClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class InternaleServerError extends StatelessWidget {
  Function? onButtonClick;
  InternaleServerError({Key? key, required this.onButtonClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
