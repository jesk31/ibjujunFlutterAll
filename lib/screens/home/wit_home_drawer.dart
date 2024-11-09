import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:witibju_1/screens/home/wit_estimate_detail.dart';
import 'package:witibju_1/screens/home/wit_home_sc.dart';
import 'package:witibju_1/screens/home/wit_home_theme.dart';
import 'package:witibju_1/screens/home/models/main_view_model.dart';
import 'package:witibju_1/screens/home/wit_myprofile_sc.dart';
import 'package:witibju_1/screens/home/wit_navigation_home_sc.dart';

import 'models/main_view_model.dart';
import 'models/userInfo.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({
    Key? key,
    this.screenIndex,
    this.iconAnimationController,
    this.callBackIndex,
  }) : super(key: key);

  final AnimationController? iconAnimationController;
  final DrawerIndex? screenIndex;
  final Function(DrawerIndex)? callBackIndex;

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  List<DrawerList>? drawerList;
  final TextEditingController _pointsController = TextEditingController();

  @override
  void initState() {
    setDrawerListArray();
    super.initState();
  }

  void setDrawerListArray() {
    drawerList = <DrawerList>[
      DrawerList(
        index: DrawerIndex.Points,
        labelName: 'MY profile',
        icon: Icon(Icons.star),
      ),
      DrawerList(
        index: DrawerIndex.HOME,
        labelName: 'Home',
        icon: Icon(Icons.home),
      ),
      DrawerList(
        index: DrawerIndex.Help,
        labelName: '견적 서비스',
        isAssetsImage: true,
        imageName: 'assets/images/supportIcon.png',
      ),
      DrawerList(
        index: DrawerIndex.FeedBack,
        labelName: '입주전 체크리스트',
        icon: Icon(Icons.help),
      ),
      DrawerList(
        index: DrawerIndex.Invite,
        labelName: '입주 프로세스',
        icon: Icon(Icons.group),
      ),
      DrawerList(
        index: DrawerIndex.Share,
        labelName: '커뮤니티',
        icon: Icon(Icons.share),
      ),
      DrawerList(
        index: DrawerIndex.About,
        labelName: '공지사항',
        icon: Icon(Icons.info),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;

    final mainViewModel = Provider.of<MainViewModel>(context, listen: false);
    final userInfo = mainViewModel.userInfo;

    return Scaffold(
      backgroundColor: WitHomeTheme.notWhite.withOpacity(0.5),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 40.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  if (widget.iconAnimationController != null)
                    AnimatedBuilder(
                      animation: widget.iconAnimationController!,
                      builder: (BuildContext context, Widget? child) {
                        return ScaleTransition(
                          scale: AlwaysStoppedAnimation<double>(1.0 -
                              (widget.iconAnimationController!.value) * 0.2),
                          child: RotationTransition(
                            turns: AlwaysStoppedAnimation<double>(
                                Tween<double>(begin: 0.0, end: 24.0)
                                    .animate(CurvedAnimation(
                                    parent: widget.iconAnimationController!,
                                    curve: Curves.fastOutSlowIn))
                                    .value /
                                    360),
                          ),
                        );
                      },
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 4),
                    child: Text(
                      userInfo?.nickName ?? '멋진왕자님',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isLightMode ? WitHomeTheme.grey : WitHomeTheme.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Divider(
            height: 1,
            color: WitHomeTheme.grey.withOpacity(0.6),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(0.0),
              itemCount: drawerList?.length,
              itemBuilder: (BuildContext context, int index) {
                return inkwell(drawerList![index]);
              },
            ),
          ),
          if (widget.screenIndex == DrawerIndex.Points)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _pointsController,
                    decoration: InputDecoration(
                      labelText: '입주포인트 입력',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      print("입주포인트: ${_pointsController.text}");
                    },
                    child: Text('저장'),
                  ),
                ],
              ),
            ),
          Divider(
            height: 1,
            color: WitHomeTheme.grey.withOpacity(0.6),
          ),
          Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  'Sign Out',
                  style: TextStyle(
                    fontFamily: WitHomeTheme.fontName,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: WitHomeTheme.darkText,
                  ),
                  textAlign: TextAlign.left,
                ),
                trailing: Icon(
                  Icons.power_settings_new,
                  color: Colors.red,
                ),
                onTap: () {
                  onTapped();
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<void> onTapped() async {
    final mainViewModel = Provider.of<MainViewModel>(context, listen: false);
    await mainViewModel.logout();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => NavigationHomeScreen()),
    );
  }

  Widget inkwell(DrawerList listData) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey.withOpacity(0.1),
        highlightColor: Colors.transparent,
        onTap: () {
          navigationtoScreen(listData.index!);
        },
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 6.0,
                    height: 46.0,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  listData.isAssetsImage
                      ? Container(
                    width: 24,
                    height: 24,
                    child: Image.asset(
                      listData.imageName,
                      color: widget.screenIndex == listData.index
                          ? Colors.blue
                          : WitHomeTheme.nearlyBlack,
                    ),
                  )
                      : Icon(listData.icon?.icon,
                      color: widget.screenIndex == listData.index
                          ? Colors.blue
                          : WitHomeTheme.nearlyBlack),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  Text(
                    listData.labelName,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: widget.screenIndex == listData.index
                          ? Colors.black
                          : WitHomeTheme.nearlyBlack,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            widget.screenIndex == listData.index
                ? AnimatedBuilder(
              animation: widget.iconAnimationController!,
              builder: (BuildContext context, Widget? child) {
                return Transform(
                  transform: Matrix4.translationValues(
                      MediaQuery.of(context).size.width * 0.75 -
                          (64.0 * widget.iconAnimationController!.value),
                      0.0,
                      0.0), // 음수 발생 방지
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.2),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(28),
                          bottomRight: Radius.circular(28),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Future<void> navigationtoScreen(DrawerIndex indexScreen) async {
    setState(() {
      widget.callBackIndex!(indexScreen);
    });

    if (indexScreen == DrawerIndex.Help) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EstimateScreen()),
      );
    } else if (indexScreen == DrawerIndex.HOME) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else if (indexScreen == DrawerIndex.Points) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyProfile()),
      );
    }
    // 여기에서 다른 항목 처리 로직을 추가할 수 있습니다.
  }
}

enum DrawerIndex {
  HOME,
  FeedBack,
  Help,
  Share,
  About,
  Invite,
  Testing,
  Points, // 추가된 부분
}

class DrawerList {
  DrawerList({
    this.isAssetsImage = false,
    this.labelName = '',
    this.icon,
    this.index,
    this.imageName = '',
  });

  String labelName;
  Icon? icon;
  bool isAssetsImage;
  String imageName;
  DrawerIndex? index;
}
