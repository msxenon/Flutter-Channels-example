import 'dart:async';

main()  {
  runZonedGuarded(() {
    example();
  }, (e, s) => print(e));
  print('P Start');
  Future.delayed(Duration(seconds: 2),(){
    print('F2');
  });
  Future((){
    print('F2');
  });
  scheduleMicrotask(()=>print('MT 1'));
  Future((){
    print('F3');
  });

  scheduleMicrotask(()=>print('MT 2'));

   Future((){
     print('F4');
   });
   scheduleMicrotask(()=>print('MT 3'));
  Future((){
    print('F5');
  });
  scheduleMicrotask(()=>print('MT 4'));
  print('P END');
}

Future example() async {
  await for (var x in streamer()) {
    print('Got $x');
    if (x == 2) throw ('error: $x');
  }
}

Future exampleOutOfZone() async {
  await for (var x in streamer()) {
    print('Got $x');
    if (x == 3) throw ('error: $x');
  }
}

Stream<int> streamer() async* {
  var duration = Duration(milliseconds: 0);
  for (var x = 0; x < 100; x++) {
    await Future.delayed(duration);
    yield x;
  }
}