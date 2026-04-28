import '/flutter_flow/flutter_flow_util.dart';
import 'seleccionar_mensaje_widget.dart' show SeleccionarMensajeWidget;
import 'package:flutter/material.dart';

class SeleccionarMensajeModel
    extends FlutterFlowModel<SeleccionarMensajeWidget> {
  ///  State fields for stateful widgets in this component.

  bool isDataUploading_uploadDataKiq = false;
  FFUploadedFile uploadedLocalFile_uploadDataKiq =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataKiq = '';

  bool isDataUploading_uploadDataCamera = false;
  FFUploadedFile uploadedLocalFile_uploadDataCamera =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataCamera = '';

  bool isDataUploading_uploadData8Archivo = false;
  FFUploadedFile uploadedLocalFile_uploadData8Archivo =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadData8Archivo = '';

  bool isDataUploading_uploadDataVideo = false;
  FFUploadedFile uploadedLocalFile_uploadDataVideo =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataVideo = '';

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
