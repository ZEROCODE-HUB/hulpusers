import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'davi_plata_registro_model.dart';
export 'davi_plata_registro_model.dart';

class DaviPlataRegistroWidget extends StatefulWidget {
  const DaviPlataRegistroWidget({super.key});

  static String routeName = 'DaviPlataRegistro';
  static String routePath = '/daviPlataRegistro';

  @override
  State<DaviPlataRegistroWidget> createState() =>
      _DaviPlataRegistroWidgetState();
}

class _DaviPlataRegistroWidgetState extends State<DaviPlataRegistroWidget> {
  late DaviPlataRegistroModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DaviPlataRegistroModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.aceptaceToken2 = await actions.getAcceptanceToken(
        FFDevEnvironmentValues().publicKey,
        FFDevEnvironmentValues().isProduction,
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 54.0,
            icon: FaIcon(
              FontAwesomeIcons.angleLeft,
              color: Color(0xFF7C766C),
              size: 24.0,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          title: Text(
            'Daviplata',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.interTight(
                    fontWeight:
                        FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                  ),
                  color: Color(0xFF7C766C),
                  fontSize: 18.0,
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                  fontStyle:
                      FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 0.1,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  height: MediaQuery.sizeOf(context).height * 0.8,
                  child: custom_widgets.DaviplataVerificationWidget(
                    width: MediaQuery.sizeOf(context).width * 1.0,
                    height: MediaQuery.sizeOf(context).height * 0.8,
                    publicKey: FFDevEnvironmentValues().publicKey,
                    privateKey: FFDevEnvironmentValues().privateKey,
                    acceptanceToken: getJsonField(
                      _model.aceptaceToken2,
                      r'''$.acceptanceToken''',
                    ).toString(),
                    acceptPersonalAuth: '1234',
                    onSuccess: (paymentSourceId, tokenId) async {
                      // Guardar el método de pago Daviplata recién creado en Wompi.
                      await MetodosPagoTable().insert({
                        'usuario_id': currentUserUid,
                        'payment_source_id': paymentSourceId,
                        'tipo': 'DAVIPLATA',
                        'estado': 'Activo',
                        'email_cliente': valueOrDefault<String>(
                          currentUserEmail,
                          'admin@hulp.com',
                        ),
                        'tipo_cuenta': 'DAVIPLATA',
                        'numero_producto': tokenId,
                        'es_predeterminado': true,
                      });
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Daviplata vinculado correctamente',
                            style: TextStyle(
                              color: FlutterFlowTheme.of(context).primaryText,
                            ),
                          ),
                          duration: Duration(milliseconds: 3000),
                          backgroundColor: FlutterFlowTheme.of(context).primary,
                        ),
                      );
                      context.pop();
                    },
                    onError: (error) async {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
