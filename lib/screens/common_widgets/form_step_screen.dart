import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:inventaris/screens/common_widgets/custon_elevated_button.dart';
import 'package:inventaris/screens/common_widgets/custon_outlined_button.dart';
import 'package:inventaris/utils/app_alert.dart';
import 'package:inventaris/utils/constants.dart';
import 'package:keyboard_service/keyboard_service.dart';

class FormStepScreen extends StatefulWidget {
  final VoidCallback? callbackRegister;
  final Function(int id) openScreen;
  final int numberSteps;
  final int? activeStep;
  final String title;
  final bool stepControlView;
  final List<bool> listStatus;

  const FormStepScreen(
      {super.key,
      required this.title,
      required this.openScreen,
      required this.callbackRegister,
      required this.numberSteps,
      required this.listStatus,
      required this.stepControlView,
      this.activeStep = 0});

  @override
  FormStepScreenState createState() => FormStepScreenState();
}

class FormStepScreenState extends State<FormStepScreen> {
  int activeStep = 0;
  bool success = false;

  increaseProgress() {
    setState(() {
      activeStep++;
    });
  }

  @override
  void initState() {
    activeStep = widget.activeStep!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final visible = KeyboardService.isVisible(context);

    List<EasyStep> easySteps = [];
    for (int i = 0; i < widget.numberSteps; i++) {
      easySteps.add(EasyStepWidget(i));
    }

    return KeyboardAutoDismiss(
        scaffold: Scaffold(
      appBar: AppBar(
          leading: activeStep > 0
              ? IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      activeStep--;
                    });
                  },
                )
              : SizedBox(),
          titleSpacing: 0,
          title: Text(widget.title,
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onBackground)),
          elevation: 0,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _cancelar();
              },
            ),
          ]),
      body: DefaultTextStyle(
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.normal),
        child: Container(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          color: Theme.of(context).colorScheme.onBackground,
          child: Column(
            children: [
              widget.stepControlView
                  ? Container(
                      height: 40,
                      child: EasyStepper(
                          padding: EdgeInsets.only(top: 10),
                          activeStep: activeStep,
                          activeStepTextColor: Colors.black87,
                          finishedStepTextColor: Colors.black87,
                          internalPadding: 0,
                          showLoadingAnimation: false,
                          stepRadius: 11,
                          showStepBorder: false,
                          // lineDotRadius: 1.5,
                          steps: easySteps,
                          onStepReached: (index) {
                            null;
                            // setState(() {
                            //   activeStep = index;
                            // });
                          }),
                    )
                  : SizedBox(),
              Expanded(
                child: widget.openScreen(activeStep),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: activeStep > 0
                            ? CustonOutlinedButton(
                                text: kVoltar,
                                onClickBtnTap: () {
                                  setState(() {
                                    KeyboardService.dismiss();
                                    activeStep--;
                                  });
                                })
                            : const SizedBox(width: 20)),
                    SizedBox(width: 15),
                    Expanded(
                        child: activeStep == widget.numberSteps - 1
                            ? CustonElevatedButton(
                                text: kRegistrar,
                                onClickBtnTap: widget.listStatus[activeStep]
                                    ? () {
                                        widget.callbackRegister!();
                                      }
                                    : null,
                              )
                            : CustonElevatedButton(
                                text: kProximo,
                                onClickBtnTap: widget.listStatus[activeStep]
                                    ? () {
                                        setState(() {
                                          KeyboardService.dismiss();
                                          activeStep++;
                                        });
                                      }
                                    : null)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  _cancelar() {
    AppAlert.confirm(
        title: kAtencao,
        text: kMsgDesejaSair,
        context: context,
        onConfirmBtnTap: () async {
          Navigator.pop(context);
        });
  }

  EasyStep EasyStepWidget(int step,
      [String title = "", bool topTitle = false]) {
    return EasyStep(
      customStep: CircleAvatar(
        radius: 11,
        backgroundColor:
            widget.listStatus[step] ? Colors.green : Colors.grey.shade300,
        child: CircleAvatar(
            radius: 9,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 7,
              backgroundColor: activeStep == step
                  ? Colors.blue.shade200
                  : activeStep >= step
                      ? Colors.blue.shade200
                      : Colors.grey.shade300,
            )),
      ),
      title: title,
      topTitle: topTitle,
    );
  }
}
