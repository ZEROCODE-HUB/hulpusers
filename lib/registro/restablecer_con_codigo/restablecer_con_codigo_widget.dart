import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'restablecer_con_codigo_model.dart';
export 'restablecer_con_codigo_model.dart';

/// Pantalla de recuperación de contraseña con código OTP de 6 dígitos.
/// Recibe el correo al que Supabase envió el código, verifica el OTP
/// (OtpType.recovery) y establece la nueva contraseña con updateUser.
class RestablecerConCodigoWidget extends StatefulWidget {
  const RestablecerConCodigoWidget({super.key, this.correo});

  final String? correo;

  static String routeName = 'RestablecerConCodigo';
  static String routePath = '/restablecerConCodigo';

  @override
  State<RestablecerConCodigoWidget> createState() =>
      _RestablecerConCodigoWidgetState();
}

class _RestablecerConCodigoWidgetState
    extends State<RestablecerConCodigoWidget> {
  late RestablecerConCodigoModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RestablecerConCodigoModel());
    _model.codeTextController ??= TextEditingController();
    _model.codeFocusNode ??= FocusNode();
    _model.newPasswordTextController ??= TextEditingController();
    _model.newPasswordFocusNode ??= FocusNode();
    _model.confirmPasswordTextController ??= TextEditingController();
    _model.confirmPasswordFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // -- Validation -------------------------------------------------------------

  String? _validateCode(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Ingresa el código de 6 dígitos';
    if (!RegExp(r'^\d{6}$').hasMatch(v)) return 'El código debe tener 6 dígitos';
    return null;
  }

  String? _validateNewPassword(String? value) {
    if (value == null || value.isEmpty) return 'Ingresa la nueva contraseña';
    if (value.length < 8) return 'Mínimo 8 caracteres';
    if (!RegExp(r'[A-Z]').hasMatch(value))
      return 'Debe contener al menos una mayúscula';
    if (!RegExp(r'[0-9]').hasMatch(value))
      return 'Debe contener al menos un número';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Confirma la nueva contraseña';
    if (value != _model.newPasswordTextController!.text)
      return 'Las contraseñas no coinciden';
    return null;
  }

  // -- Submit -----------------------------------------------------------------

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final correo = widget.correo;
    if (correo == null || correo.isEmpty) {
      _showError('No se encontró el correo. Vuelve a solicitar el código.');
      return;
    }

    safeSetState(() => _model.isLoading = true);

    try {
      // Step 1: Verificar el código OTP de recuperación.
      final res = await SupaFlow.client.auth.verifyOTP(
        email: correo,
        token: _model.codeTextController!.text.trim(),
        type: OtpType.recovery,
      );

      if (res.session == null) {
        _showError('Código inválido o expirado. Solicita uno nuevo.');
        return;
      }

      // Step 2: Establecer la nueva contraseña.
      await SupaFlow.client.auth.updateUser(
        UserAttributes(password: _model.newPasswordTextController!.text),
      );

      // Step 3: Cerrar la sesión temporal y llevar a la pantalla de éxito.
      if (!mounted) return;
      _showSuccess('Contraseña actualizada exitosamente');
      GoRouter.of(context).prepareAuthEvent();
      await SupaFlow.client.auth.signOut();
      GoRouter.of(context).clearRedirectLocation();
      if (mounted) {
        context.pushNamedAuth(
            Restablecercontrasea2Widget.routeName, context.mounted);
      }
    } on AuthException catch (e) {
      final m = e.message.toLowerCase();
      final msg = (m.contains('invalid') ||
              m.contains('expired') ||
              m.contains('token'))
          ? 'Código inválido o expirado. Solicita uno nuevo.'
          : 'Error: ${e.message}';
      _showError(msg);
    } catch (e) {
      _showError('Ocurrió un error inesperado');
    } finally {
      if (mounted) safeSetState(() => _model.isLoading = false);
    }
  }

  Future<void> _onResend() async {
    final correo = widget.correo;
    if (correo == null || correo.isEmpty) return;
    try {
      await SupaFlow.client.auth.resetPasswordForEmail(correo);
      _showSuccess('Te enviamos un nuevo código a tu correo');
    } on AuthException catch (e) {
      _showError('No se pudo reenviar: ${e.message}');
    } catch (e) {
      _showError('No se pudo reenviar el código');
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,
            style: TextStyle(
                color: FlutterFlowTheme.of(context).secondaryBackground)),
        backgroundColor: FlutterFlowTheme.of(context).error,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,
            style: TextStyle(
                color: FlutterFlowTheme.of(context).secondaryBackground)),
        backgroundColor: FlutterFlowTheme.of(context).success,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  // -- Build ------------------------------------------------------------------

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
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 30.0,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          title: Text(
            'Restablecer contraseña',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.interTight(fontWeight: FontWeight.w600),
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 18.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                ),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header info
                    Container(
                      width: MediaQuery.sizeOf(context).width * 1.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context)
                            .primary
                            .withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.mark_email_read_outlined,
                              color: FlutterFlowTheme.of(context).primary,
                              size: 24.0,
                            ),
                            const SizedBox(width: 12.0),
                            Expanded(
                              child: Text(
                                (widget.correo != null &&
                                        widget.correo!.isNotEmpty)
                                    ? 'Ingresa el código de 6 dígitos que enviamos a ${widget.correo} y define tu nueva contraseña.'
                                    : 'Ingresa el código de 6 dígitos que enviamos a tu correo y define tu nueva contraseña.',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(),
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      fontSize: 14.0,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32.0),

                    // Código OTP
                    _buildCodeField(context),
                    const SizedBox(height: 20.0),

                    // Divider
                    Divider(
                        color: FlutterFlowTheme.of(context).alternate,
                        thickness: 1.0),
                    const SizedBox(height: 20.0),

                    // Nueva contraseña
                    _buildPasswordField(
                      context,
                      label: 'Nueva contraseña',
                      controller: _model.newPasswordTextController!,
                      focusNode: _model.newPasswordFocusNode!,
                      isVisible: _model.newPasswordVisibility,
                      onToggleVisibility: () => safeSetState(() =>
                          _model.newPasswordVisibility =
                              !_model.newPasswordVisibility),
                      validator: _validateNewPassword,
                    ),
                    const SizedBox(height: 16.0),

                    // Confirmar contraseña
                    _buildPasswordField(
                      context,
                      label: 'Confirmar nueva contraseña',
                      controller: _model.confirmPasswordTextController!,
                      focusNode: _model.confirmPasswordFocusNode!,
                      isVisible: _model.confirmPasswordVisibility,
                      onToggleVisibility: () => safeSetState(() =>
                          _model.confirmPasswordVisibility =
                              !_model.confirmPasswordVisibility),
                      validator: _validateConfirmPassword,
                    ),
                    const SizedBox(height: 12.0),

                    _buildRequirements(context),
                    const SizedBox(height: 24.0),

                    // Submit
                    FFButtonWidget(
                      onPressed: _model.isLoading ? null : () => _onSubmit(),
                      text: _model.isLoading
                          ? 'Actualizando...'
                          : 'Restablecer contraseña',
                      options: FFButtonOptions(
                        width: MediaQuery.sizeOf(context).width * 1.0,
                        height: 52.0,
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 0.0, 0.0, 0.0),
                        iconPadding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 0.0, 0.0, 0.0),
                        color: FlutterFlowTheme.of(context).primary,
                        textStyle:
                            FlutterFlowTheme.of(context).titleSmall.override(
                                  font: GoogleFonts.interTight(
                                      fontWeight: FontWeight.w600),
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                ),
                        elevation: 0.0,
                        borderRadius: BorderRadius.circular(12.0),
                        disabledColor: FlutterFlowTheme.of(context).alternate,
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    // Reenviar código
                    Center(
                      child: InkWell(
                        onTap: _model.isLoading ? null : () => _onResend(),
                        child: Text(
                          '¿No recibiste el código? Reenviar',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                font: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500),
                                color: FlutterFlowTheme.of(context).primary,
                                fontSize: 14.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // -- Campo de código --------------------------------------------------------

  Widget _buildCodeField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Código de verificación',
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                color: FlutterFlowTheme.of(context).primaryText,
                fontSize: 14.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 8.0),
        TextFormField(
          controller: _model.codeTextController,
          focusNode: _model.codeFocusNode,
          keyboardType: TextInputType.number,
          maxLength: 6,
          textAlign: TextAlign.center,
          validator: _validateCode,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            isDense: true,
            counterText: '',
            hintText: '••••••',
            hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                  font: GoogleFonts.inter(),
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 8.0,
                ),
            enabledBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Color(0xFFDFDFDF), width: 1.0),
              borderRadius: BorderRadius.circular(12.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: FlutterFlowTheme.of(context).primary, width: 1.5),
              borderRadius: BorderRadius.circular(12.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: FlutterFlowTheme.of(context).error, width: 1.0),
              borderRadius: BorderRadius.circular(12.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: FlutterFlowTheme.of(context).error, width: 1.5),
              borderRadius: BorderRadius.circular(12.0),
            ),
            filled: true,
            fillColor: FlutterFlowTheme.of(context).secondaryBackground,
            contentPadding:
                const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
          ),
          style: FlutterFlowTheme.of(context).headlineSmall.override(
                font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
                letterSpacing: 12.0,
                fontWeight: FontWeight.w700,
              ),
          cursorColor: FlutterFlowTheme.of(context).primary,
        ),
      ],
    );
  }

  // -- Campo de contraseña reutilizable ---------------------------------------

  Widget _buildPasswordField(
    BuildContext context, {
    required String label,
    required TextEditingController controller,
    required FocusNode focusNode,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                color: FlutterFlowTheme.of(context).primaryText,
                fontSize: 14.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 8.0),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          obscureText: !isVisible,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            isDense: true,
            hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                  font: GoogleFonts.inter(),
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
            enabledBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Color(0xFFDFDFDF), width: 1.0),
              borderRadius: BorderRadius.circular(12.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: FlutterFlowTheme.of(context).primary, width: 1.5),
              borderRadius: BorderRadius.circular(12.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: FlutterFlowTheme.of(context).error, width: 1.0),
              borderRadius: BorderRadius.circular(12.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: FlutterFlowTheme.of(context).error, width: 1.5),
              borderRadius: BorderRadius.circular(12.0),
            ),
            filled: true,
            fillColor: FlutterFlowTheme.of(context).secondaryBackground,
            contentPadding:
                const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
            suffixIcon: InkWell(
              onTap: onToggleVisibility,
              focusNode: FocusNode(skipTraversal: true),
              child: Icon(
                isVisible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: FlutterFlowTheme.of(context).secondaryText,
                size: 22.0,
              ),
            ),
          ),
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.inter(),
                letterSpacing: 0.0,
              ),
          cursorColor: FlutterFlowTheme.of(context).primary,
        ),
      ],
    );
  }

  // -- Requisitos -------------------------------------------------------------

  Widget _buildRequirements(BuildContext context) {
    final style = FlutterFlowTheme.of(context).bodySmall.override(
          font: GoogleFonts.inter(),
          color: FlutterFlowTheme.of(context).secondaryText,
          fontSize: 12.0,
          letterSpacing: 0.0,
        );

    return Container(
      width: MediaQuery.sizeOf(context).width * 1.0,
      decoration: BoxDecoration(
        color: const Color(0xFFF6F5F3),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Requisitos de la contraseña:',
                style: style.override(
                  font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  fontWeight: FontWeight.w600,
                )),
            const SizedBox(height: 6.0),
            Text('  •  Mínimo 8 caracteres', style: style),
            Text('  •  Al menos una letra mayúscula', style: style),
            Text('  •  Al menos un número', style: style),
          ],
        ),
      ),
    );
  }
}
