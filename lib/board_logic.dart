import 'components/tile.dart';

class BoardLogic {
  static bool canSwipe(List<Tile> row) {
    for (int i = 0; i < row.length; i++) {
      if (row[i].value == 0) {
        if (row.skip(i + 1).any((e) => e.value != 0)) {
          return true;
        }
      } else {
        Tile hasNonZeroVal = row.skip(i + 1).firstWhere((e) => e.value != 0,
            orElse: () => Tile(x: 0, y: 0, value: -1));
        if (hasNonZeroVal.value != -1 && hasNonZeroVal.value == row[i].value) {
          return true;
        }
      }
    }
    return false;
  }

  static void mergeTiles(List<Tile> tiles) {
    // Find the first non-zero tile
    // Find the second non-zero tile
    // merge tiles *if possible*
    // Repeat from step 1 until the end of the Iterable<Tile>

    for (int i = 0; i < tiles.length; i++) {
      List<Tile> toCheck =
          tiles.skip(i).skipWhile((tile) => tile.value == 0).toList();
      if (toCheck.isNotEmpty) {
        Tile firstNonZeroTile = toCheck.first;
        Tile secondNonZeroTile = toCheck.skip(i + 1).firstWhere(
            (tile) => tile.value != 0,
            orElse: () => Tile(x: 0, y: 0, value: -1));

        if (secondNonZeroTile.value != -1 &&
            secondNonZeroTile.value != firstNonZeroTile.value) {
          secondNonZeroTile = Tile(x: 0, y: 0, value: -1);
        }

        if (tiles[i] != firstNonZeroTile || secondNonZeroTile.value != -1) {
          int newValue = firstNonZeroTile.value;
          if (secondNonZeroTile.value != -1) {
            newValue += secondNonZeroTile.value;
            secondNonZeroTile.value = 0;
          }
          firstNonZeroTile.value = 0;
          tiles[i].value = newValue;
        }
      }
    }
  }
}
