import 'package:get/get.dart';

class OrderController extends GetxController {
  final RxList orders = [].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  // Mock data for demonstration
  void fetchOrders() {
    isLoading.value = true;
    error.value = '';

    try {
      // Simulating API call
      Future.delayed(const Duration(seconds: 1), () {
        orders.value = [
          {
            'id': 1,
            'order_number': '2024001',
            'created_at': DateTime.now().subtract(const Duration(days: 2)),
            'status': 'pending',
            'delivery_name': 'John Doe',
            'delivery_phone': '+998 90 123 45 67',
            'delivery_region': 'Tashkent',
            'delivery_district': 'Chilonzor',
            'delivery_address': '7-mikrorayon, 14-uy',
            'payment_method': {
              'name': 'Naqd pul orqali',
              'type': 'cash'
            },
            'payment_status': 'pending',
            'items': [
              {
                'id': 1,
                'product': {
                  'name': 'iPhone 15 Pro Max',
                  'has_user_review': false,
                },
                'product_variant': {
                  'images': [
                    'https://example.com/iphone15.jpg'
                  ],
                  'attribute_values': {
                    'Color': 'Space Black',
                    'Storage': '256GB'
                  }
                },
                'quantity': 1,
                'price': 15000000,
                'has_review': false,
              }
            ],
            'total_amount': 15000000,
            'delivery_cost': 30000,
          },
          {
            'id': 2,
            'order_number': '2024002',
            'created_at': DateTime.now().subtract(const Duration(days: 5)),
            'status': 'completed',
            'delivery_name': 'Jane Smith',
            'delivery_phone': '+998 90 987 65 43',
            'delivery_region': 'Tashkent',
            'delivery_district': 'Yunusobod',
            'delivery_address': 'Minor, 77-uy',
            'payment_method': {
              'name': 'Bank kartasi orqali',
              'type': 'card'
            },
            'payment_status': 'paid',
            'items': [
              {
                'id': 2,
                'product': {
                  'name': 'Samsung Galaxy S24 Ultra',
                  'has_user_review': true,
                },
                'product_variant': {
                  'images': [
                    'https://example.com/s24.jpg'
                  ],
                  'attribute_values': {
                    'Color': 'Titanium Gray',
                    'Storage': '512GB'
                  }
                },
                'quantity': 1,
                'price': 14000000,
                'has_review': true,
              }
            ],
            'total_amount': 14000000,
            'delivery_cost': 30000,
          }
        ];
        isLoading.value = false;
      });
    } catch (e) {
      error.value = e.toString();
      isLoading.value = false;
    }
  }

  String getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return 'yellow';
      case 'completed':
        return 'green';
      case 'new':
        return 'blue';
      case 'cancelled':
        return 'red';
      default:
        return 'grey';
    }
  }

  String getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'status_pending'.tr;
      case 'completed':
        return 'status_completed'.tr;
      case 'new':
        return 'status_new'.tr;
      case 'cancelled':
        return 'status_cancelled'.tr;
      default:
        return status;
    }
  }
}
