import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'bancolombia_registro_model.dart';
export 'bancolombia_registro_model.dart';

class BancolombiaRegistroWidget extends StatefulWidget {
  const BancolombiaRegistroWidget({super.key});

  static String routeName = 'BancolombiaRegistro';
  static String routePath = '/bancolombiaRegistro';

  @override
  State<BancolombiaRegistroWidget> createState() =>
      _BancolombiaRegistroWidgetState();
}

class _BancolombiaRegistroWidgetState extends State<BancolombiaRegistroWidget> {
  late BancolombiaRegistroModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BancolombiaRegistroModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.bancolombiaActual = await MetodosPagoTable().queryRows(
        queryFn: (q) => q
            .eqOrNull(
              'usuario_id',
              currentUserUid,
            )
            .eqOrNull(
              'tipo',
              'BANCOLOMBIA_TRANSFER',
            ),
      );
      if (_model.bancolombiaActual?.length != 0) {
        FFAppState().idToken =
            _model.bancolombiaActual!.firstOrNull!.numeroProducto!;
        FFAppState().update(() {});
      } else {
        _model.aceptaceToken2 = await actions.getAcceptanceToken(
          FFDevEnvironmentValues().publicKey,
          FFDevEnvironmentValues().isProduction,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              getJsonField(
                _model.aceptaceToken2,
                r'''$.message''',
              ).toString(),
              style: TextStyle(
                color: FlutterFlowTheme.of(context).primaryText,
              ),
            ),
            duration: Duration(milliseconds: 4000),
            backgroundColor: FlutterFlowTheme.of(context).secondary,
          ),
        );
      }
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
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: Color(0xFFFDDA27),
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 54.0,
            icon: FaIcon(
              FontAwesomeIcons.angleLeft,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 24.0,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          title: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                decoration: BoxDecoration(),
              ),
            ],
          ),
          actions: [],
          centerTitle: true,
          elevation: 0.1,
        ),
        body: SafeArea(
          top: true,
          child: Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 100.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: CachedNetworkImage(
                        fadeInDuration: Duration(milliseconds: 500),
                        fadeOutDuration: Duration(milliseconds: 500),
                        imageUrl:
                            'https://upload.wikimedia.org/wikipedia/commons/e/e4/Logo_Bancolombia.svg',
                        height: 50.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if (FFAppState().idToken == '')
                    FFButtonWidget(
                      onPressed: () async {
                        _model.apiResultsmp =
                            await BancolombiaSandoboxCall.call();

                        if ((_model.apiResultsmp?.succeeded ?? true)) {
                          _model.idtoken = getJsonField(
                            (_model.apiResultsmp?.jsonBody ?? ''),
                            r'''$.data.id''',
                          ).toString();
                          safeSetState(() {});
                          FFAppState().idToken = getJsonField(
                            (_model.apiResultsmp?.jsonBody ?? ''),
                            r'''$.data.id''',
                          ).toString();
                          safeSetState(() {});
                          await launchURL(getJsonField(
                            (_model.apiResultsmp?.jsonBody ?? ''),
                            r'''$.data.authorization_url''',
                          ).toString());
                        }

                        safeSetState(() {});
                      },
                      text: 'Conectar con bancolombia',
                      options: FFButtonOptions(
                        height: 40.0,
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 0.0, 16.0, 0.0),
                        iconPadding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: Color(0xFFFDDA27),
                        textStyle: FlutterFlowTheme.of(context)
                            .titleSmall
                            .override(
                              font: GoogleFonts.interTight(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context).primaryText,
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .fontStyle,
                            ),
                        elevation: 0.0,
                        borderSide: BorderSide(
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  if (FFAppState().idToken != '')
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Confirma la aprobación de bancolombia',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                        ),
                        if (FFAppState().idToken != '')
                          FFButtonWidget(
                            onPressed: () async {
                              _model.verificacionToken =
                                  await BancolombiaVerificacionIDCall.call(
                                token: FFAppState().idToken,
                              );

                              if ((_model.verificacionToken?.succeeded ??
                                  true)) {
                                if (true) {
                                  _model.apiPaymentSource =
                                      await BancolombiaPaymentsourcesCall.call(
                                    token: FFAppState().idToken,
                                    customerEmail: currentUserEmail,
                                    acceptanceToken: getJsonField(
                                      _model.aceptaceToken2,
                                      r'''$.acceptanceToken''',
                                    ).toString(),
                                    acceptPersonalAuth: getJsonField(
                                      _model.aceptaceToken2,
                                      r'''$.personalDataAuthToken''',
                                    ).toString(),
                                  );

                                  if ((_model.apiPaymentSource?.succeeded ??
                                      true)) {
                                    _model.subida =
                                        await MetodosPagoTable().insert({
                                      'usuario_id': currentUserUid,
                                      'payment_source_id': getJsonField(
                                        (_model.apiPaymentSource?.jsonBody ??
                                            ''),
                                        r'''$.data.id''',
                                      ),
                                      'tipo': getJsonField(
                                        (_model.apiPaymentSource?.jsonBody ??
                                            ''),
                                        r'''$.data.public_data.type''',
                                      ).toString(),
                                      'estado': 'Activo',
                                      'email_cliente': valueOrDefault<String>(
                                        currentUserEmail,
                                        'admin@hulp.com',
                                      ),
                                      'tipo_cuenta': getJsonField(
                                        (_model.apiPaymentSource?.jsonBody ??
                                            ''),
                                        r'''$.data.public_data.type''',
                                      ).toString(),
                                      'ultimos_cuatro': getJsonField(
                                        (_model.apiPaymentSource?.jsonBody ??
                                            ''),
                                        r'''$.data.public_data.bank_account_last_four''',
                                      ).toString(),
                                      'numero_telefono': currentPhoneNumber,
                                      'es_predeterminado': true,
                                      'numero_producto': FFAppState().idToken,
                                    });
                                    _model.registro = true;
                                    safeSetState(() {});
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Registrado correctamente',
                                          style: FlutterFlowTheme.of(context)
                                              .titleSmall
                                              .override(
                                                font: GoogleFonts.interTight(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                        ),
                                        duration: Duration(milliseconds: 4000),
                                        backgroundColor:
                                            FlutterFlowTheme.of(context)
                                                .primary,
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Intentelo de nuevo no se aprobo',
                                          style: FlutterFlowTheme.of(context)
                                              .titleSmall
                                              .override(
                                                font: GoogleFonts.interTight(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                        ),
                                        duration: Duration(milliseconds: 4000),
                                        backgroundColor:
                                            FlutterFlowTheme.of(context).error,
                                      ),
                                    );
                                  }
                                }
                              }

                              safeSetState(() {});
                            },
                            text: 'Confirmar',
                            options: FFButtonOptions(
                              height: 40.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: Color(0xFFFDDA27),
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    font: GoogleFonts.interTight(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                              elevation: 0.0,
                              borderSide: BorderSide(
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                      ],
                    ),
                  if (FFAppState().idToken != '')
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            borderRadius: BorderRadius.circular(360.0),
                          ),
                          child: Icon(
                            Icons.check_circle,
                            color: FlutterFlowTheme.of(context).primary,
                            size: 54.0,
                          ),
                        ),
                        if (FFAppState().idToken != '')
                          FFButtonWidget(
                            onPressed: () async {
                              _model.useridexist =
                                  await MetodosPagoTable().queryRows(
                                queryFn: (q) => q
                                    .eqOrNull(
                                      'usuario_id',
                                      currentUserUid,
                                    )
                                    .eqOrNull(
                                      'numero_producto',
                                      FFAppState().idToken,
                                    ),
                              );
                              if (_model.useridexist!.length > 0) {
                                await MetodosPagoTable().delete(
                                  matchingRows: (rows) => rows.eqOrNull(
                                    'id',
                                    _model.useridexist?.firstOrNull?.id,
                                  ),
                                );
                                FFAppState().idToken = '';
                                safeSetState(() {});
                              } else {
                                FFAppState().idToken = '';
                                safeSetState(() {});
                              }

                              safeSetState(() {});
                            },
                            text: 'Cancelar suscripción',
                            options: FFButtonOptions(
                              height: 40.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: FlutterFlowTheme.of(context).error,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    font: GoogleFonts.interTight(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                              elevation: 0.0,
                              borderSide: BorderSide(
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
