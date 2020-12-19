import 'package:flutter/material.dart';
import 'package:mobile_app/app_theme.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mobile_app/services/API/country_institute_api.dart';

class CVTypeAheadField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType type;
  final TextInputAction action;
  final int maxLines;
  final Function(String) validator;
  final Function(String) onSaved;
  final Function onFieldSubmitted;
  final EdgeInsets padding;
  final FocusNode focusNode;
  final CountryInstituteAPI countryInstituteObject;
  final String toggle;

  /// Creates a [TextField] that is specifically styled for CircuitVerse.
  ///
  /// When a [TextInputType] is not specified, it defaults to [TextInputType.text]
  ///
  /// When `maxLines` is not specified, it defaults to 1
  CVTypeAheadField({
    Key key,
    @required this.label,
    this.type = TextInputType.text,
    this.action = TextInputAction.next,
    this.maxLines = 1,
    this.validator,
    this.onSaved,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 8,
    ),
    this.focusNode,
    this.onFieldSubmitted,
    this.countryInstituteObject,
    this.controller,
    this.toggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String text;
    return Padding(
      padding: padding,
      child: FutureBuilder(
        builder: (context, projectSnap) {
          if (projectSnap.connectionState == ConnectionState.none &&
              projectSnap.hasData == null) {
            return Container();
          }
          return TypeAheadFormField(
            textFieldConfiguration: TextFieldConfiguration(
              decoration: AppTheme.textFieldDecoration.copyWith(
                labelText: label,
              ),
              controller: controller,
              textInputAction: action,
              focusNode: focusNode,
              style: TextStyle(color: Colors.black),
              maxLines: maxLines,
              keyboardType: type,
              autofocus: true,
            ),
            suggestionsCallback: (pattern) async {
              try {
                if (toggle == HttpCountryInstituteAPI.COUNTRY) {
                  return await countryInstituteObject.getCountries(
                    pattern,
                  );
                }
                if (toggle == HttpCountryInstituteAPI.EDUCATIONAL_INSTITUTE) {
                  return await countryInstituteObject.getInstitutes(
                    pattern,
                  );
                }
                //// If there is need of some other API Fetch add another if condition
                return [
                  pattern == '' ? 'No suggestions found' : pattern,
                ];
              } catch (e) {
                return [
                  pattern == '' ? 'No suggestions found' : pattern,
                ];
              }
            },
            transitionBuilder: (context, suggestionsBox, controller) {
              return suggestionsBox;
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion),
              );
            },
            onSuggestionSelected: (value) {
              if (value != '') {
                controller.text = value;
              }
            },
            onSaved: (value) {
              onSaved(
                (value == '') ? (text ?? 'N.A') : value,
              );
            },
          );
        },
      ),
    );
  }
}
