import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartinevntary/core/constants/app_strings.dart';

class LocalStorageServices {
  Future<SharedPreferences> _prefs() async {
    return await SharedPreferences.getInstance();
  }

  Future<void> setData(bool value) async {
    final pref = await _prefs();
    await pref.setBool(AppStrings.rememberMe, value);
  }

  Future<bool> getData() async {
    final pref = await _prefs();
    return pref.getBool(AppStrings.rememberMe) ?? false;
  }

  Future<void> clearData() async {
    final pref = await _prefs();

    await pref.clear();
  }
}
