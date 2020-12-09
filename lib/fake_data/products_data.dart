import 'package:asu_store/models/product_model.dart';

List<ProductModel> getProducts() {
  List<ProductModel> products = new List();
  ProductModel productModel = new ProductModel();
  //1
  productModel.productName = "RAM 8 GB";
  productModel.noOfRating = 123;
  productModel.imgUrl = "https://media.rs-online.com/t_large/F1805901-01.jpg";
  productModel.rating = 4;
  productModel.price = 450;
  products.add(productModel);
  //2
  productModel = new ProductModel();
  productModel.productName = "Drill";
  productModel.noOfRating = 243;
  productModel.imgUrl =
      "https://ram-e-shop.com/wp-content/uploads/2018/09/drill_at12c_new-300x300.jpg";
  productModel.rating = 2;
  productModel.price = 900;
  products.add(productModel);
  //3
  productModel = new ProductModel();
  productModel.productName = "MSI Motherboard";
  productModel.noOfRating = 50;
  productModel.imgUrl =
      "https://www.bhphotovideo.com/images/images2500x2500/msi_trx40_pro_wifi_motherboard_1532288.jpg";
  productModel.rating = 3;
  productModel.price = 750;
  products.add(productModel);
  //4
  productModel = new ProductModel();
  productModel.productName = "AKAI Spray";
  productModel.noOfRating = 12;
  productModel.imgUrl =
      "https://images.yaoota.com/6eKvwVp-6MK4Jd-qPogcHOXlvzw=/trim/yaootaweb-production/media/crawledproductimages/de215d857be42e452b0f4cdeb2616fbb398590b3.jpg";
  productModel.rating = 4;
  productModel.price = 20;
  products.add(productModel);
  //5
  productModel = new ProductModel();
  productModel.productName = "Fan";
  productModel.noOfRating = 4;
  productModel.imgUrl =
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTR_9osesMhRHSPTtvLa8rB7GpsvjFet8cxcw&usqp=CAU";
  productModel.rating = 2;
  productModel.price = 400;
  products.add(productModel);

  return products;
}
