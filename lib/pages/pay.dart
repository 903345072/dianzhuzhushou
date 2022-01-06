import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutterapp2/SharedPreferences/TokenStore.dart';
import 'package:flutterapp2/net/Address.dart';
import 'package:flutterapp2/net/HttpManager.dart';
import 'package:flutterapp2/net/ResultData.dart';
import 'package:flutterapp2/pages/IndexPage.dart';
import 'package:flutterapp2/pages/Mine.dart';
import 'package:flutterapp2/utils/JumpAnimation.dart';
import 'package:flutterapp2/utils/Rute.dart';
import 'package:flutterapp2/utils/Toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import 'IndexBack.dart';

class pay extends StatefulWidget {
  Map data;
  pay(this.data);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Login_();
  }
}

class Login_ extends State<pay> {
  String old_pwd;
  String new_pwd;
  String re_pwd;
  bool check = false;

  FocusNode _commentFocus;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _commentFocus = FocusNode();
  }

  @override
  Widget build(BuildContext context) {

    ScreenUtil.instance = ScreenUtil(width: 417, height: 867)..init(context);

    // TODO: implement build
    return FlutterEasyLoading(
      child: Scaffold(
        appBar: AppBar(

          centerTitle: true,
          elevation: 0,
          iconTheme: IconThemeData(
            size: 25.0,
            color: Colors.white, //修改颜色
          ),
          backgroundColor: Color(0xfffa2020),
          title: Text("充值",style: TextStyle(fontSize: ScreenUtil().setSp(18)),),
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
           widget.data["type"] == 1?Column(

             children: <Widget>[
               Container(
                 margin: EdgeInsets.only(top: 20,bottom: 20),
                 child: Text((widget.data["actual_price"]).toString()+"元",style: TextStyle(color: Colors.red,fontSize: 24),),
               ),
               Container(
                 margin: EdgeInsets.only(bottom: 20),
                 child: Image.network(widget.data["ali_ewm"],fit: BoxFit.fill,width: 150,),
               ),

               Container(
                 margin: EdgeInsets.only(top: 20,bottom: 20),
                 child: Wrap(
                   direction: Axis.vertical,
                   spacing: 15,
                   children: <Widget>[
                     Text("1、截屏保存到手机"),
                     Text("2、打开支付宝，扫一扫相册二维码")
                   ],
                 ),
               ),
               Container(

                 child: MaterialButton(
                   minWidth: 200,
                   color: Colors.red,
                   onPressed: ()async{
                     ResultData res = await HttpManager.getInstance().post("recharge/submit_recharge",params: {"price":widget.data["actual_price"],"type":widget.data["type"]},withLoading: false);

                     Toast.toast(context,msg: "申请成功");
                     JumpAnimation().jump(new IndexBack(), context);

                   },
                   child: Text("提交支付申请",style: TextStyle(color: Colors.white),),
                 ),
               )
             ],
           ):Column(

             children: <Widget>[
               Container(
                 margin: EdgeInsets.only(top: 90,bottom: 30),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                   children: <Widget>[
                     Container(
                       child: Wrap(
                         direction: Axis.vertical,
                         spacing: 35,
                         crossAxisAlignment: WrapCrossAlignment.start,
                         children: <Widget>[
                           Text("银行卡号:",style: TextStyle(fontSize: 17),),
                           Text("开户行:",style: TextStyle(fontSize: 17),),
                           Text("持卡人:",style: TextStyle(fontSize: 17),),
                           Text("支付金额:",style: TextStyle(fontSize: 17),),
                         ],
                       ),
                     ),
                     Container(

                       child: Wrap(
                         direction: Axis.vertical,
                         spacing: 35,
                         crossAxisAlignment: WrapCrossAlignment.start,
                         children: <Widget>[
                           Row(
                             children: <Widget>[
                               Text(widget.data["bank_code"],style: TextStyle(fontSize: 17),),
                               GestureDetector(
                                 onTap: (){
                                   Future res = Clipboard.setData(ClipboardData(text: widget.data["bank_code"]));
                                   res.whenComplete(() =>Toast.toast(context,msg: "复制成功"));
                                 },
                                 child: Container(

                                   padding: EdgeInsets.only(left: 5),
                                   child:Text("复制",style: TextStyle(color: Colors.blue),),

                                 ),
                               ),
                             ],
                           ),
                           Text(widget.data["bank_name"],style: TextStyle(fontSize: 17),),
                           Text(widget.data["bank_user"],style: TextStyle(fontSize: 17),),
                           Text(widget.data["actual_price"].toString()+"元",style: TextStyle(fontSize: 17),),
                         ],
                       ),
                     )
                   ],
                 ),
               ),

               Container(

                 child: MaterialButton(
                   minWidth: 200,
                   color: Colors.red,
                   onPressed: ()async{
                     ResultData res = await HttpManager.getInstance().post("recharge/submit_recharge",params: {"price":widget.data["actual_price"],"type":widget.data["type"]},withLoading: false);

                     Toast.toast(context,msg: "申请成功");
                     JumpAnimation().jump(new IndexBack(), context);

                   },
                   child: Text("提交支付申请",style: TextStyle(color: Colors.white),),
                 ),
               )
             ],
           )

          ],
        ),
      ),
    );
  }
}
