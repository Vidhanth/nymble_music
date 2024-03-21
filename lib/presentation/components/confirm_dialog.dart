// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:nymble_music/helpers/navigation_helper.dart';
import 'package:nymble_music/presentation/components/button.dart';
import 'package:nymble_music/presentation/constants/styles.dart';

class ConfirmDialog extends StatelessWidget {
  final String title, message;
  final String? positiveText, negativeText;
  final bool isMandatory;
  final Function? onConfirm;
  final List<Widget>? customActions;
  final bool isTextSelectable;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.positiveText,
    this.negativeText,
    this.isMandatory = false,
    this.onConfirm,
    this.customActions,
    this.isTextSelectable = false,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: montserratText.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          if (message.isNotEmpty) ...[
            const SizedBox(
              height: 10,
            ),
            isTextSelectable
                ? SelectableText(
                    message,
                    textAlign: TextAlign.center,
                    style: montserratText.copyWith(
                      fontSize: 16,
                    ),
                  )
                : Text(
                    message,
                    textAlign: TextAlign.center,
                    style: montserratText.copyWith(
                      fontSize: 16,
                    ),
                  ),
          ],
          const SizedBox(
            height: 15,
          ),
          ...(customActions ??
              [
                Button(
                  label: positiveText ?? 'Yes',
                  onTap: () async {
                    await onConfirm?.call();
                    NavigationHelper.back(result: true, context);
                  },
                ),
                SizedBox(
                  height: !isMandatory ? 5 : 10,
                ),
                if (!isMandatory)
                  Center(
                    child: TextButton(
                      onPressed: () {
                        NavigationHelper.back(result: false, context);
                      },
                      child: Text(
                        negativeText ?? 'No',
                        style: montserratText,
                      ),
                    ),
                  ),
              ]),
        ],
      ),
    );
  }
}

Future<bool> showConfirmDialog(
  BuildContext context,
  String title,
  String message, {
  String? positiveText,
  String? negativeText,
  Function? onConfirm,
  bool isMandatory = false,
  List<Widget>? customActions,
  bool isTextSelectable = false,
}) async {
  return await showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        context: context,
        builder: (context) {
          return ConfirmDialog(
            title: title,
            message: message,
            positiveText: positiveText,
            negativeText: negativeText,
            isMandatory: isMandatory,
            onConfirm: onConfirm,
            customActions: customActions,
            isTextSelectable: isTextSelectable,
          );
        },
      ) ??
      false;
}
