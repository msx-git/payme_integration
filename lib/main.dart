import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uzpay/enums.dart';
import 'package:uzpay/objects.dart';
import 'package:uzpay/uzpay.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const PaymentScreen(),
      ),
      GoRoute(
        path: '/payment-success',
        builder: (context, state) => const PaymentSuccessScreen(),
      ),
    ],
    // Enable deep linking
    debugLogDiagnostics: true,
    initialLocation: '/',
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  ///Avvaliga parametrlarni belgilab olamiz
  var paymentParams = Params(
    paymeParams: PaymeParams(
      transactionParam: "1",
      merchantId: "",

      // Quyidagilar ixtiyoriy parametrlar
      accountObject: 'key',
      // Header rangi
      headerTitle: "Payme tizimi orqali to'lash",
    ),
  );

  void pay() async {
    try {
      final response = await UzPay.doPayment(
        context,
        amount: 1, // To'ov summasi
        paymentSystem: PaymentSystem.Payme,
        paymentParams: paymentParams,
        browserType: BrowserType.Internal,
      );

      debugPrint("RESPONSE: $response");
    } catch (e) {
      debugPrint("ERROR: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FilledButton(
          onPressed: pay,
          child: const Text("PAY"),
        ),
      ),
    );
  }
}

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment Success')),
      body: const Center(
        child: Text('Payment completed successfully!'),
      ),
    );
  }
}
