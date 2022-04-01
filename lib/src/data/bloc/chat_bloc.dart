import 'dart:async';

enum ChatAction{Fetch,ClearData}
enum CounterAction{Increment,Decrement,Reset,Fetch}
class ChatBloc {
  int _counter=0;
  final _chatStreamController = StreamController<int>.broadcast();
  StreamSink<int> get chatSink => _chatStreamController.sink;
  Stream<int> get chatStream => _chatStreamController.stream;

  final _eventStreamController = StreamController<CounterAction>();
  StreamSink<CounterAction> get eventSink => _eventStreamController.sink;
  Stream<CounterAction> get eventStream => _eventStreamController.stream;



  ChatBloc(){

    eventStream.listen((event) {
      if(event == CounterAction.Increment){
        chatSink.add(++_counter);
      }
      else if(event == CounterAction.Decrement){
        chatSink.add(--_counter);
      }
      else if(event == CounterAction.Reset){
        chatSink.add(0);
      }
      else if(event == CounterAction.Fetch){
        chatSink.add(_counter);
      }

    });

  }



  void dispose()
  {
    _chatStreamController.close();
    _eventStreamController.close();
  }
}