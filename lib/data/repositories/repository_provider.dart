import '../../app_config.dart';
import 'owner_repository.dart';
import 'owner_mock_repository.dart';
import 'owner_api_repository.dart';

class RepositoryProvider {
  static OwnerRepository? _ownerRepository;

  static OwnerRepository get ownerRepository {
    if (_ownerRepository != null) return _ownerRepository!;

    if (AppConfig.useMockData) {
      _ownerRepository = OwnerMockRepository();
    } else {
      _ownerRepository = OwnerApiRepository();
    }
    return _ownerRepository!;
  }
}
