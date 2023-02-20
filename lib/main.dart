import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:tapsell_plus/tapsell_plus.dart';
import 'package:torch_light/torch_light.dart';

void main() {
  runApp(const MyApp());

  const appId =
      "qgbdodatmlkifhjeqhbpghflllgprbkogqbhsdmeihqifntrtikcrpckiajafcjagnbspm";
  TapsellPlus.instance.initialize(appId);
  TapsellPlus.instance.setGDPRConsent(true);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> ad() async {
    String adId = await TapsellPlus.instance.requestStandardBannerAd(
        "63f39ae15bea2d1905a6f218", TapsellPlusBannerType.BANNER_320x50);

    await TapsellPlus.instance.showStandardBannerAd(adId,
        TapsellPlusHorizontalGravity.BOTTOM, TapsellPlusVerticalGravity.CENTER,
        margin: const EdgeInsets.only(bottom: 1), onOpened: (map) {
      // Ad opened
    }, onError: (map) {
      // Error when showing ad
    });
  }

  bool _isInit = true;
  @override
  void didChangeDependencies() async {
    if (_isInit) {
      await ad();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  bool _isOn = false;

  Future<void> toggleFlash() async {
    setState(() {
      _isOn = !_isOn;
    });

    if (_isOn) {
      try {
        await TorchLight.enableTorch();
      } on Exception catch (_) {
        // Handle error
      }
    } else {
      try {
        await TorchLight.disableTorch();
      } on Exception catch (_) {
        // Handle error
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        brightness: _isOn ? Brightness.light : Brightness.dark,
      ),
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: GestureDetector(
              child: Neumorphic(
                padding: const EdgeInsets.all(75),
                style: NeumorphicStyle(
                  boxShape: const NeumorphicBoxShape.circle(),
                  color: _isOn ? Colors.white38 : Colors.black38,
                  depth: _isOn ? 5 : -5,
                ),
                child: const Icon(
                  Icons.power_settings_new_rounded,
                  size: 60,
                ),
              ),
              onTap: () {
                toggleFlash();
              },
            ),
          ),
        ),
      ),
    );
  }
}
