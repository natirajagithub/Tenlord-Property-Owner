import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keyToken = 'dormly_owner_auth_token';
  static const String _keyPhone = 'dormly_owner_phone';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveToken(String token) async {
    await _prefs?.setString(_keyToken, token);
  }

  static String? getToken() {
    return _prefs?.getString(_keyToken);
  }

  static Future<void> savePhone(String phone) async {
    await _prefs?.setString(_keyPhone, phone);
  }

  static String? getPhone() {
    return _prefs?.getString(_keyPhone);
  }

  static bool hasToken() {
    final token = getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> clearSession() async {
    await _prefs?.remove(_keyToken);
    await _prefs?.remove(_keyPhone);
  }

  static const String _keyOwnerName = 'dormly_owner_name';
  static const String _keyOwnerPhoneNo = 'dormly_owner_phone_no';
  static const String _keyOwnerEmail = 'dormly_owner_email';
  static const String _keyOwnerBusiness = 'dormly_owner_business';
  static const String _keyOwnerCity = 'dormly_owner_city';
  static const String _keyOwnerBank = 'dormly_owner_bank';
  static const String _keyOwnerAccountNo = 'dormly_owner_account_no';
  static const String _keyOwnerIfsc = 'dormly_owner_ifsc';
  static const String _keyOwnerUpi = 'dormly_owner_upi';
  static const String _keyOwnerAvatarPath = 'dormly_owner_avatar_path';

  static Future<void> saveOwnerProfile({
    required String name,
    required String phone,
    required String email,
    required String business,
    required String city,
    required String bank,
    required String accountNo,
    required String ifsc,
    required String upi,
    String? avatarPath,
  }) async {
    await _prefs?.setString(_keyOwnerName, name);
    await _prefs?.setString(_keyOwnerPhoneNo, phone);
    await _prefs?.setString(_keyOwnerEmail, email);
    await _prefs?.setString(_keyOwnerBusiness, business);
    await _prefs?.setString(_keyOwnerCity, city);
    await _prefs?.setString(_keyOwnerBank, bank);
    await _prefs?.setString(_keyOwnerAccountNo, accountNo);
    await _prefs?.setString(_keyOwnerIfsc, ifsc);
    await _prefs?.setString(_keyOwnerUpi, upi);
    if (avatarPath != null) {
      await _prefs?.setString(_keyOwnerAvatarPath, avatarPath);
    }
  }

  static Map<String, String> getOwnerProfile() {
    return {
      'name': _prefs?.getString(_keyOwnerName) ?? 'Natiraja Prajapati',
      'phone': _prefs?.getString(_keyOwnerPhoneNo) ?? '7489128297',
      'email': _prefs?.getString(_keyOwnerEmail) ?? 'natirajaprajapati5@gmail.com',
      'business': _prefs?.getString(_keyOwnerBusiness) ?? 'Shanti Residency PG Group',
      'city': _prefs?.getString(_keyOwnerCity) ?? 'Indore, Madhya Pradesh',
      'bank': _prefs?.getString(_keyOwnerBank) ?? 'HDFC Bank',
      'accountNo': _prefs?.getString(_keyOwnerAccountNo) ?? '918273644891',
      'ifsc': _prefs?.getString(_keyOwnerIfsc) ?? 'HDFC0001234',
      'upi': _prefs?.getString(_keyOwnerUpi) ?? 'dormly@hdfcbank',
      'avatarPath': _prefs?.getString(_keyOwnerAvatarPath) ?? '',
    };
  }

  static Future<void> saveAvatarPath(String path) async {
    await _prefs?.setString(_keyOwnerAvatarPath, path);
  }

  static String getAvatarPath() {
    return _prefs?.getString(_keyOwnerAvatarPath) ?? '';
  }
}
