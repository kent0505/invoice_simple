class CurrencyModel {
  const CurrencyModel({
    required this.code,
    required this.name,
  });

  final String code;
  final String name;
}

final currencies = [
  CurrencyModel(code: "USA", name: "Dollar USA"),
  CurrencyModel(code: "UAH", name: "Ukrainian hryvnia"),
  CurrencyModel(code: "AED", name: "United Arab Emirates dirham"),
  CurrencyModel(code: "AFN", name: "Afghan afghani"),
  CurrencyModel(code: "ALL", name: "Albanian lek"),
  CurrencyModel(code: "AMD", name: "Armenian dram"),
  CurrencyModel(code: "ANG", name: "Netherlands Antillean guilder"),
  CurrencyModel(code: "AOA", name: "Angolan kwanza"),
  CurrencyModel(code: "ARS", name: "Argentine peso"),
  CurrencyModel(code: "AUD", name: "Australian dollar"),
  CurrencyModel(code: "AWG", name: "Aruban florin"),
  CurrencyModel(code: "AZN", name: "Azerbaijani manat"),
  CurrencyModel(code: "BAM", name: "Bosnia and Herzegovina convertible mark"),
];
