import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/features/splash/screens/splash_screen.dart';


import 'package:izees/l10n/l10n.dart';
import 'package:izees/resources/language_cubit/locale_cubit.dart';
import 'package:izees/router.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'features/admin/add_product/services/AdminProductServiceCubit/admin_product_service_cubit.dart';
import 'features/admin/admin_orders/admin_order_cubit/admin_order_cubit.dart';
import 'features/admin/admin_orders/services/admin_order_services.dart';
import 'features/admin/category_charts/services/categories_profit.dart';
import 'features/admin/category_charts/services/day_profit/day_profit_cubit.dart';
import 'features/admin/category_charts/services/month_profit/month_profit_cubit.dart';
import 'features/admin/category_charts/services/profit/profit_cubit.dart';
import 'features/admin/detailed_charts/services/daily_product_profit/daily_product_profit_cubit.dart';
import 'features/admin/detailed_charts/services/monthly_product_profit/monthly_product_profit_cubit.dart';
import 'features/admin/detailed_charts/services/product_profit/product_profit_cubit.dart';
import 'features/admin/detailed_charts/services/product_profit_services.dart';
import 'features/auth/auth_cubit/auth_cubit.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/services/auth_service.dart';
import 'features/driver/services/driver_order_cubit/change_order_status_cubit.dart';
import 'features/driver/services/driver_order_cubit/driver_order_cubit.dart';
import 'features/driver/services/driver_order_services.dart';
import 'features/user/cart/services/cart_cubit/cart_cubit.dart';
import 'features/user/cart/services/cart_services.dart';
import 'features/user/izees/services/recommended/recommended_cubit.dart';
import 'features/user/izees/services/show_category_products_cubit/show_category_products_cubit.dart';
import 'features/user/izees/services/show_product_cubit/show_products_cubit.dart';
import 'features/user/izees/services/show_product_services.dart';
import 'features/user/search/services/search_services.dart';
import 'features/user/search/services/search_services_cubit/search_cubit.dart';
import 'features/user/settings/services/seller_cubit/seller_cubit.dart';


void main() {
  runApp(
      const MyApp()

  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Key _appContentKey = UniqueKey();

  void resetAppContent() {
    setState(() {
      _appContentKey = UniqueKey();
    });
  }


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      key: _appContentKey,
        providers: [
          BlocProvider(
            create: (context) => LocaleCubit(),
          ),
          BlocProvider(
            create: (context) => AuthCubit(AuthService(), resetAppContent),
          ),
          BlocProvider(
            create: (context) => SellerCubit(),
          ),
          BlocProvider(
            create: (context) => AdminProductServiceCubit()..getAdminProduct(context: context),
          ),
          BlocProvider(
            create: (context) => ShowProductsCubit(ShowProductServices()),
          ),
          // BlocProvider(
          //   create: (context) => CartServicesCubit()..getCart(context: context),
          // ),
          BlocProvider(
            create: (context) => AdminOrderCubit(AdminOrderServices())..scheduleHourlyFetchOrder(context: context),
          ),
          BlocProvider(
            create: (context) => SearchCubit(searchServices: SearchServices()),
          ),
          BlocProvider(
            create: (context) => DriverOrderCubit()..getDriverOrder(),
          ),
          BlocProvider(
            create: (context) => ChangeStatus(DriverOrderServices()),
          ),
          // BlocProvider(
          //   create: (context) => ChangeQuantityCubit(CartServices()),
          // ),
          BlocProvider(
            create: (context) => DayProfitCubit(CategoriesProfit())..scheduleHourlyFetch(context: context),
          ),
          BlocProvider(
            create: (context) => MonthProfitCubit(CategoriesProfit())..scheduleHourlyFetch(context: context),
          ),
          BlocProvider(
            create: (context) => ProfitCubit(CategoriesProfit())..scheduleHourlyFetch(context: context),
          ),
          BlocProvider(
            create: (context) => ProductProfitCubit(ProductProfitServices())..scheduleHourlyFetch(context: context),
          ),
          BlocProvider(
            create: (context) => DailyProductProfitCubit(ProductProfitServices())..scheduleHourlyFetch(context: context),
          ),
          BlocProvider(
            create: (context) => MonthlyProductProfitCubit(ProductProfitServices())..scheduleHourlyFetch(context: context),
          ),
          BlocProvider(
            create: (context) => RecommendedCubit(ShowProductServices()),
          ),
          BlocProvider(
            create: (context) => CartCubit(CartServices())..getCart(context: context),
          ),
          BlocProvider(
            create: (context) => ShowCategoryProductsCubit(ShowProductServices()),
          ),
        ],
      child: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            supportedLocales: L10n.all,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            locale: state.locale,
            title: 'Flutter Demo',
            theme: ThemeData(
              // This is the theme of your application.
              //
              // TRY THIS: Try running your application with "flutter run". You'll see
              // the application has a purple toolbar. Then, without quitting the app,
              // try changing the seedColor in the colorScheme below to Colors.green
              // and then invoke "hot reload" (save your changes or press the "hot
              // reload" button in a Flutter-supported IDE, or press "r" if you used
              // the command line to start the app).
              //
              // Notice that the counter didn't reset back to zero; the application
              // state is not lost during the reload. To reset the state, use hot
              // restart instead.
              //
              // This works for code too, not just values: Most code changes can be
              // tested with just a hot reload.
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),

              useMaterial3: true,
            ),
            onGenerateRoute: (settings) => generateRoute(settings),
            home:SplashScreen(),

          );
        },
      ),
    );
  }
}


