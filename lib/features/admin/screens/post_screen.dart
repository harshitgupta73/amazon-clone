import 'package:amazon_clone/common/widgets/loader.dart';
import 'package:amazon_clone/features/account/widgets/single_dart.dart';
import 'package:amazon_clone/features/admin/screens/add_product_screen.dart';
import 'package:amazon_clone/features/admin/services/admin_services.dart';
import 'package:amazon_clone/features/product_details_screen/screen/product_details_screen.dart';
import 'package:amazon_clone/model/product_model.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final AdminServices adminServices = AdminServices();
  List<Product>? products;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  fetchProducts() async {
    products = await adminServices.fetchAllProducts(context);
    setState(() {});
  }

  deleteProducts(Product product, int index) {
    adminServices.deleteProduct(
      context: context,
      product: product,
      onSuccess: () {
        products!.removeAt(index);
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          products == null
              ? Loader()
              : Scaffold(
                body: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: products!.length,
                  itemBuilder: (context, index) {
                    final productData = products![index];
                    return InkWell(
                      onTap:() => Navigator.pushNamed(
                        context,
                        ProductDetailsScreen.routeName,
                        arguments: productData,
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 130,
                            child: SingleProduct(src: productData.images[0]),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  productData.name,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                              IconButton(
                                onPressed:
                                    () => deleteProducts(productData, index),
                                icon: Icon(Icons.delete_outlined),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddProductScreen.routeName);
        },
        tooltip: "Add a Product",
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
