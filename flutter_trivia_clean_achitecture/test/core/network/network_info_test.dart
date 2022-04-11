import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_trivia_clean_achitecture/core/network/network_info.dart';

import 'network_info_test.mocks.dart';

@GenerateMocks([DataConnectionChecker])
// Then run: flutter pub run build_runner build

void main() {
  late NetworkInfoImpl networkInfoImpl;
  late MockDataConnectionChecker mockDataConnectionChecker;
  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl =
        NetworkInfoImpl(connectionChecker: mockDataConnectionChecker);
  });

  group('isConnected', () {
    test(
      'should forward the call to DataConnectionChecker.hasConnection', // DataConnection has .hasConnection
      () async {
        // arrange
        final tHasConnection = Future.value(true);
        when(mockDataConnectionChecker.hasConnection)
            .thenAnswer((_) => tHasConnection);
        // act
        final result = networkInfoImpl.isConnected;
        // assert
        verify(mockDataConnectionChecker.hasConnection);
        expect(result, equals(tHasConnection));
      },
    );
  });
}
