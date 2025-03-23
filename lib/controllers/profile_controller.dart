import 'package:get/get.dart';

enum ProfileTab { personal, orders, favorites, settings }

class ProfileController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isUpdating = false.obs;
  final RxString error = ''.obs;
  final RxString successMessage = ''.obs;
  final Rx<ProfileTab> activeTab = ProfileTab.personal.obs;

  // Individual reactive fields
  final RxString firstName = ''.obs;
  final RxString lastName = ''.obs;
  final RxString email = ''.obs;
  final RxString phone = ''.obs;
  final RxString birthday = ''.obs;
  final RxString gender = ''.obs;
  final RxString address = ''.obs;

  void changeTab(ProfileTab tab) {
    activeTab.value = tab;
  }

  // Mock data for demonstration
  void fetchProfile() async {
    isLoading.value = true;
    error.value = '';

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Update individual fields
      firstName.value = 'John';
      lastName.value = 'Doe';
      email.value = 'john.doe@example.com';
      phone.value = '+998 90 123 45 67';
      birthday.value = '1990-01-01';
      gender.value = 'male';
      address.value = 'Tashkent, Chilonzor';
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile() async {
    isUpdating.value = true;
    error.value = '';
    successMessage.value = '';

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      successMessage.value = 'Profil muvaffaqiyatli yangilandi';
    } catch (e) {
      error.value = 'Xatolik yuz berdi';
    } finally {
      isUpdating.value = false;
    }
  }

  void logout() {
    // TODO: Implement logout functionality
    Get.offAllNamed('/login');
  }
}
