import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventaris/entities/dispositivo.dart';
import 'package:inventaris/screens/dashboard_screen.dart';
import 'package:inventaris/screens/desabilitado_screen.dart';
import 'package:inventaris/shared/globals.dart';
import 'package:inventaris/utils//app_http.dart' as AppHttp;
import 'package:inventaris/utils/app_toast_notification.dart';
import 'package:inventaris/utils/constants.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class DeviceInfo extends StatefulWidget {
  const DeviceInfo({super.key});

  @override
  State<DeviceInfo> createState() => _DeviceInfoState();
}

class _DeviceInfoState extends State<DeviceInfo> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  late bool habilitado;
  bool finalizou_teste = false;
  String idDispositivo = "";
  String modeloDispositivo = "";
  String fabricanteDispositivo = "";
  String titulo = "";
  String mensagem = "";

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      // 'version.securityPatch': build.version.securityPatch,
      // 'version.sdkInt': build.version.sdkInt,
      // 'version.release': build.version.release,
      // 'version.previewSdkInt': build.version.previewSdkInt,
      // 'version.incremental': build.version.incremental,
      // 'version.codename': build.version.codename,
      // 'version.baseOS': build.version.baseOS,
      // 'board': build.board,
      // 'bootloader': build.bootloader,
      // 'brand': build.brand,
      // 'device': build.device,
      // 'display': build.display,
      // 'fingerprint': build.fingerprint,
      // 'hardware': build.hardware,
      // 'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      // 'product': build.product,
      // 'supported32BitAbis': build.supported32BitAbis,
      // 'supported64BitAbis': build.supported64BitAbis,
      // 'supportedAbis': build.supportedAbis,
      // 'tags': build.tags,
      // 'type': build.type,
      // 'isPhysicalDevice': build.isPhysicalDevice,
      // 'systemFeatures': build.systemFeatures,
      // 'serialNumber': build.serialNumber,
      // 'isLowRamDevice': build.isLowRamDevice,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  Map<String, dynamic> _readLinuxDeviceInfo(LinuxDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'version': data.version,
      'id': data.id,
      'idLike': data.idLike,
      'versionCodename': data.versionCodename,
      'versionId': data.versionId,
      'prettyName': data.prettyName,
      'buildId': data.buildId,
      'variant': data.variant,
      'variantId': data.variantId,
      'machineId': data.machineId,
    };
  }

  Map<String, dynamic> _readWebBrowserInfo(WebBrowserInfo data) {
    return <String, dynamic>{
      'browserName': data.browserName.name,
      'appCodeName': data.appCodeName,
      'appName': data.appName,
      'appVersion': data.appVersion,
      'deviceMemory': data.deviceMemory,
      'language': data.language,
      'languages': data.languages,
      'platform': data.platform,
      'product': data.product,
      'productSub': data.productSub,
      'userAgent': data.userAgent,
      'vendor': data.vendor,
      'vendorSub': data.vendorSub,
      'hardwareConcurrency': data.hardwareConcurrency,
      'maxTouchPoints': data.maxTouchPoints,
    };
  }

  Map<String, dynamic> _readMacOsDeviceInfo(MacOsDeviceInfo data) {
    return <String, dynamic>{
      'computerName': data.computerName,
      'hostName': data.hostName,
      'arch': data.arch,
      'model': data.model,
      'kernelVersion': data.kernelVersion,
      'majorVersion': data.majorVersion,
      'minorVersion': data.minorVersion,
      'patchVersion': data.patchVersion,
      'osRelease': data.osRelease,
      'activeCPUs': data.activeCPUs,
      'memorySize': data.memorySize,
      'cpuFrequency': data.cpuFrequency,
      'systemGUID': data.systemGUID,
    };
  }

  Map<String, dynamic> _readWindowsDeviceInfo(WindowsDeviceInfo data) {
    return <String, dynamic>{
      'numberOfCores': data.numberOfCores,
      'computerName': data.computerName,
      'systemMemoryInMegabytes': data.systemMemoryInMegabytes,
      'userName': data.userName,
      'majorVersion': data.majorVersion,
      'minorVersion': data.minorVersion,
      'buildNumber': data.buildNumber,
      'platformId': data.platformId,
      'csdVersion': data.csdVersion,
      'servicePackMajor': data.servicePackMajor,
      'servicePackMinor': data.servicePackMinor,
      'suitMask': data.suitMask,
      'productType': data.productType,
      'reserved': data.reserved,
      'buildLab': data.buildLab,
      'buildLabEx': data.buildLabEx,
      'digitalProductId': data.digitalProductId,
      'displayVersion': data.displayVersion,
      'editionId': data.editionId,
      'installDate': data.installDate,
      'productId': data.productId,
      'productName': data.productName,
      'registeredOwner': data.registeredOwner,
      'releaseId': data.releaseId,
      'deviceId': data.deviceId,
    };
  }

  @override
  void initState() {

    Future<Map<String, dynamic>> responseDeviceData = initPlatformState();
    responseDeviceData.then((deviceData) {
      _deviceData = deviceData;
      idDispositivo = deviceData['id'];
      modeloDispositivo = deviceData['model'];
      fabricanteDispositivo = deviceData['manufacturer'];
      Future<Map<String, dynamic>> resultado =
          _refreshDspositivo(idDispositivo);
      resultado.then((resposta) {
        // Dispositivo localizado
        if (resposta.length > 0) {
          setState(() {
            habilitado = resposta.length > 0 &&
                resposta['status'] &&
                resposta['cpf'] != null &&
                resposta['cpf'] != "" &&
                resposta['nome'] != null &&
                resposta['nome'] != "";
            if (!habilitado){
              print(resposta['status']);
              if (resposta['cpf'] != null &&
                  resposta['cpf'] != "" &&
                  resposta['nome'] != null &&
                  resposta['nome'] != ""){
                titulo = "Seu celular não esta autorizado.";
                mensagem = "Favor entrar em contato com o administrador e informe os dados abaixo.";
              }
              else {
                titulo = "Seu celular não esta habilitado.";
                mensagem = "Favor entrar em contato com o administrador e informe os dados abaixo.";
              }
            }
            Globals().esteDispositivo = Dispositivo.fromMap(resposta);
            finalizou_teste = true;
          });
        }
        // Dispositivo não localizado
        else {
          Dispositivo novoDispositivo = Dispositivo(
              id: idDispositivo,
              modelo: modeloDispositivo,
              fabricante: fabricanteDispositivo,
              status: false,
              is_adm: false);
          Globals().esteDispositivo = novoDispositivo;

          var endPoint = '/api/dispositivo';
          var responseAddDevice = AppHttp.post(endPoint, novoDispositivo);

          responseAddDevice.then((response) {
            setState(() {
              if (response.statusCode == 200) {
                print(response.body);
                titulo = "Seu celular não esta habilitado.";
                mensagem = "Favor entrar em contato com o administrador e informe os dados abaixo.";
                // AppToastNotification.success(
                //     text: "Dispositivo gravado com sucesso", context: context);
              } else {
                if (response.statusCode == 404) {
                  titulo = "Houve um erro (404).";
                  mensagem = "Favor entrar em contato com o administrador e informe os dados abaixo.";
                  // AppToastNotification.error(
                  //     text: "Houve um erro (404). Contate o administrador.",
                  //     context: context);
                } else {
                  titulo = 'Request failed with status: ${response.statusCode}.';
                  mensagem = "Favor entrar em contato com o administrador e informe os dados abaixo.";
                  // AppToastNotification.error(
                  //     text: 'Request failed with status: ${response.statusCode}.',
                  //     context: context);
                  print('Request failed with status: ${response.body}.');
                  throw Exception('Erro ao tentar acessar servidor externo');
                }
              }
              habilitado = false;
              finalizou_teste = true;
            });
          });
        }
      }).catchError((onError) {
        setState(() {
          habilitado = false;
          finalizou_teste = true;
          titulo = 'Problemas de acesso ao servidor da aplicação.';
          mensagem = "Favor verificar sua conexão com a internet.";
        });
        // AppToastNotification.error(
        //     text: mensagem,
        //     context: context);
        print("------------------- ERROR -------------------");
        print(onError);
        print("---------------------------------------------");
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return finalizou_teste == false
        ? Scaffold(
            appBar: AppBar(
              title: Text(kTitulo),
            ),
            // drawer: MyDrawer(),
            body: Center(
              child: LoadingAnimationWidget.inkDrop(
                color: Theme.of(context).colorScheme.inversePrimary,
                size: 200,
              ),
            ))
        : habilitado
            ? DashoardTab()
            : DesabilitadoTab(
                dadosDispositivo: _deviceData, titulo: titulo, mensagem: mensagem,
              );
  }

  Future<Map<String, dynamic>> initPlatformState() async {
    var deviceData = <String, dynamic>{};

    try {
      if (kIsWeb) {
        deviceData = _readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);
      } else {
        deviceData = switch (defaultTargetPlatform) {
          TargetPlatform.android =>
            _readAndroidBuildData(await deviceInfoPlugin.androidInfo),
          TargetPlatform.iOS =>
            _readIosDeviceInfo(await deviceInfoPlugin.iosInfo),
          TargetPlatform.linux =>
            _readLinuxDeviceInfo(await deviceInfoPlugin.linuxInfo),
          TargetPlatform.windows =>
            _readWindowsDeviceInfo(await deviceInfoPlugin.windowsInfo),
          TargetPlatform.macOS =>
            _readMacOsDeviceInfo(await deviceInfoPlugin.macOsInfo),
          TargetPlatform.fuchsia => <String, dynamic>{
              'Error:': 'Fuchsia platform isn\'t supported'
            },
        };
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return <String, dynamic>{};

    return deviceData;
  }

  String _getAppBarTitle() => kIsWeb
      ? 'Web Browser info'
      : switch (defaultTargetPlatform) {
          TargetPlatform.android => 'Android Device Info',
          TargetPlatform.iOS => 'iOS Device Info',
          TargetPlatform.linux => 'Linux Device Info',
          TargetPlatform.windows => 'Windows Device Info',
          TargetPlatform.macOS => 'MacOS Device Info',
          TargetPlatform.fuchsia => 'Fuchsia Device Info',
        };

  // retorna bens para o tipo e texto do filtro
  Future<Map<String, dynamic>> _refreshDspositivo(String idDispositivo) async {
    var endPoint = '/api/dispositivo/' + idDispositivo;
    return AppHttp.get(endPoint);
  }
}
