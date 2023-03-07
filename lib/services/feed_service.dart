import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

import '../model/message.dart';

class FeedService extends ChangeNotifier {
  List<Message> messages = [];
  late int messageCount;
  bool isLoading = true;

  final String _rpcUrl =
      Platform.isAndroid ? 'http://10.0.2.2:7545' : 'http://127.0.0.1:7545';
  final String _wsUrl =
      Platform.isAndroid ? 'http://10.0.2.2:7545' : 'ws://127.0.0.1:7545';

  late Web3Client _client;
  late String _abiCode;

  late Credentials _credentials;
  late EthereumAddress _contractAddress;
  // late EthereumAddress _ownAddress;
  late DeployedContract _contract;

  late ContractFunction _messages;
  late ContractFunction _messageCount;
  late ContractFunction _createMessage;

  // Not recommended | Get the private key by connecting properly to a wallet
  final String _privateKey =
      "2c0591c8fe6d741e210552b206246216d0cbdb52b528fec591820c1a4cf36a1e";

  FeedService() {
    init();
  }

  Future<void> init() async {
    _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });

    await getAbi();
    await getCredentials();
    await getDeployedContract();
  }

  Future<void> getAbi() async {
    String abiStringFile = await rootBundle
        .loadString("blockchain/build/contracts/MessageContract.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);
    _contractAddress =
        EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);
  }

  Future<void> getCredentials() async {
    _credentials = EthPrivateKey.fromHex(_privateKey);
  }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "MessageContract"), _contractAddress);
    _messageCount = _contract.function("messageCount");
    _createMessage = _contract.function("createMessage");
    _messages = _contract.function("messages");
    await getMessages();
  }

  getMessages() async {
    final totalMessageList = await _client
        .call(contract: _contract, function: _messageCount, params: []);
    BigInt totalMessage = totalMessageList[0];
    messageCount = totalMessage.toInt();
    messages.clear();
    for (var i = 0; i < totalMessage.toInt(); i++) {
      var temp = await _client.call(
          contract: _contract, function: _messages, params: [BigInt.from(i)]);
      if (temp[1] != "") {
        messages.add(
          Message(
            id: (temp[0] as BigInt).toInt(),
            message: temp[1],
          ),
        );
      }
    }
    isLoading = false;
    messages = messages.reversed.toList();
    notifyListeners();
  }

  addMessage(String message) async {
    // set loading to true
    isLoading = true;
    // let the UI know
    notifyListeners();
    // send the transaction using the credentials and the Transaction contract.
    // The message is passed as a parameter [message].
    await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: _contract,
        function: _createMessage,
        parameters: [message],
      ),
    );
    // Tell Flutter to fetch all messages again
    await getMessages();
  }
}
