import 'package:get/get.dart';

import '../../../data/repositories/dummy_product_repository.dart';
import '../controllers/dummy_product_controller.dart';

class DummyProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DummyProductRepository>(
      () => DummyProductRepository(),
    );

    Get.lazyPut<DummyProductController>(
      () => DummyProductController(
        Get.find<DummyProductRepository>(),
      ),
    );
  }
}
