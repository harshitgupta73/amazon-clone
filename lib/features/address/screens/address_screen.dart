import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/common/widgets/custom_textfield.dart';
import 'package:amazon_clone/constants/GlobalVariables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/address/services/address_services.dart';
import 'package:amazon_clone/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  static const String routeName = '/address';
  final String totalAmount;

  const AddressScreen({super.key, required this.totalAmount});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _addressFormKey = GlobalKey<FormState>();
  final TextEditingController _flatController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  late final PaymentConfiguration _googlePayConfigFuture;
  late final PaymentConfiguration _applePayConfig;

  List<PaymentItem> paymentItems = [];
  String addressToBeUsed = "";
  final AddressServices addressServices = AddressServices();

  void onGooglePayResult(res) {
    if (Provider.of<UserProvider>(
      context,
      listen: false,
    ).user.address.isEmpty) {
      addressServices.saveUserAddress(
        context: context,
        address: addressToBeUsed,
      );
    }
    addressServices.placeOrder(
      context: context,
      address: addressToBeUsed,
      totalSum: double.parse(widget.totalAmount),
    );
  }

  void onApplePayResult(res) {
    if (Provider.of<UserProvider>(
      context,
      listen: false,
    ).user.address.isEmpty) {
      addressServices.saveUserAddress(
        context: context,
        address: addressToBeUsed,
      );
    }
    addressServices.placeOrder(
      context: context,
      address: addressToBeUsed,
      totalSum: double.parse(widget.totalAmount),
    );
  }
  void fun(){

    final addressFromProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    ).user.address;

    try {
      payPressed(addressFromProvider); // Set addressToBeUsed first
    } catch (e) {
      showSnackbar(context, e.toString());
      return;
    }

    if (addressFromProvider.isEmpty && addressToBeUsed.isNotEmpty) {
      addressServices.saveUserAddress(
        context: context,
        address: addressToBeUsed,
      );
    }
    addressServices.placeOrder(
      context: context,
      address: addressToBeUsed,
      totalSum: double.parse(widget.totalAmount),
    );
  }

  @override
  void initState() {
    super.initState();
    paymentItems.add(
      PaymentItem(
        amount: widget.totalAmount,
        label: 'Total Amount',
        status: PaymentItemStatus.final_price,
      ),
    );
    _googlePayConfigFuture = PaymentConfiguration.fromJsonString(
      defaultGooglePay,
    );
    _applePayConfig = PaymentConfiguration.fromJsonString(defaultApplePay);
  }

  void payPressed(String addressFromProvider) {
    addressToBeUsed = "";

    bool isForm =
        _flatController.text.isNotEmpty ||
        _areaController.text.isNotEmpty ||
        _pincodeController.text.isNotEmpty ||
        _cityController.text.isNotEmpty;

    if (isForm) {
      if (_addressFormKey.currentState!.validate()) {
        addressToBeUsed =
            '${_flatController.text}, ${_areaController.text}, ${_cityController.text} - ${_pincodeController.text}';
      } else {
        throw Exception('Please enter all the values!');
      }
    } else if (addressFromProvider.isNotEmpty) {
      addressToBeUsed = addressFromProvider;
    } else {
      showSnackbar(context, 'ERROR');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _flatController.dispose();
    _areaController.dispose();
    _pincodeController.dispose();
    _cityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final address = Provider.of<UserProvider>(context).user.address;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (address.isNotEmpty)
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(address, style: TextStyle(fontSize: 18)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('OR', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 20),
                  ],
                ),

              Form(
                key: _addressFormKey,
                child: Column(
                  children: [
                    CustomTextfield(
                      controller: _flatController,
                      hintText: "Flat/ House No/ Building",
                    ),
                    const SizedBox(height: 10),
                    CustomTextfield(
                      controller: _areaController,
                      hintText: "Area / Street",
                    ),
                    const SizedBox(height: 10),
                    CustomTextfield(
                      controller: _pincodeController,
                      hintText: "Pincode",
                    ),
                    const SizedBox(height: 10),
                    CustomTextfield(
                      controller: _cityController,
                      hintText: "City",
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),

              // ApplePayButton(
              //   width: double.infinity,
              //   onPressed: () {},
              //   onPaymentResult: onApplePayResult,
              //   style: ApplePayButtonStyle.whiteOutline,
              //   type: ApplePayButtonType.buy,
              //   paymentItems: paymentItems,
              //   margin: const EdgeInsets.only(top: 15),
              //   height: 50,
              //   paymentConfiguration: _applePayConfig,
              // ),
              // const SizedBox(height: 10),
              //
              // // FutureBuilder<PaymentConfiguration>(
              // //   future: _googlePayConfigFuture,
              // //   builder:
              // //       (context, snapshot) =>
              // //           snapshot.hasData
              // //               ?
              // GooglePayButton(
              //   onPaymentResult: onGooglePayResult,
              //   paymentItems: paymentItems,
              //   width: double.infinity,
              //   cornerRadius: 15,
              //   height: 50,
              //   type: GooglePayButtonType.buy,
              //   margin: const EdgeInsets.only(top: 15),
              //   loadingIndicator: const Center(
              //     child: CircularProgressIndicator(),
              //   ),
              //   onPressed: () {},
              //   paymentConfiguration: _googlePayConfigFuture,
              //   // )
              //   // : SizedBox(height: 10),
              // ),
              
              ElevatedButton(onPressed: fun, child: Text("place Order"))
            ],
          ),
        ),
      ),
    );
  }
}
