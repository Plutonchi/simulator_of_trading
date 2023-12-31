import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class Balance extends StatefulWidget {
  Function(int)? onBalanceChanged;

  Balance({Key? key, this.onBalanceChanged}) : super(key: key);

  @override
  State<Balance> createState() => BalanceState();
}

class BalanceState extends State<Balance> {
  int userBalance = 10000;

  @override
  void initState() {
    super.initState();
    initializeBalance();
    startDailyTask();
  }

  // Установка начального баланса
  void initializeBalance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userBalance = prefs.getInt('balance') ?? 10000;
    });
  }

  // Запуск ежедневной задачи
  void startDailyTask() {
    const oneDay = const Duration(days: 1);
    Timer.periodic(oneDay, (Timer t) {
      // Ваш код для увеличения баланса
      increaseBalance();
    });
  }

  // Логика увеличения баланса
  void increaseBalance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (mounted) {
      setState(() {
        userBalance += 1000;
        prefs.setInt('balance', userBalance);
        print('$userBalance tvoy balance');
        widget.onBalanceChanged?.call(userBalance);
      });

      // Уведомляем слушателей об изменении баланса
    }
  }

// Пример функции трейдинг баланса в BalanceState
  void tradeBalance(int amount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        int updatedBalanceValue = userBalance + amount;
        // Check if the updated balance is less than 0
        if (updatedBalanceValue < 0) {
          updatedBalanceValue = 0;
        }
        prefs.setInt('balance', updatedBalanceValue); // Исправлена эта строка
        userBalance = updatedBalanceValue;
        widget.onBalanceChanged?.call(updatedBalanceValue);
        print('$userBalance - новый баланс');
      });
    }
  }

// Пример функции уменьшения баланса в BalanceState
  void decreaseBalance(int amount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        int updatedBalanceValue = userBalance - amount;
        // Check if the updated balance is less than 0
        if (updatedBalanceValue < 0) {
          updatedBalanceValue = 0;
        }
        prefs.setInt('balance', updatedBalanceValue); // Исправлена эта строка
        userBalance = updatedBalanceValue;
        widget.onBalanceChanged?.call(updatedBalanceValue);
        print('$userBalance - новый баланс');
      });
    }
  }

  @override
  void dispose() {
    increaseBalance();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Your balance',
          textAlign: TextAlign.right,
          style: TextStyle(
            color: Color(0xFF02E206),
            fontSize: 13,
            fontFamily: 'SFProText',
            fontWeight: FontWeight.w300,
            height: 0,
            letterSpacing: 0.26,
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          '$userBalance',
          textAlign: TextAlign.right,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'SFProText',
            fontWeight: FontWeight.w500,
            height: 0,
            letterSpacing: 0.32,
          ),
        ),
      ],
    );
  }
}
