import 'package:at_wavi_app/desktop/screens/desktop_basic_detail/widgets/desktop_basic_detail_item_widget.dart';
import 'package:at_wavi_app/desktop/screens/desktop_basic_detail/widgets/desktop_empty_basic_detail_widget.dart';
import 'package:at_wavi_app/desktop/screens/desktop_basic_detail_popup/desktop_basic_detail_popup.dart';
import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/widgets/desktop_welcome_widget.dart';
import 'package:flutter/material.dart';

class DesktopBasicDetailPage extends StatefulWidget {
  const DesktopBasicDetailPage({Key? key}) : super(key: key);

  @override
  _DesktopBasicDetailPageState createState() => _DesktopBasicDetailPageState();
}

class _DesktopBasicDetailPageState extends State<DesktopBasicDetailPage>
    with AutomaticKeepAliveClientMixin {
  bool isHaveData = false;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: isHaveData ? _buildContentWidget() : _buildEmptyWidget(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Column(
      children: [
        SizedBox(height: 64),
        DesktopWelcomeWidget(),
        Expanded(
          child: Container(
            child: Center(
              child: DesktopEmptyBasicDetailWidget(
                onAddDetailsPressed: _showAddDetailPopup,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContentWidget() {
    final appTheme = AppTheme.of(context);
    return Container(
      margin: EdgeInsets.only(top: 80, left: 80, right: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              'Basic Details',
              style: TextStyle(
                color: appTheme.primaryTextColor,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 60),
          Container(
            decoration: BoxDecoration(
              color: Color(0xF5f5f5).withOpacity(0.5),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DesktopBasicDetailItemWidget(
                  title: 'Name',
                  description: 'Lauren London',
                ),
                Divider(
                  color: appTheme.separatorColor,
                  indent: 27,
                  endIndent: 27,
                  height: 1,
                ),
                DesktopBasicDetailItemWidget(
                  title: 'Phone Number',
                  description: '+1 408 432 9012',
                ),
                Divider(
                  color: appTheme.separatorColor,
                  indent: 27,
                  endIndent: 27,
                  height: 1,
                ),
                DesktopBasicDetailItemWidget(
                  title: 'Email Address',
                  description: 'lauren@atsign.com',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddDetailPopup() async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
        backgroundColor: Colors.transparent,
        child: DesktopBasicDetailPopup(),
      ),
    );
    setState(() {
      isHaveData = !isHaveData;
    });
  }
}
