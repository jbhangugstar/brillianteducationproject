class CurrencyHelper {
  static String formatRupiah(int number) {
    String numberStr = number.toString();
    String result = '';
    int count = 0;
    
    for (int i = numberStr.length - 1; i >= 0; i--) {
      if (count == 3) {
        result = '.$result';
        count = 0;
      }
      result = numberStr[i] + result;
      count++;
    }
    
    return 'Rp $result';
  }
}
