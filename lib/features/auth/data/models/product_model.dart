import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final int productId;
  final String productDescription;

  const ProductModel({
    required this.productId,
    required this.productDescription,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['Product_ID'] ?? 0,
      productDescription: json['Product_Description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Product_ID': productId,
      'Product_Description': productDescription,
    };
  }

  @override
  List<Object?> get props => [productId, productDescription];
}

class ProductResponseModel {
  final String message;
  final List<ProductModel> data;
  final String status;

  ProductResponseModel({
    required this.message,
    required this.data,
    required this.status,
  });

  factory ProductResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductResponseModel(
      message: json['message'] ?? '',
      data: (json['data'] as List?)
              ?.map((e) => ProductModel.fromJson(e))
              .toList() ??
          [],
      status: json['status'] ?? 'False',
    );
  }
}
