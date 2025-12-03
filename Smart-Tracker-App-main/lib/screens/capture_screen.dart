import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';  // ← ADD THIS LINE
import 'package:provider/provider.dart';
import '../providers/activity_provider.dart';

class CaptureScreen extends StatefulWidget {
  final LatLng? initialPosition;
  const CaptureScreen({super.key, this.initialPosition});

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  CameraController? _controller;
  String? _imagePath;
  List<CameraDescription> _cameras = [];
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        _controller = CameraController(
          _cameras[0],
          ResolutionPreset.medium,
        );
        await _controller!.initialize();
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Camera error: $e')),
        );
      }
    }
  }

  Future<void> _takePicture() async {
    if (!_controller!.value.isInitialized) return;

    try {
      final XFile image = await _controller!.takePicture();
      setState(() {
        _imagePath = image.path;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error capturing image: $e')),
        );
      }
    }
  }

  Future<void> _saveActivity() async {
    if (_imagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please take a photo first')),
      );
      return;
    }

    try {
      final position = widget.initialPosition ??
          (await Geolocator.getCurrentPosition()).toLatLng();

      await context.read<ActivityProvider>().addActivity(
        latitude: position.latitude,
        longitude: position.longitude,
        imageFile: File(_imagePath!),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Activity saved successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving activity: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Capture Activity')),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: _controller != null && _controller!.value.isInitialized
                ? CameraPreview(_controller!)
                : const Center(child: CircularProgressIndicator()),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (_imagePath != null)
                  Container(
                    height: 120,
                    width: double.infinity,
                    child: Image.file(
                      File(_imagePath!),
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FloatingActionButton(
                      heroTag: 'capture',
                      onPressed: _controller!.value.isInitialized ? _takePicture : null,
                      child: const Icon(Icons.camera_alt),
                    ),
                    if (_imagePath != null)
                      FloatingActionButton.extended(
                        heroTag: 'save',
                        backgroundColor: Colors.green,
                        onPressed: _saveActivity,
                        label: const Text('Save'),
                        icon: const Icon(Icons.save),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}

// Extension for Position -> LatLng conversion
extension PositionExtension on Position {
  LatLng toLatLng() => LatLng(latitude, longitude);
}
