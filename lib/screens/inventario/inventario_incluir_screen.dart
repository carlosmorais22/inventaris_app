import 'package:flutter/material.dart';
import 'package:inventaris/entities/bem.dart';
import 'package:inventaris/entities/inventario.dart';
import 'package:inventaris/screens/common_widgets/form_step_screen.dart';
import 'package:inventaris/screens/inventario/components/inventario_incluir_situacao.dart';
import 'package:inventaris/shared/globals.dart';

class InventarioIncluirScreen extends StatefulWidget {
  final VoidCallback callback;
  final Bem bem;

  const InventarioIncluirScreen(
      {super.key, required this.callback, required this.bem});

  @override
  InventarioIncluirScreenState createState() => InventarioIncluirScreenState();
}

class InventarioIncluirScreenState extends State<InventarioIncluirScreen> {
  List<bool> listStatus = [true, false, false, false, false, false];
  int numberSteps = 6;

  @override
  void initState() {
    Globals().inventario =
        Inventario(ano: 2024, bem: widget.bem.id, situacao: 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int activeStep = 0;
    return FormStepScreen(
      title: "Inventariar Bem",
      openScreen: _openScreen,
      listStatus: listStatus,
      callbackRegister: _register,
      numberSteps: 6,
      stepControlView: true,
      activeStep: activeStep,
    );
  }

  refreshStatusSteps() {
    Inventario loan = Globals().inventario;
    setState(() {
      listStatus[0] = true;
      listStatus[1] = true;
      // listStatus[2] = Globals().amount > 0;
      // listStatus[3] = loan.rate > 0 && loan.number_installments > 0;
      // listStatus[4] = DateUtil.daysDifference(
      //         DateTime.parse(loan.date), DateTime.parse(Globals().dueDate)) >=
      //     10;
      // listStatus[5] =
      //     listStatus[0] && listStatus[2] && listStatus[3] && listStatus[4];
    });
  }

  _register() {}

  _openScreen(int id) {
    switch (id) {
      case 0:
        return InventarisIncluirSituacao(
            refreshStatusSteps: refreshStatusSteps);
      //   case 1:
      //     return LoanAddDate(refreshStatusSteps: refreshStatusSteps);
      //   case 2:
      //     return LoanAddAmount(refreshStatusSteps: refreshStatusSteps);
      //   case 3:
      //     return LoanAddCalculationDate(refreshStatusSteps: refreshStatusSteps);
      //   case 4:
      //     return LoanAddDueDate(refreshStatusSteps: refreshStatusSteps);
      //   case 5:
      //     // refreshStatusSteps();
      //     if (Globals().amount != null) {
      //       Globals().loan.amount = Globals().amount;
      //     }
      //     bool _installmentCalculationType =
      //         Globals().installmentCalculationType == 0 ? true : false;
      //     newInstallments = Installment.calculateInstallments(
      //         Globals().loan,
      //         false,
      //         _installmentCalculationType,
      //         DateTime.tryParse(Globals().dueDate)!);
      //     return LoanAddSummary(installments: newInstallments);
    }
  }
}
