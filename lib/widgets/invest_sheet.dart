import 'package:flutter/material.dart';
import 'package:pitbowl/model/pitch.dart';

class InvestSheet extends StatefulWidget {
  const InvestSheet({super.key, required this.pitch});

  final Pitch pitch;
  @override
  State<StatefulWidget> createState() {
    return _InvestSheetState();
  }
}

class _InvestSheetState extends State<InvestSheet> {
  final TextEditingController _investmentAmountController =
      TextEditingController();

  @override
  void dispose() {
    _investmentAmountController.dispose();
    super.dispose();
  }

  void _submitInvestment() {
    final String enteredAmount = _investmentAmountController.text.trim();
    _investmentAmountController.clear();
    FocusScope.of(context).unfocus();
    // print(enteredAmount);
    if (enteredAmount.isEmpty) {
      // print("empty");
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
          alignment: Alignment.center,
          title: Text(
            "Invalid Input",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.errorContainer,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text("Please enter a valid amount.",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.normal,
              )),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text("Got it!", style: TextStyle(fontSize: 15)),
            )
          ],
        ),
      );
      return;
    }
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Investment of Rp. $enteredAmount has been submitted to ${widget.pitch.username}",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          textAlign: TextAlign.left,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
    return;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.60,
          width: double.infinity,
          child: Column(
            children: [
              Text(
                "Invest in ${widget.pitch.username}",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              ),
              const SizedBox(height: 10),
              Text("Enter the amount you want to invest",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                      ),
                  textAlign: TextAlign.center),
              const SizedBox(height: 10),
              TextField(
                controller: _investmentAmountController,
                decoration: const InputDecoration(
                  // prefixText: "Rp.",
                  prefix: Text(
                    "Rp.",
                    style: TextStyle(color: Colors.white),
                  ),
                  labelText: "Amount",
                ),
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white, fontSize: 25),
              ),
              const SizedBox(height: 20),

              // const Spacer(),
              ElevatedButton.icon(
                onPressed: () {
                  _submitInvestment();
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                      Theme.of(context).colorScheme.primary.withAlpha(255)),
                ),
                label: const Text(
                  "Invest",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      // color: Theme.of(context).colorScheme.onPrimary),
                      color: Colors.black),
                ),
                icon: const Icon(
                  Icons.paid,
                  color: Colors.black,
                ),
              ),
              // const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
