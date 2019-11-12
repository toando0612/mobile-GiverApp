import 'package:flutter/material.dart';
import 'package:giver_app/scoped_model/user_home_view_model.dart';

import 'base_view.dart';

class TemplateView extends StatefulWidget {
  @override
  _TemplateViewState createState() => _TemplateViewState();
}

class _TemplateViewState extends State<TemplateView> {
  @override
  Widget build(BuildContext context) {
    return BaseView<UserHomeViewModel>(
        builder: (context, child, model) => Scaffold());
  }
}
