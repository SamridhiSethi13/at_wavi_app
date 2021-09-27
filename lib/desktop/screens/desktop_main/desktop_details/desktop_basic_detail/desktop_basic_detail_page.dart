import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/dialog_utils.dart';
import 'package:at_wavi_app/desktop/utils/strings.dart';
import 'package:at_wavi_app/desktop/utils/utils.dart';
import 'package:at_wavi_app/desktop/widgets/desktop_button.dart';
import 'package:at_wavi_app/desktop/widgets/desktop_visibility_detector_widget.dart';
import 'package:at_wavi_app/model/user.dart';
import 'package:at_wavi_app/utils/at_enum.dart';
import 'package:at_wavi_app/utils/colors.dart';
import 'package:at_wavi_app/utils/constants.dart';
import 'package:at_wavi_app/view_models/user_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../desktop_basic_item.dart';
import '../../desktop_media_item.dart';
import 'desktop_basic_detail_model.dart';

class DesktopBasicDetailPage extends StatefulWidget {
  DesktopBasicDetailPage({Key? key}) : super(key: key);

  var _desktopBasicDetailPageState = _DesktopBasicDetailPageState();

  @override
  _DesktopBasicDetailPageState createState() =>
      this._desktopBasicDetailPageState = new _DesktopBasicDetailPageState();

  Future addField(BasicData basicData) async {
    await _desktopBasicDetailPageState.addField(basicData);
  }
}

class _DesktopBasicDetailPageState extends State<DesktopBasicDetailPage>
    with AutomaticKeepAliveClientMixin<DesktopBasicDetailPage> {
  late DesktopBasicDetailModel _model;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  Future addField(BasicData basicData) async {
    _model.addField(basicData);
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return DesktopVisibilityDetectorWidget(
      keyScreen: MixedConstants.BASIC_DETAILS_KEY,
      child: ChangeNotifierProvider(
        create: (BuildContext c) {
          final userPreview = Provider.of<UserPreview>(context);
          _model = DesktopBasicDetailModel(userPreview: userPreview);
          return _model;
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: ColorConstants.LIGHT_GREY,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Consumer<DesktopBasicDetailModel>(
                        builder: (_, model, child) {
                          return ListView.separated(
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(vertical: 8),
                            itemCount: model.fields.length,
                            itemBuilder: (context, index) {
                              return (model.fields[index].path != null &&
                                      model.fields[index].path! != 'null')
                                  ? DesktopMediaItem(
                                      title:
                                          model.fields[index].accountName ?? '',
                                      path: model.fields[index].path ?? '',
                                      type: model.fields[index].type ?? '',
                                    )
                                  : DesktopBasicItem(
                                      title:
                                          model.fields[index].accountName ?? '',
                                      value: model
                                              .fields[index].valueDescription ??
                                          '',
                                      onValueChanged: (text) {
                                        _model.updateValues(index, text);
                                      },
                                    );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 16),
                                child: Divider(
                                  height: 1,
                                  color: appTheme.borderColor,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DesktopWhiteButton(
                  title: Strings.desktop_reorder,
                  height: 48,
                  onPressed: () async {
                    await showReOderFieldsPopUp(
                      context,
                      AtCategory.BASIC_DETAILS,
                      (fields) {
                        /// Update Fields after reorder
                        _model.reorderField(fields);
                      },
                    );
                  },
                ),
                SizedBox(width: 12),
                DesktopButton(
                  title: Strings.desktop_save_publish,
                  height: 48,
                  onPressed: () async {
                    await _model.saveAndPublish();
                    showSnackBar(context, Strings.desktop_edit_success,
                        appTheme.primaryColor);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
