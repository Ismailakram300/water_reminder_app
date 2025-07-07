class DrinkOption {
  final String imagePath;
  final int ml;

  DrinkOption({required this.imagePath, required this.ml});
}







List<DrinkOption> drinkOptions = [
  DrinkOption(imagePath: 'assets/images/water_50ml/water_50ml.png', ml: 50),
  DrinkOption(imagePath: 'assets/images/water_100ml/water_100ml.png', ml: 100),
  DrinkOption(imagePath: 'assets/images/glass_200ml.png', ml: 200),
  DrinkOption(imagePath: 'assets/images/water_250ml/water_250ml.png', ml: 250),
  DrinkOption(imagePath: 'assets/images/water_300ml/water_300ml.png', ml: 300),
  DrinkOption(imagePath: 'assets/images/water_350ml/water_350ml.png', ml: 350),
  DrinkOption(imagePath: 'assets/images/water_400ml/water_400ml.png', ml: 400),
  DrinkOption(imagePath: 'assets/images/water_450ml/water_450ml.png', ml: 450),
];