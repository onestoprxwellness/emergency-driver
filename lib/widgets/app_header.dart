import 'package:flutter/material.dart';
import '../util/image_constant.dart';
import '../util/size_utils.dart';
import 'country_selector.dart';

class AppHeader extends StatelessWidget {
  final CountryFlag selectedCountry;
  final List<CountryFlag> countries;
  final Function(CountryFlag) onCountryChanged;

  const AppHeader({
    Key? key,
    required this.selectedCountry,
    required this.countries,
    required this.onCountryChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 12.v,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Image.asset(
            ImageConstant.newLogo,
            height: 24.v,
            fit: BoxFit.contain,
          ),
          
          // Language/Country Selector
          CountrySelector(
            selectedCountry: selectedCountry,
            countries: countries,
            onCountryChanged: onCountryChanged,
          ),
        ],
      ),
    );
  }
}
