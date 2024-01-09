class ProductId {
  static String id = "";
  static bool SalesReport = false;
  static String cat = "", subCat1 = "", subCat2 = "";
  static bool categoryCheck = false;
  static String Gid = '';
  static String barCodeNumber = '';
  static void reset() {
    categoryCheck = false;
    cat = "";
    subCat1 = "";
    subCat2 = "";
    barCodeNumber = '';
  }
}
