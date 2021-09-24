import 'dart:io';

import 'package:at_wavi_app/desktop/screens/desktop_main/desktop_details/desktop_media/desktop_media_model.dart';
import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/widgets/desktop_visibility_detector_widget.dart';
import 'package:at_wavi_app/model/user.dart';
import 'package:at_wavi_app/utils/colors.dart';
import 'package:at_wavi_app/utils/constants.dart';
import 'package:at_wavi_app/view_models/user_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DesktopMediaPage extends StatefulWidget {
  DesktopMediaPage({Key? key}) : super(key: key);

  var _desktopMediaPageState = _DesktopMediaPageState();

  @override
  _DesktopMediaPageState createState() =>
      this._desktopMediaPageState = new _DesktopMediaPageState();

  Future addMedia(BasicData basicData) async {
    await _desktopMediaPageState.addMedia(basicData);
  }
}

class _DesktopMediaPageState extends State<DesktopMediaPage>
    with AutomaticKeepAliveClientMixin<DesktopMediaPage> {
  late DesktopMediaModel _model;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  Future addMedia(BasicData basicData) async {
    _model.addMedia(basicData);
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return DesktopVisibilityDetectorWidget(
      keyScreen: MixedConstants.MEDIA_KEY,
      child: ChangeNotifierProvider(
        create: (BuildContext c) {
          final userPreview = Provider.of<UserPreview>(context);
          _model = DesktopMediaModel(userPreview: userPreview);
          return _model;
        },
        child: Container(
          child: Consumer<DesktopMediaModel>(
            builder: (_, model, child) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                padding: EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  return AspectRatio(
                    aspectRatio: 1.0,
                    child: index % 2 != 0
                        ? Image.file(
                            File(model.fields[index].path!),
                            fit: BoxFit.fitWidth,
                          )
                        : Stack(
                            children: [
                              Image.file(
                                File(model.fields[index].path!),
                                fit: BoxFit.fitWidth,
                              ),
                              Center(
                                child: Icon(
                                  Icons.play_circle_fill,
                                  size: 56,
                                  color: ColorConstants.white,
                                ),
                              ),
                            ],
                          ),
                  );
                },
                itemCount: model.fields.length,
              );
            },
          ),
        ),
      ),
    );
  }
}
