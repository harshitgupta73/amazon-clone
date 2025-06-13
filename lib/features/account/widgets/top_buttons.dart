import 'package:amazon_clone/features/account/services/account_services.dart';
import 'package:amazon_clone/features/account/widgets/account_buttons.dart';
import 'package:flutter/material.dart';

class TopButtons extends StatelessWidget {
  const TopButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            AccountButtons(text: "Your Orders", onTap: () {}),
            AccountButtons(text: "Turn Seller", onTap: () {}),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            AccountButtons(
              text: "Log Out",
              onTap: () => AccountServices().logOut(context),
            ),
            AccountButtons(text: "Your WishList", onTap: () {}),
          ],
        ),
      ],
    );
  }
}
