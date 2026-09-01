import 'package:flutter/material.dart';
import '../../data/repositories/owner_repository.dart';
import '../../data/services/storage_service.dart';

class OwnerAuthViewModel extends ChangeNotifier {
  final OwnerRepository repository;

  OwnerAuthViewModel({required this.repository});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String _phoneOrEmail = '';
  String get phoneOrEmail => _phoneOrEmail;

  Future<bool> sendOtp(String phone) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _phoneOrEmail = phone;
      final success = await repository.sendOtp(phone);
      return success;
    } catch (e) {
      _errorMessage = 'Failed to send OTP: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> verifyOtp(String otpCode) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await repository.verifyOtp(_phoneOrEmail, otpCode);
      return response.accessToken != null;
    } catch (e) {
      _errorMessage = 'Invalid OTP code. Please try again.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> loginWithEmail(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await repository.loginWithEmail(email, password);
      return response.accessToken != null;
    } catch (e) {
      _errorMessage = 'Invalid credentials. Please check email/password.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    try {
      await repository.logout();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool get isAuthenticated => StorageService.hasToken();
}
