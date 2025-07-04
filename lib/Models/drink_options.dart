class DrinkOption {
  final String imagePath;
  final int ml;

  DrinkOption({required this.imagePath, required this.ml});
}


List<DrinkOption> drinkOptions = [
  DrinkOption(imagePath: 'assets/images/50ml.png', ml: 50),
  DrinkOption(imagePath: 'assets/images/glass-water_37170541/glass-water.png', ml: 50),
  DrinkOption(imagePath: 'assets/images/100ml.png', ml: 100),
  DrinkOption(imagePath: 'assets/images/200ml.png', ml: 200),
  DrinkOption(imagePath: 'assets/images/250ml.png', ml: 250),
  DrinkOption(imagePath: 'assets/images/300ml.png', ml: 300),
  DrinkOption(imagePath: 'assets/images/350ml.png', ml: 350),
  DrinkOption(imagePath: 'assets/images/400ml.png', ml: 400),
  DrinkOption(imagePath: 'assets/images/450ml.png', ml: 450),
];