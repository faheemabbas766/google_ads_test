import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AdMob Ads Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AdHomePage(),
    );
  }
}

class AdHomePage extends StatefulWidget {
  @override
  _AdHomePageState createState() => _AdHomePageState();
}

class _AdHomePageState extends State<AdHomePage> {
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  RewardedInterstitialAd? _rewardedInterstitialAd;
  BannerAd? _bannerAd;
  NativeAd? _nativeAd;
  NativeAd? _nativeVideoAd;
  AppOpenAd? _appOpenAd;
  bool _isNativeAdLoaded = false;
  bool _isNativeVideoAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
    _loadRewardedAd();
    _loadRewardedInterstitialAd();
    _loadBannerAd();
    _loadNativeAd();
    _loadNativeVideoAd();
    _loadAppOpenAd();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712',
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          print('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917',
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (error) {
          print('RewardedAd failed to load: $error');
        },
      ),
    );
  }

  void _loadRewardedInterstitialAd() {
    RewardedInterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5354046379',
      request: AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedInterstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          print('RewardedInterstitialAd failed to load: $error');
        },
      ),
    );
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/9214589741', // Adaptive Banner ID
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {});
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('BannerAd failed to load: $error');
        },
      ),
    )..load();
  }

  void _loadNativeAd() {
    _nativeAd = NativeAd(
      adUnitId: 'ca-app-pub-3940256099942544/2247696110',
      factoryId: 'listTile',
      request: AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isNativeAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('NativeAd failed to load: $error');
        },
      ),
    )..load();
  }

  void _loadNativeVideoAd() {
    _nativeVideoAd = NativeAd(
      adUnitId: 'ca-app-pub-3940256099942544/1044960115',
      factoryId: 'listTile',
      request: AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isNativeVideoAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('NativeVideoAd failed to load: $error');
        },
      ),
    )..load();
  }

  void _loadAppOpenAd() {
    AppOpenAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/9257395921',
      request: AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
        },
        onAdFailedToLoad: (error) {
          print('App Open Ad failed to load: $error');
        },
      ),
    );
  }

  void _showAppOpenAd() {
    if (_appOpenAd != null) {
      _appOpenAd!.show();
    } else {
      print('App Open Ad is not loaded yet');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AdMob Ads Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _adButton('Show App Open Ad', _showAppOpenAd),
            _adButton('Show Adaptive Banner Ad', () {
              if (_bannerAd != null) {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      height: 100,
                      child: AdWidget(ad: _bannerAd!),
                    );
                  },
                );
              } else {
                print('Banner ad is not loaded yet');
              }
            }),
            _adButton('Show Fixed Size Banner Ad', () {
              if (_bannerAd != null) {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      height: 100,
                      child: AdWidget(ad: _bannerAd!),
                    );
                  },
                );
              } else {
                print('Banner ad is not loaded yet');
              }
            }),
            _adButton('Show Interstitial Ad', () {
              if (_interstitialAd != null) {
                _interstitialAd!.show();
              } else {
                print('Interstitial ad is not loaded yet');
              }
            }),
            _adButton('Show Rewarded Ad', () {
              if (_rewardedAd != null) {
                _rewardedAd!.show(
                  onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
                    print('User earned reward: ${reward.amount} ${reward.type}');
                  },
                );
              } else {
                print('Rewarded ad is not loaded yet');
              }
            }),
            _adButton('Show Rewarded Interstitial Ad', () {
              if (_rewardedInterstitialAd != null) {
                _rewardedInterstitialAd!.show(
                  onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
                    print('User earned reward: ${reward.amount} ${reward.type}');
                  },
                );
              } else {
                print('Rewarded Interstitial ad is not loaded yet');
              }
            }),
            _adButton('Show Native Ad', () {
              if (_isNativeAdLoaded && _nativeAd != null) {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      height: 300,
                      child: AdWidget(ad: _nativeAd!),
                    );
                  },
                );
              } else {
                print('Native ad is not loaded yet');
              }
            }),
            _adButton('Show Native Video Ad', () {
              if (_isNativeVideoAdLoaded && _nativeVideoAd != null) {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      height: 300,
                      child: AdWidget(ad: _nativeVideoAd!),
                    );
                  },
                );
              } else {
                print('Native Video ad is not loaded yet');
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget _adButton(String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 50),
          textStyle: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    _rewardedInterstitialAd?.dispose();
    _bannerAd?.dispose();
    _nativeAd?.dispose();
    _nativeVideoAd?.dispose();
    _appOpenAd?.dispose();
    super.dispose();
  }
}
