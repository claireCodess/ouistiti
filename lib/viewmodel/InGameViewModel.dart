import 'package:injectable/injectable.dart';
import 'package:ouistiti/di/Injection.dart';
import 'package:ouistiti/dto/OuisitiSetNickname.dart';
import 'package:ouistiti/socket/Socket.dart';
import 'package:ouistiti/util/error/NicknameError.dart';
import 'package:stacked/stacked.dart';

const String _NicknameStreamKey = 'nickname-stream';
const String _NicknameErrorStreamKey = 'nicknameerror-stream';

@injectable
class InGameViewModel extends MultipleStreamViewModel {
  Socket _socket;

  String nickname;
  String nicknameLocalErrorMsgKey;
  String nicknameServerErrorMsgKey;
  List<int> playerOrder;

  InGameViewModel() {
    _socket = getIt<Socket>();
  }

  @override
  Map<String, StreamData> get streamsMap => {
        _NicknameStreamKey: StreamData<String>(_socket.nicknameToStream,
            transformData: (newNickname) {
          print("nickname event received in stream");
          nickname = newNickname;
          notifyListeners();
        }),
        _NicknameErrorStreamKey: StreamData<NicknameError>(
            _socket.nicknameErrorMsgToStream, transformData: (error) {
          print("nicknameError event received in stream");
          if (error != null && error.errorMessageKey.isNotEmpty) {
            print("nicknameError event + message key not null/empty");
            if (error.errorMessageKey == "error_no_nickname") {
              // Error that will be displayed in the dialog,
              // it didn't need to contact the server
              nicknameLocalErrorMsgKey = error.errorMessageKey;
            } else {
              // Error that will be displayed in a snackbar,
              // response from the server after nickname was submitted
              nicknameServerErrorMsgKey = error.errorMessageKey;
            }
            notifyListeners();
          }
        })
      };

  void changeNickname(nickname) {
    getIt<Socket>()
        .socketIO
        .emit('setNickname', OuistitiSetNickname(nickname).toJson());
  }

  void showNicknameError(errorMessageKey) {
    _socket.showNicknameError(errorMessageKey);
  }

  @override
  void dispose() {
    super.dispose();
    print("InGameViewModel on dispose, hash code:");
    print(this.hashCode);
  }
}
