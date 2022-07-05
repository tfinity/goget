import 'dart:io';

import 'package:flutter/material.dart';
//import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoGet Shop',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'GoGet Shop'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String userId = " ";
  String url = "https://goget.shop/";

  requestPermissions() async {
    await [
      Permission.location,
      Permission.storage,
      Permission.camera,
    ].request();
  }

  @override
  void initState() {
    requestPermissions();
    super.initState();
    //initOneSignal();
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          controllerGlobal.reload();
        } else if (Platform.isIOS) {
          controllerGlobal.loadUrl(
              urlRequest: URLRequest(url: await controllerGlobal.getUrl()));
        }
      },
    );

    // Enable virtual display.
    //if (Platform.isAndroid) WebView.platform = AndroidWebView();
    //print('Attaching id');
    connectionCheck();

    /* Future.delayed(Duration(seconds: 3), () async {
      try {
        var device = await OneSignal.shared.getDeviceState().then((value) {
          userId = value!.userId!;
        });
      } catch (e) {
        print(e);
        var device = await OneSignal.shared.getDeviceState();
        //userId = device!.userId!;
        OneSignal.shared.setSubscriptionObserver((changes) async {
          print("ID Assigned ");
          print(changes.from.userId);
          print(changes.to.userId);
          userId = changes.to.userId!;
          print('userId: $userId');
          var device = await OneSignal.shared.getDeviceState().then((value) {
            userId = value!.userId!;
          });
          print(" User ID: Laveandroid_$userId");
          setState(() {});
        });
      }
    }); */
  }

  bool isConnected = true;
  var listener;

  connectionCheck() {
    listener = InternetConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          setState(() {
            isConnected = true;
          });
          Future.delayed(const Duration(seconds: 5), () {
            setState(() {
              index = 1;
            });
          });
          break;
        case InternetConnectionStatus.disconnected:
          setState(() {
            isConnected = false;
            index = 0;
          });
          break;
      }
    });
  }

  @override
  void dispose() {
    listener.cancel();
    super.dispose();
  }

  int index = 0;
  /* initOneSignal() async {
    await OneSignal.shared.setAppId("c2423397-2a85-4071-bf43-45f40319ba08");
    // The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print("Accepted permission: $accepted");
    });
    /* OneSignal().setSubscriptionObserver((changes) {
      userId = changes.to.userId!;
      setState(() {});
    }); */
    /* Future.delayed(Duration(seconds: 2), () async {
      await OneSignal.shared.getDeviceState().then((value) =>
          {print(value?.jsonRepresentation()), userId = value!.userId!});
      setState(() {});
    }); */

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      print(
          '"OneSignal: notification opened: ${result.notification.launchUrl}');
      url = result.notification.launchUrl!;
      controllerGlobal.loadUrl(
          urlRequest:
              URLRequest(url: Uri.parse('${result.notification.launchUrl}')));
      result.notification.launchUrl;
    });
    print('id Attached');
  } */

  late InAppWebViewController controllerGlobal;

  Future<bool> _exitApp(BuildContext context) async {
    if (await controllerGlobal.canGoBack()) {
      print("onwill goback");
      controllerGlobal.goBack();
      return false;
    } else {
      return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: SizedBox(
                height: 90,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Do you want to exit?"),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              print('yes selected');
                              exit(0);
                            },
                            child: const Text("Yes"),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.red.shade800),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                            child: ElevatedButton(
                          onPressed: () {
                            print('no selected');
                            Navigator.of(context).pop();
                          },
                          child: const Text("No",
                              style: TextStyle(color: Colors.black)),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                          ),
                        ))
                      ],
                    )
                  ],
                ),
              ),
            );
          });
    }
  }

  Future<bool> showExitPopup(context) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SizedBox(
              height: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Do you want to exit?"),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            print('yes selected');
                            exit(0);
                          },
                          child: const Text("Yes"),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.red.shade800),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                          child: ElevatedButton(
                        onPressed: () {
                          print('no selected');
                          Navigator.of(context).pop();
                        },
                        child: const Text("No",
                            style: TextStyle(color: Colors.black)),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                        ),
                      ))
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  bool isLoading = false;
  late PullToRefreshController pullToRefreshController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () => _exitApp(context),
        child: Scaffold(
          //floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: index == 1 && Platform.isIOS
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      onPressed: () => _exitApp(context),
                      tooltip: 'Go Back',
                      child: const Icon(Icons.arrow_back),
                      mini: true,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                  ],
                )
              : Container(),
          body: IndexedStack(
            index: index,
            children: [
              Container(
                color: const Color.fromARGB(255, 108, 159, 214),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        //color: Colors.black,
                        width: double.infinity,
                        /* height: (MediaQuery.of(context).size.height -
                                MediaQuery.of(context).padding.top) *
                            1, */
                        child: Image.asset(
                          'assets/Icon.png',
                          fit: BoxFit.fill,
                        )),
                    /* if (!isConnected)
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                    isConnected
                        ? const CircularProgressIndicator()
                        : Image.asset(
                            'assets/connection.png',
                            scale: 15,
                          ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    isConnected
                        ? const Text('')
                        : const Text(
                            'Connection Error!... Please check Your Internet'), */
                  ],
                ),
              ),
              Column(
                children: [
                  Expanded(
                    //height: MediaQuery.of(context).size.height * 0.89,
                    child: InAppWebView(
                      androidOnGeolocationPermissionsShowPrompt:
                          (InAppWebViewController controller,
                              String origin) async {
                        return GeolocationPermissionShowPromptResponse(
                            origin: origin, allow: true, retain: true);
                      },
                      onLoadStart: (controller, url) {
                        setState(() {
                          isLoading = true;
                        });
                      },
                      onLoadStop: (controller, url) {
                        pullToRefreshController.endRefreshing();
                        setState(() {
                          isLoading = false;
                        });
                      },
                      androidOnPermissionRequest:
                          (controller, origin, resources) async {
                        return PermissionRequestResponse(
                            resources: resources,
                            action: PermissionRequestResponseAction.GRANT);
                      },
                      pullToRefreshController: pullToRefreshController,
                      initialUrlRequest: URLRequest(url: Uri.parse(url)),
                      onWebViewCreated: (controller) {
                        controllerGlobal = controller;
                      },
                      initialOptions: InAppWebViewGroupOptions(
                        crossPlatform: InAppWebViewOptions(
                          userAgent: Platform.isAndroid ? 'android' : 'ios',
                          horizontalScrollBarEnabled: false,
                          verticalScrollBarEnabled: false,
                        ),
                        android: AndroidInAppWebViewOptions(
                          serifFontFamily: 'Times New Roman',
                          fixedFontFamily: 'Times New Roman',
                          cursiveFontFamily: 'Times New Roman',
                          fantasyFontFamily: 'Times New Roman',
                          standardFontFamily: 'Times New Roman',
                          sansSerifFontFamily: 'Times New Roman',
                          useHybridComposition: true,
                          supportMultipleWindows: true,
                        ),
                      ),
                      onCreateWindow: (controller, window) async {
                        print(window.request);
                        await launchUrl(window.request.url!,
                            mode: LaunchMode.externalApplication);
                        return true;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
