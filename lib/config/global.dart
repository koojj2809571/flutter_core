part of flutter_core;

class Global{
  /// 用户配置
  static Map<String,dynamic> profileMap = {};

  /// 是否 ios
  static bool isIOS = Platform.isIOS;

  /// android 设备信息
  static AndroidDeviceInfo androidDeviceInfo;

  /// ios 设备信息
  static IosDeviceInfo iosDeviceInfo;

  /// 包信息
  static PackageInfo packageInfo;

  /// 是否离线登录
  static bool isOfflineLogin = false;

  /// 是否 release
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  /// 在当前page点击物理返回键是否直接退出
  static bool isDirectQuit = false;

  /// init
  static Future init(String userKey) async {
    // 运行初始
    WidgetsFlutterBinding.ensureInitialized();

    // 读取设备信息
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    if (Global.isIOS) {
      Global.iosDeviceInfo = await deviceInfoPlugin.iosInfo;
    } else {
      Global.androidDeviceInfo = await deviceInfoPlugin.androidInfo;
    }

    // 包信息
    Global.packageInfo = await PackageInfo.fromPlatform();
    // 工具初始
    await StorageUtil.init();
    HttpUtil();

    // 读取离线用户信息
    var _profileJSON = StorageUtil().getJSON(userKey);
    if (_profileJSON != null) {
      profileMap[userKey] = _profileJSON;
      isOfflineLogin = true;
    }
  }

  // 持久化 用户信息
  static Future<bool> saveProfile(String key, Map<String,dynamic> data) {
    profileMap[key] = data;
    return StorageUtil()
        .setJSON(key, data);
  }

  // 持久化 用户信息
  static dynamic getProfile(String key) {
    if(profileMap[key] != null){
      return profileMap[key];
    }
    var _profileJSON = StorageUtil().getJSON(key);
    if(_profileJSON != null){
      profileMap[key] = _profileJSON;
    }
    return _profileJSON;
  }
}