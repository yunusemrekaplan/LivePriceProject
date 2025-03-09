import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_price_frontend/core/services/token_manager.dart';
import 'package:live_price_frontend/modules/customer_panel/models/c_parity_rule_create_model.dart';
import 'package:live_price_frontend/modules/customer_panel/models/c_parity_rule_update_model.dart';
import 'package:live_price_frontend/modules/customer_panel/models/c_parity_rule_view_model.dart';
import 'package:live_price_frontend/modules/customer_panel/models/c_parity_group_rule_create_model.dart';
import 'package:live_price_frontend/modules/customer_panel/models/c_parity_group_rule_update_model.dart';
import 'package:live_price_frontend/modules/customer_panel/models/c_parity_group_rule_view_model.dart';
import 'package:live_price_frontend/modules/customer_panel/models/c_parity_view_model.dart';
import 'package:live_price_frontend/modules/customer_panel/models/c_parity_group_view_model.dart';
import 'package:live_price_frontend/modules/customer_panel/services/customer_panel_service.dart';

class CustomerPanelController extends GetxController {
  final CustomerPanelService _service = Get.find<CustomerPanelService>();
  final TokenManager _tokenManager = TokenManager();

  final isLoading = true.obs;
  final error = RxString('');

  // Müşteri ID'si
  final customerId = RxInt(0);

  // Müşteri Pariteleri
  final customerParities = <CParityViewModel>[].obs;
  final filteredCustomerParities = <CParityViewModel>[].obs;
  final customerParitySearchQuery = ''.obs;

  // Müşteri Parite Grupları
  final customerParityGroups = <CParityGroupViewModel>[].obs;
  final filteredCustomerParityGroups = <CParityGroupViewModel>[].obs;
  final customerParityGroupSearchQuery = ''.obs;
  final selectedParityGroup = RxInt(0);

  // Parite Kuralları
  final parityRules = <CParityRuleViewModel>[].obs;

  // Parite Grup Kuralları
  final parityGroupRules = <CParityGroupRuleViewModel>[].obs;

  // Form için kullanılacak kontroller
  final formKey = GlobalKey<FormState>();
  final parityRuleIsVisible = true.obs;
  final parityRuleSpreadType = Rx<SpreadRuleType?>(null);
  final parityRuleSpreadForAsk = Rx<double?>(null);
  final parityRuleSpreadForBid = Rx<double?>(null);
  final parityGroupRuleIsVisible = true.obs;

  CustomerPanelController({int customerId = 0}) {
    this.customerId.value = customerId;
  }

  @override
  void onInit() {
    super.onInit();
    customerId.value = _tokenManager.getCustomerId()!;
    fetchCustomerParities();
    fetchCustomerParityGroups();
    fetchParityRules();
    fetchParityGroupRules();
  }

  // Müşteri Pariteleri için arama fonksiyonu
  void searchCustomerParities(String query) {
    customerParitySearchQuery.value = query;
    _filterCustomerParities();
  }

  // Müşteri Parite Grupları için arama fonksiyonu
  void searchCustomerParityGroups(String query) {
    customerParityGroupSearchQuery.value = query;
    if (query.isEmpty) {
      filteredCustomerParityGroups.value = customerParityGroups;
    } else {
      filteredCustomerParityGroups.value = customerParityGroups
          .where((group) => (group.name?.toLowerCase() ?? '').contains(query.toLowerCase()))
          .toList();
    }
  }

  // Seçilen parite grubuna göre pariteleri filtrele
  void filterParitiesByGroup(int parityGroupId) {
    selectedParityGroup.value = parityGroupId;
    _filterCustomerParities();
  }

  // Müşteri paritelerini filtreleme
  void _filterCustomerParities() {
    if (customerParitySearchQuery.value.isEmpty && selectedParityGroup.value == 0) {
      filteredCustomerParities.value = customerParities;
      return;
    }

    List<CParityViewModel> filtered = [...customerParities];

    // Arama sorgusuna göre filtrele
    if (customerParitySearchQuery.value.isNotEmpty) {
      filtered = filtered
          .where((parity) =>
      parity.name.toLowerCase().contains(customerParitySearchQuery.value.toLowerCase()) ||
          parity.symbol.toLowerCase().contains(customerParitySearchQuery.value.toLowerCase()))
          .toList();
    }

    // Parite grubuna göre filtrele
    if (selectedParityGroup.value != 0) {
      filtered = filtered
          .where((parity) => parity.parityGroupId == selectedParityGroup.value)
          .toList();
    }

    filteredCustomerParities.value = filtered;
  }

  // Parite görünürlüğünü değiştir
  Future<void> toggleParityVisibility(int parityId, bool isVisible) async {
    isLoading.value = true;
    error.value = '';

    // Parity rule'u ara
    final existingRule = parityRules.firstWhereOrNull((rule) => rule.parityId == parityId);

    if (existingRule != null) {
      // Varolan rule'u güncelle
      final model = CParityRuleUpdateModel(
        isVisible: isVisible,
        spreadRuleType: existingRule.spreadRuleType,
        spreadForAsk: existingRule.spreadForAsk,
        spreadForBid: existingRule.spreadForBid,
      );

      final response = await _service.updateParityRule(id: existingRule.id, model: model);

      if (response.success) {
        await fetchParityRules();
        await fetchCustomerParities();
      } else {
        error.value = response.message ?? 'Görünürlük değiştirilemedi';
      }
    } else {
      // Yeni rule oluştur
      final model = CParityRuleCreateModel(
        customerId: customerId.value,
        parityId: parityId,
        isVisible: isVisible,
        spreadRuleType: null,
        spreadForAsk: null,
        spreadForBid: null,
      );

      final response = await _service.createParityRule(model: model);

      if (response.success) {
        await fetchParityRules();
        await fetchCustomerParities();
      } else {
        error.value = response.message ?? 'Görünürlük değiştirilemedi';
      }
    }

    isLoading.value = false;
  }

  // Parite grubu görünürlüğünü değiştir
  Future<void> toggleParityGroupVisibility(int parityGroupId, bool isVisible) async {
    isLoading.value = true;
    error.value = '';

    // Parite grup rule'u ara
    final existingRule =
        parityGroupRules.firstWhereOrNull((rule) => rule.parityGroupId == parityGroupId);

    if (existingRule != null) {
      // Varolan rule'u güncelle
      final model = CParityGroupRuleUpdateModel(
        isVisible: isVisible,
      );

      final response = await _service.updateParityGroupRule(id: existingRule.id, model: model);

      if (response.success) {
        await fetchParityGroupRules();
        await fetchCustomerParityGroups();
      } else {
        error.value = response.message ?? 'Grup görünürlüğü değiştirilemedi';
      }
    } else {
      // Yeni rule oluştur
      final model = CParityGroupRuleCreateModel(
        customerId: customerId.value,
        parityGroupId: parityGroupId,
        isVisible: isVisible,
      );

      final response = await _service.createParityGroupRule(model: model);

      if (response.success) {
        await fetchParityGroupRules();
        await fetchCustomerParityGroups();
      } else {
        error.value = response.message ?? 'Grup görünürlüğü değiştirilemedi';
      }
    }

    isLoading.value = false;
  }

  // Müşteri Paritelerini getir
  Future<void> fetchCustomerParities() async {
    isLoading.value = true;
    error.value = '';

    final response = await _service.getCustomerParities();

    if (response.success) {
      customerParities.value = response.data ?? [];
      filteredCustomerParities.value = customerParities;
    } else {
      error.value = response.message ?? 'Döviz kurları yüklenemedi';
    }

    isLoading.value = false;
  }

  // Müşteri Parite Gruplarını getir
  Future<void> fetchCustomerParityGroups() async {
    isLoading.value = true;
    error.value = '';

    final response = await _service.getCustomerParityGroups();

    if (response.success) {
      customerParityGroups.value = response.data ?? [];
      filteredCustomerParityGroups.value = customerParityGroups;
    } else {
      error.value = response.message ?? 'Döviz kuru grupları yüklenemedi';
    }

    isLoading.value = false;
  }

  // Parity Kurallarını getir
  Future<void> fetchParityRules() async {
    isLoading.value = true;
    error.value = '';

    final response = await _service.getParityRulesByCustomerId(customerId.value);

    if (response.success) {
      parityRules.value = response.data ?? [];
    } else {
      error.value = response.message ?? 'Döviz kuru kuralları yüklenemedi';
    }

    isLoading.value = false;
  }

  // Parity Grup Kurallarını getir
  Future<void> fetchParityGroupRules() async {
    isLoading.value = true;
    error.value = '';

    final response = await _service.getParityGroupRulesByCustomerId(customerId.value);

    if (response.success) {
      parityGroupRules.value = response.data ?? [];
    } else {
      error.value = response.message ?? 'Döviz kuru grubu kuralları yüklenemedi';
    }

    isLoading.value = false;
  }

  // Parite kuralı oluştur
  Future<void> createParityRule(int parityId) async {
    isLoading.value = true;
    error.value = '';

    final model = CParityRuleCreateModel(
      customerId: customerId.value,
      parityId: parityId,
      isVisible: parityRuleIsVisible.value,
      spreadRuleType: parityRuleSpreadType.value,
      spreadForAsk: parityRuleSpreadForAsk.value,
      spreadForBid: parityRuleSpreadForBid.value,
    );

    final response = await _service.createParityRule(model: model);

    if (response.success) {
      await fetchParityRules();
      await fetchCustomerParities();
      _resetForm();
    } else {
      error.value = response.message ?? 'Döviz kuru kuralı eklenemedi';
    }

    isLoading.value = false;
  }

  // Parite kuralını güncelle
  Future<void> updateParityRule(int id) async {
    isLoading.value = true;
    error.value = '';

    final model = CParityRuleUpdateModel(
      isVisible: parityRuleIsVisible.value,
      spreadRuleType: parityRuleSpreadType.value,
      spreadForAsk: parityRuleSpreadForAsk.value,
      spreadForBid: parityRuleSpreadForBid.value,
    );

    final response = await _service.updateParityRule(id: id, model: model);

    if (response.success) {
      await fetchParityRules();
      await fetchCustomerParities();
      _resetForm();
    } else {
      error.value = response.message ?? 'Döviz kuru kuralı güncellenemedi';
    }

    isLoading.value = false;
  }

  // Parite kuralını sil
  Future<void> deleteParityRule(int id) async {
    isLoading.value = true;
    error.value = '';

    final response = await _service.deleteParityRule(id);

    if (response.success) {
      fetchParityRules(); // Kuralları yeniden yükle
    } else {
      error.value = response.message ?? 'Döviz kuru kuralı silinemedi';
    }

    isLoading.value = false;
  }

  // Parite grup kuralı oluştur
  Future<void> createParityGroupRule(int parityGroupId) async {
    isLoading.value = true;
    error.value = '';

    final model = CParityGroupRuleCreateModel(
      customerId: customerId.value,
      parityGroupId: parityGroupId,
      isVisible: parityGroupRuleIsVisible.value,
    );

    final response = await _service.createParityGroupRule(model: model);

    if (response.success) {
      Get.back(); // Formu kapat
      fetchParityGroupRules(); // Kuralları yeniden yükle
      _resetForm(); // Formu sıfırla
    } else {
      error.value = response.message ?? 'Döviz kuru grubu kuralı eklenemedi';
    }

    isLoading.value = false;
  }

  // Parite grup kuralını güncelle
  Future<void> updateParityGroupRule(int id) async {
    isLoading.value = true;
    error.value = '';

    final model = CParityGroupRuleUpdateModel(
      isVisible: parityGroupRuleIsVisible.value,
    );

    final response = await _service.updateParityGroupRule(id: id, model: model);

    if (response.success) {
      Get.back(); // Formu kapat
      fetchParityGroupRules(); // Kuralları yeniden yükle
      _resetForm(); // Formu sıfırla
    } else {
      error.value = response.message ?? 'Döviz kuru grubu kuralı güncellenemedi';
    }

    isLoading.value = false;
  }

  // Parite grup kuralını sil
  Future<void> deleteParityGroupRule(int id) async {
    isLoading.value = true;
    error.value = '';

    final response = await _service.deleteParityGroupRule(id);

    if (response.success) {
      fetchParityGroupRules(); // Kuralları yeniden yükle
    } else {
      error.value = response.message ?? 'Döviz kuru grubu kuralı silinemedi';
    }

    isLoading.value = false;
  }

  // Kural için form değerlerini ayarla
  void setParityRuleFormValues(CParityRuleViewModel rule) {
    parityRuleIsVisible.value = rule.isVisible;
    parityRuleSpreadType.value = rule.spreadRuleType;
    parityRuleSpreadForAsk.value = rule.spreadForAsk;
    parityRuleSpreadForBid.value = rule.spreadForBid;
  }

  // Grup kuralı için form değerlerini ayarla
  void setParityGroupRuleFormValues(CParityGroupRuleViewModel rule) {
    parityGroupRuleIsVisible.value = rule.isVisible;
  }

  // Formu sıfırla
  void _resetForm() {
    parityRuleIsVisible.value = true;
    parityRuleSpreadType.value = null;
    parityRuleSpreadForAsk.value = null;
    parityRuleSpreadForBid.value = null;
    parityGroupRuleIsVisible.value = true;
  }
}
