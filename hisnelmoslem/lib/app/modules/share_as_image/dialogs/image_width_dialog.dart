import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hisnelmoslem/core/values/constant.dart';
import 'package:hisnelmoslem/app/shared/custom_inputs/number_field.dart';
import 'package:hisnelmoslem/app/shared/dialogs/dialog_maker.dart';

class ImageWidthDialog extends StatelessWidget {
  final Function(String) onSubmit;
  final String initialValue;

  const ImageWidthDialog({
    Key? key,
    required this.onSubmit,
    required this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController widthController =
        TextEditingController(text: initialValue);
    return DialogMaker(
      height: 270,
      header: Text(
        "تعديل عرض الصورة",
        style: TextStyle(
          fontSize: 25,
          color: mainColor,
        ),
      ),
      content: [
        const Text(
          "قم بادخال العرض وعليه يتم تحديد ارتفاع الصورة تلقائيا تبعا لحجم النص وإعدادتك",
          textAlign: TextAlign.center,
        ),
        UserNumberField(
          controller: widthController,
          hintText: "أدخل عرض الصورة",
        ),
      ],
      footer: ListTile(
        title: Text(
          "done".tr,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: mainColor),
        ),
        onTap: () {
          onSubmit(widthController.text);
          Navigator.pop<bool>(context, true);
        },
      ),
    );
  }
}
