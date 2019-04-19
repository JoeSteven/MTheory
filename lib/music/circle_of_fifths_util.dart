import 'dart:math';

class CFUtil {
  static final notes = [
    'C',
    'F',
    'bB',
    'bE',
    'bA',
    'bD',
    'bG',
    'B',
    'E',
    'A',
    'D',
    'G'
  ];

  // 下行五度
  static final mapDown = {
    'C': 'F',
    'F': 'bB',
    'bB': 'bE',
    'bE': 'bA',
    'bA': 'bD',
    'bD': 'bG',
    'bG': 'B',
    'B': 'E',
    'E': 'A',
    'A': 'D',
    'D': 'G',
    'G': 'C',
  };

  //上行五度
  static final mapUp = {
    'C': 'G',
    'F': 'C',
    'bB': 'F',
    'bE': 'bB',
    'bA': 'bE',
    'bD': 'bA',
    'bG': 'bD',
    'B': 'bG',
    'E': 'B',
    'A': 'E',
    'D': 'A',
    'G': 'D',
  };
  static var notesPos = -1;

  static String randomNote() {
    var pos = Random().nextInt(notes.length);
    if (pos == notesPos) {
      pos = pos + 2;
    }
    notesPos = pos;
    return notes[notesPos];
  }

  static String upFifth(String note) {
    return mapUp[note];
  }

  static String downFifth(String note) {
    return mapDown[note];
  }
}
