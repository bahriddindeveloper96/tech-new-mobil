import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  YandexMapController? _mapController;
  Point? _selectedLocation;
  String _address = '';
  bool _isLoading = false;
  final List<PlacemarkMapObject> _placemarks = [];

  static const Point _tashkentLocation = Point(
    latitude: 41.2995,
    longitude: 69.2401,
  );

  static const double _tashkentLat = 41.2995;
  static const double _tashkentLng = 69.2401;

  double? _selectedLat;
  double? _selectedLng;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _selectedLocation = _tashkentLocation;
      _updatePlacemark(_tashkentLocation);
    } else {
      _selectedLat = _tashkentLat;
      _selectedLng = _tashkentLng;
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar(
            'Xatolik',
            'Joylashuv ruxsati berilmadi',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition();
      if (!kIsWeb) {
        final point = Point(
          latitude: position.latitude,
          longitude: position.longitude,
        );
        _moveCamera(point);
        _getAddressFromPoint(point);
      } else {
        setState(() {
          _selectedLat = position.latitude;
          _selectedLng = position.longitude;
        });
        _getAddressFromCoordinates(position.latitude, position.longitude);
      }
    } catch (e) {
      Get.snackbar(
        'Xatolik',
        'Joylashuvni aniqlashda xatolik yuz berdi',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _getAddressFromPoint(Point point) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        point.latitude,
        point.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _address = '${place.street}, ${place.subLocality}, ${place.locality}'
              .replaceAll('null', '')
              .replaceAll(', ,', ',');
          _selectedLocation = point;
          _updatePlacemark(point);
        });
      }
    } catch (e) {
      Get.snackbar(
        'Xatolik',
        'Manzilni aniqlashda xatolik yuz berdi',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _getAddressFromCoordinates(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _address = '${place.street}, ${place.subLocality}, ${place.locality}'
              .replaceAll('null', '')
              .replaceAll(', ,', ',');
          _selectedLat = lat;
          _selectedLng = lng;
        });
      }
    } catch (e) {
      Get.snackbar(
        'Xatolik',
        'Manzilni aniqlashda xatolik yuz berdi',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _updatePlacemark(Point point) {
    _placemarks.clear();
    _placemarks.add(
      PlacemarkMapObject(
        mapId: const MapObjectId('selected_location'),
        point: point,
        icon: PlacemarkIcon.single(
          PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage('assets/images/location_pin.png'),
            scale: 0.8,
          ),
        ),
      ),
    );
    setState(() {});
  }

  void _moveCamera(Point point) {
    _mapController?.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: point,
          zoom: 15,
        ),
      ),
      animation: const MapAnimation(duration: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manzilni tanlang'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          if (!kIsWeb)
            YandexMap(
              onMapCreated: (controller) {
                _mapController = controller;
                _moveCamera(_tashkentLocation);
              },
              onMapTap: (point) => _getAddressFromPoint(point),
              mapObjects: _placemarks,
              logoAlignment: const MapAlignment(
                horizontal: HorizontalAlignment.right,
                vertical: VerticalAlignment.bottom,
              ),
            ),
          if (kIsWeb)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on, size: 64, color: Colors.blue),
                  const SizedBox(height: 16),
                  const Text(
                    'Web versiyada xarita mavjud emas',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _getCurrentLocation,
                    child: const Text('Joriy joylashuvni aniqlash'),
                  ),
                ],
              ),
            ),
          if (_selectedLocation != null || (_selectedLat != null && _selectedLng != null))
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tanlangan manzil:',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _address.isEmpty ? 'Aniqlanmoqda...' : _address,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (!kIsWeb) {
                            Get.back(result: {
                              'address': _address,
                              'latitude': _selectedLocation!.latitude,
                              'longitude': _selectedLocation!.longitude,
                            });
                          } else {
                            Get.back(result: {
                              'address': _address,
                              'latitude': _selectedLat,
                              'longitude': _selectedLng,
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Manzilni tasdiqlash'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (_isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
