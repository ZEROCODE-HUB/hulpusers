import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cambiar_contrasena_model.dart';
export 'cambiar_contrasena_model.dart';

/// Cambio de contraseña para el usuario autenticado.
/// Reautentica con la contraseña actual (signInWithPassword) y luego
/// actualiza la contraseña con updateUser.
class CambiarContrasenaWidget extends StatefulWidget {
  const CambiarContrasenaWidget({super.key});

  static String routeName = 'CambiarContrasena';
  static String routePath = '/cambiarContrasena';

  @override
  State<CambiarContrasenaWidget> createState() =>
      _CambiarContrasenaWidgetState();
}

class _CambiarContrasenaWidgetState extends State<CambiarContrasenaWidget> {
  late CambiarContrasenaModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CambiarContrasenaModel());
    _model.currentPasswordTextController ??= TextEditingController();
    _model.currentPasswordFocusNode ??= FocusNode();
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

  String? _validateCurrentPassword(String? value) {
    if (value == null || value.isEmpty) return 'Ingresa tu contraseña actual';
    return null;
  }

  String? _validateNewPassword(String? value) {
    if (value == null || value.isEmpty) return 'Ingresa la nueva contraseña';
    if (value.length < 8) return 'Mínimo 8 caracteres';
    if (!RegExp(r'[A-Z]').hasMatch(value))
      return 'Debe contener al menos una mayúscula';
    if (!RegExp(r'[0-9]').hasMatch(value))
      return 'Debe contener al menos un número';
    if (value == _model.currentPasswordTextController!.text)
      return 'La nueva contraseña debe ser diferente a la actual';
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

    safeSetState(() => _model.isLoading = true);

    try {
      // Step 1: Verify current password by re-authenticating
      final email = currentUserEmail;
      final response = await SupaFlow.client.auth.signInWithPassword(
        email: email,
        password: _model.currentPasswordTextController!.text,
      );

      if (response.user == null) {
        _showError('La contraseña actual es incorrecta');
        return;
      }

      // Step 2: Update password
      await SupaFlow.client.auth.updateUser(
        UserAttributes(
          password: _model.newPasswordTextController!.text,
        ),
      );

      // Step 3: Success
      if (mounted) {
        _showSuccess('Contraseña actualizada exitosamente');
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) context.pop();
      }
    } on AuthException catch (e) {
      final msg = e.message.toLowerCase().contains('invalid')
          ? 'La contraseña actual es incorrecta'
          : 'Error: ${e.message}';
      _showError(msg);
    } catch (e) {
      _showError('Ocurrió un error inesperado');
    } finally {
      if (mounted) safeSetState(() => _model.isLoading = false);
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
            'Cambiar contraseña',
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
                padding: const EdgeInsetsDirectional.fromSTEB(
                    24.0, 24.0, 24.0, 24.0),
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
                              Icons.lock_outline_rounded,
                              color: FlutterFlowTheme.of(context).primary,
                              size: 24.0,
                            ),
                            const SizedBox(width: 12.0),
                            Expanded(
                              child: Text(
                                'Por seguridad, ingresa tu contraseña actual antes de establecer una nueva.',
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

                    // Current password
                    _buildPasswordField(
                      context,
                      label: 'Contraseña actual',
                      controller: _model.currentPasswordTextController!,
                      focusNode: _model.currentPasswordFocusNode!,
                      isVisible: _model.currentPasswordVisibility,
                      onToggleVisibility: () => safeSetState(() => _model
                              .currentPasswordVisibility =
                          !_model.currentPasswordVisibility),
                      validator: _validateCurrentPassword,
                    ),
                    const SizedBox(height: 20.0),

                    // Divider
                    Divider(
                        color: FlutterFlowTheme.of(context).alternate,
                        thickness: 1.0),
                    const SizedBox(height: 20.0),

                    // New password
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

                    // Confirm password
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

                    // Password requirements
                    _buildRequirements(context),
                    const SizedBox(height: 32.0),

                    // Submit button
                    FFButtonWidget(
                      onPressed: _model.isLoading ? null : () => _onSubmit(),
                      text: _model.isLoading
                          ? 'Actualizando...'
                          : 'Cambiar contraseña',
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // -- Reusable password field ------------------------------------------------

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
            contentPadding: const EdgeInsetsDirectional.fromSTEB(
                16.0, 16.0, 16.0, 16.0),
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

  // -- Requirements hint ------------------------------------------------------

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
