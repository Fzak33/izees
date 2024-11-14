

import 'package:flutter/material.dart';
import 'package:izees/features/admin/add_product/screens/add_product_screen.dart';
import 'package:izees/features/admin/add_product/screens/update_product_screen.dart';
import 'package:izees/features/admin/bottom_bar_nav/screens/bottom_bar_nav_screen.dart';
import 'package:izees/features/auth/screens/login_screen.dart';
import 'package:izees/features/driver/screens/detailed_order/detailed_order_screen.dart';
import 'package:izees/features/driver/screens/driver_order_list/driver_order_list_screen.dart';
import 'package:izees/features/user/home/screens/home_sceen.dart';
import 'package:izees/features/user/izees/screens/product_detailed_screen.dart';
import 'package:izees/features/user/settings/screens/about_izees_screen.dart';
import 'package:izees/features/user/settings/screens/about_me_screen.dart';
import 'package:izees/models/order.dart';
import 'package:izees/models/product_model.dart';

import 'features/auth/screens/signin_screen.dart';
import 'features/user/cart/screens/add_address_screen.dart';
import 'features/user/cart/widgets/price_details_widget.dart';
import 'features/user/izees/screens/category_product_screen.dart';
import 'features/user/settings/screens/become_a_seller_screen.dart';


Route<dynamic> generateRoute(RouteSettings routeSettings){
  switch(routeSettings.name) {
    case  LoginScreen.routeName:
     // var resetAppKey = routeSettings.arguments as VoidCallback? ?? () {};


      return MaterialPageRoute(

  builder: (_) => const LoginScreen()
  );
    case  AboutMeScreen.routeName:
    // var resetAppKey = routeSettings.arguments as VoidCallback? ?? () {};


      return MaterialPageRoute(

          builder: (_) => const AboutMeScreen()
      );
    case  AboutIzeesScreen.routeName:
    // var resetAppKey = routeSettings.arguments as VoidCallback? ?? () {};


      return MaterialPageRoute(

          builder: (_) => const AboutIzeesScreen()
      );
    case  SignInScreen.routeName:
      return MaterialPageRoute(

          builder: (_) =>const SignInScreen()
      );
    case  HomeScreen.routeName:
      return MaterialPageRoute(

          builder: (_) => const HomeScreen()
      );
    case  BottomBarNavScreen.routeName:
      return MaterialPageRoute(

          builder: (_) => const BottomBarNavScreen()
      );
    case  AddProductScreen.routeName:
      return MaterialPageRoute(

          builder: (_) => const AddProductScreen()
      );
    case  BecomeASellerScreen.routeName:
      return MaterialPageRoute(

          builder: (_) => const BecomeASellerScreen()
      );
    case  AddAddressScreen.routeName:
      return MaterialPageRoute(

          builder: (_) => const AddAddressScreen()
      );
      case  PriceDetailsWidget.routeName:
        final arguments = routeSettings.arguments as Map<String, dynamic>;
        final double totalPrice = arguments['totalPrice'] ?? 0.0;
        final int driverPrice = arguments['driverPrice'] ?? 0;

        return MaterialPageRoute(

        builder: (_) =>  PriceDetailsWidget(
          totalPrice: totalPrice,
          driverPrice: driverPrice,
        )
    );
    case  DriverOrderListScreen.routeName:

      return MaterialPageRoute(

          builder: (_) =>  const DriverOrderListScreen()
      );
    case  DetailedOrderScreen.routeName:
      var order = routeSettings.arguments as Order;
      return MaterialPageRoute(

          builder: (_) =>   DetailedOrderScreen(order: order,)
      );
    case  ProductDetailedScreen.routeName:
      var product = routeSettings.arguments as Product;
      return MaterialPageRoute(

          builder: (_) =>   ProductDetailedScreen(product: product,)
      );
    case  CategoryProductScreen.routeName:
      var category = routeSettings.arguments as String;
      return MaterialPageRoute(

          builder: (_) =>   CategoryProductScreen(category: category,)
      );
    case  UpdateProductScreen.routeName:
      var productId = routeSettings.arguments as String;

      return MaterialPageRoute(

          builder: (_) =>    UpdateProductScreen(productId: productId,)
      );
  default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Screen does not exist'),
          ),
        )
        ,);
  }
}


