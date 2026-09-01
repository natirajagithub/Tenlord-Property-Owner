import 'package:flutter/material.dart';
import '../../data/models/property_model.dart';
import '../../data/models/room_model.dart';
import '../../data/repositories/owner_repository.dart';

class PropertiesViewModel extends ChangeNotifier {
  final OwnerRepository repository;

  PropertiesViewModel({required this.repository});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<PropertyModel> _properties = [];
  List<PropertyModel> get properties => _properties;

  PropertyModel? _selectedProperty;
  PropertyModel? get selectedProperty => _selectedProperty;

  List<RoomModel> _rooms = [];
  List<RoomModel> get rooms => _rooms;

  Future<void> loadProperties() async {
    _isLoading = true;
    notifyListeners();

    try {
      _properties = await repository.getProperties();
      if (_properties.isNotEmpty && _selectedProperty == null) {
        _selectedProperty = _properties.first;
      }
      if (_selectedProperty != null) {
        _rooms = await repository.getRoomsByProperty(_selectedProperty!.id);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> changeSelectedProperty(PropertyModel prop) async {
    _selectedProperty = prop;
    _isLoading = true;
    notifyListeners();

    try {
      _rooms = await repository.getRoomsByProperty(prop.id);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
