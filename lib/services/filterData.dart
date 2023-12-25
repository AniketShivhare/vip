
class FilterOptions {
  static List<String> categories=[];
  static Map<String, List<String>> subcategories={};
  static double minPrice=0;
  static double maxPrice=1000;
  static List<String> sizes=[];
  static List<String> brands=[];
  static bool priceChanged=false;
  static bool changed = false;
  static bool sortChanged = false;
  static String sortName ="";
  static bool selectedSubCat = false;
  static bool selectedCat = false;

  static void clear() {
    changed=false;
    sortChanged = false;
    selectedSubCat=false;
    priceChanged=false;
    selectedCat=false;
    sortName ="";
    categories=[];
  }

}
