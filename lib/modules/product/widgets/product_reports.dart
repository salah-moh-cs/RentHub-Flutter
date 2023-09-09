import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/text_theme.dart';
import '../controllers/product_controller.dart';

class ProductReportsWidget extends StatelessWidget {
  const ProductReportsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
      builder: (controller) {
        final List<String> reports = controller.product.report
                ?.map((report) => report['comment'] as String?)
                .where((comment) => comment != null)
                .map((comment) => comment ?? '')
                .toList() ??
            [];
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "reports".tr,
              style: AppStyles.headLine2,
            ),
            SizedBox(height: Get.height * .02),
            if (reports.isNotEmpty)
              DataTable(
                columns: const [
                  DataColumn(label: Text("Report")),
                ],
                rows: reports
                    .asMap()
                    .entries
                    .map(
                      (entry) => DataRow(
                        cells: [
                          DataCell(Text(entry.value)),
                        ],
                      ),
                    )
                    .toList(),
              ),
            if (reports.isEmpty)
              Text(
                "Noreport".tr,
                style: const TextStyle(color: Colors.grey),
              ),
            SizedBox(height: Get.height * .02),
            reports.isEmpty
                ? const SizedBox()
                : ElevatedButton(
                    onPressed: () {
                      // Call the clearReports method on the controller
                      controller.product.clearReports();
                    },
                    child: Text('ClearAllReports'.tr),
                  ),
          ],
        );
      },
    );
  }
}
