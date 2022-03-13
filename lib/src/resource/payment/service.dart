import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/config.dart';
import '../api/repository.dart';

class PaymentService {
  final APIRepository _apiRepository = APIRepository();
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  PaymentService._internal();

  static final PaymentService instance = PaymentService._internal();

  final Set<String> _productIds = {config['payment']['SUBSCRIPTION_ID']};
  List<ProductDetails> _products = [];
  List<ProductDetails> get products {
    return _products;
  }

  List<PurchaseDetails> _purchases = [];
  bool _isProUser = false;
  get isProUser {
    return _isProUser;
  }

  bool _isRestored = false;
  get isRestored => _isRestored;
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String? _queryProductError;
  late Stream<List<PurchaseDetails>> purchaseUpdated;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  ObserverList<Function> _proStatusChangedListeners =
      new ObserverList<Function>();

  ObserverList<Function(String)> _errorListeners =
      new ObserverList<Function(String)>();

  initialize() async {
    purchaseUpdated = _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) async {
      await _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      //TODO handle error;
    });
    await initStoreInfo();
  }

  initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      _isAvailable = isAvailable;
      _products = [];
      _purchases = [];
      _purchasePending = false;
      _loading = false;
      return;
    }
    ProductDetailsResponse productDetailsResponse =
        await _inAppPurchase.queryProductDetails(_productIds);
    if (productDetailsResponse.error == null) {
      _products = productDetailsResponse.productDetails;
    }
    await _inAppPurchase.restorePurchases();
    _isRestored = true;
  }

  buyProduct(ProductDetails productDetails) async {
    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: productDetails);
    if (kDebugMode) {
      print(_purchases);
    }
    if (!_isProUser) {
      _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    } else {
      _callProStatusChangedListeners();
    }
  }

  Future<bool> validatePaymentFromBackend() async {
    final userAccount = await _apiRepository.service.user.readProfile();
    return await _apiRepository.service.payment.validate({
      'dev': config['payment']['TEST_ACCOUNT'] == userAccount?.email
          ? true
          : false,
    });
  }

  Future<bool> _verifyReceipt(PurchaseDetails purchaseDetails) async {
    final userAccount = await _apiRepository.service.user.readProfile();
    return await _apiRepository.service.payment.validate({
      'receipt': purchaseDetails.verificationData.serverVerificationData,
      'dev': config['payment']['TEST_ACCOUNT'] == userAccount?.email
          ? true
          : false,
      'platform': Platform.isIOS ? 'IOS' : 'ANDROID'
    });
  }

  _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.restored) {
        if (kDebugMode) {
          print('restored');
        }
        await _handlePurchaseRestored(purchaseDetails);
        return;
      }
      if (purchaseDetails.status == PurchaseStatus.pending) {
        if (kDebugMode) {
          print('purchase pending...');
        }
        await _handlePurchasePending(purchaseDetails);
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          if (kDebugMode) {
            print('purchase eroor...');
          }
          _handlePurchaseError(purchaseDetails);
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          if (kDebugMode) {
            print('purchase success!');
          }
          await _handlePurchaseSuccess(purchaseDetails);
        }
      }
    }
  }

  _handlePurchaseSuccess(PurchaseDetails purchaseDetails) async {
    _inAppPurchase.completePurchase(purchaseDetails);
    if (kDebugMode) {
      print('in success');
      print(_isProUser);
    }
    if (!_isProUser && await _verifyReceipt(purchaseDetails)) {
      _purchases = [];
      _purchases.add(purchaseDetails);
      _isProUser = true;
      _callProStatusChangedListeners();
    }
  }

  _handlePurchaseRestored(PurchaseDetails purchaseDetails) async {
    _inAppPurchase.completePurchase(purchaseDetails);
    if (kDebugMode) {
      print('_isProUser');
      print(_isProUser);
    }
    if (_isProUser == false) {
      final validation = await _verifyReceipt(purchaseDetails);
      if (validation) {
        _purchases = [];
        _purchases.add(purchaseDetails);
        _isProUser = true;
        _callProStatusChangedListeners();
        if (kDebugMode) {
          print('now is prouser');
        }
      }
    }
  }

  _handlePurchaseError(PurchaseDetails purchaseDetails) {
    if (kDebugMode) {
      print(purchaseDetails.error?.message);
    }
    _callErrorListeners(purchaseDetails.error?.message ?? 'unknown error');
  }

  _handlePurchasePending(PurchaseDetails purchaseDetails) async {
    _inAppPurchase.completePurchase(purchaseDetails);
    if (!_isProUser) {
      final validation = await _verifyReceipt(purchaseDetails);
      if (validation) {
        _purchases = [];
        _purchases.add(purchaseDetails);
        _isProUser = true;
        _callProStatusChangedListeners();
        if (kDebugMode) {
          print('now is prouser');
        }
      }
    }
  }

  addToProStatusChangedListeners(Function callback) {
    _proStatusChangedListeners.add(callback);
  }

  removeFromProStatusChangedListeners(Function callback) {
    _proStatusChangedListeners.remove(callback);
  }

  addToErrorListeners(Function(String) callback) {
    _errorListeners.add(callback);
  }

  removeFromErrorListeners(Function(String) callback) {
    _errorListeners.remove(callback);
  }

  void _callProStatusChangedListeners() {
    for (var callback in _proStatusChangedListeners) {
      callback();
    }
  }

  void _callErrorListeners(String error) {
    for (var callback in _errorListeners) {
      callback(error);
    }
  }
}
