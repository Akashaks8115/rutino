import 'dart:convert';

import '../../libs.dart';

class CompCountryStateCityPicker extends StatefulWidget {
  final TextEditingController country;
  final TextEditingController state;
  final TextEditingController city;
  final InputDecoration? textFieldDecoration;
  final Color? dialogColor;

  const CompCountryStateCityPicker({
    super.key,
    required this.country,
    required this.state,
    required this.city,
    this.textFieldDecoration,
    this.dialogColor,
  });

  @override
  State<CompCountryStateCityPicker> createState() =>
      _CompCountryStateCityPickerState();
}

class _CompCountryStateCityPickerState
    extends State<CompCountryStateCityPicker> {
  final List<CountryModel> _countryList = [];
  final List<StateModel> _stateList = [];
  final List<CityModel> _cityList = [];

  List<CountryModel> _countrySubList = [];
  List<StateModel> _stateSubList = [];
  List<CityModel> _citySubList = [];
  String _title = '';
  late ThemeChangerViewModel themeChangerViewModel;

  @override
  void initState() {
    super.initState();
    themeChangerViewModel = Provider.of<ThemeChangerViewModel>(
      navigatorKey.currentContext!,
      listen: false,
    );

    // Load countries
    _getCountry();
  }

  Future<void> _getCountry() async {
    _countryList.clear();
    try {
      var jsonString = await rootBundle.loadString('assets/json/country.json');
      List<dynamic> body = json.decode(jsonString);
      setState(() {
        _countryList.addAll(
          body.map((dynamic item) => CountryModel.fromJson(item)).toList(),
        );
        _countrySubList = _countryList;
      });
      mDebugPrint("Loaded ${_countryList.length} countries");
    } catch (e) {
      mDebugPrintError("Error loading country.json: $e");
    }
  }

  Future<void> _getState(String countryId) async {
    _stateList.clear();
    _cityList.clear();
    List<StateModel> subStateList = [];
    try {
      var jsonString = await rootBundle.loadString('assets/json/state.json');
      List<dynamic> body = json.decode(jsonString);

      subStateList = body
          .map((dynamic item) => StateModel.fromJson(item))
          .toList();
      setState(() {
        for (var element in subStateList) {
          if (element.countryId == countryId) {
            _stateList.add(element);
          }
        }
        _stateSubList = _stateList;
      });
      mDebugPrint("Loaded ${_stateList.length} states for country $countryId");
    } catch (e) {
      mDebugPrintError("Error loading state.json: $e");
    }
  }

  Future<void> _getCity(String stateId) async {
    _cityList.clear();
    List<CityModel> subCityList = [];
    try {
      var jsonString = await rootBundle.loadString('assets/json/city.json');
      List<dynamic> body = json.decode(jsonString);

      subCityList = body
          .map((dynamic item) => CityModel.fromJson(item))
          .toList();
      setState(() {
        for (var element in subCityList) {
          if (element.stateId == stateId) {
            _cityList.add(element);
          }
        }
        _citySubList = _cityList;
      });
      mDebugPrint("Loaded ${_cityList.length} cities for state $stateId");
    } catch (e) {
      mDebugPrintError("Error loading city.json: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Country TextField
        CompTextField.textFieldContainer(
          suffixIcon: const Icon(Icons.arrow_drop_down),
          child: TextFormField(
            controller: widget.country,
            readOnly: true,
            style: CompTextField.textStyle,
            decoration: CompTextField.decoration("Select Country"),
            onTap: () {
              setState(() => _title = 'Country');
              _showDialog(context);
            },
          ),
        ),
        const SizedBox(height: 8.0),

        CompTextField.textFieldContainer(
          suffixIcon: const Icon(Icons.arrow_drop_down),
          child: TextFormField(
            controller: widget.state,
            readOnly: true,
            style: CompTextField.textStyle,
            decoration: CompTextField.decoration("Select State"),
            onTap: () {
              setState(() => _title = 'State');
              if (widget.country.text.isNotEmpty) {
                _showDialog(context);
              } else {
                _showSnackBar('Select Country');
              }
            },
          ),
        ),
        const SizedBox(height: 8.0),

        /// City TextField
        CompTextField.textFieldContainer(
          suffixIcon: const Icon(Icons.arrow_drop_down),
          child: TextFormField(
            controller: widget.city,
            readOnly: true,
            style: CompTextField.textStyle,
            decoration: CompTextField.decoration("Select City"),
            onTap: () {
              setState(() => _title = 'City');
              if (widget.state.text.isNotEmpty) {
                _showDialog(context);
              } else {
                _showSnackBar('Select State');
              }
            },
          ),
        ),
      ],
    );
  }

  void _showDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    final TextEditingController controller2 = TextEditingController();

    showGeneralDialog(
      barrierLabel: _title,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 350),
      context: context,
      pageBuilder: (context, _, _) {
        return Material(
          color: Colors.transparent,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: MediaQuery.of(context).size.height * .7,
                  margin: const EdgeInsets.only(top: 60, left: 12, right: 12),
                  decoration: BoxDecoration(
                    color: widget.dialogColor ?? Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        _title,
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),

                      ///Text Field
                      TextField(
                        controller: _title == 'Country'
                            ? controller
                            : _title == 'State'
                            ? controller
                            : controller2,
                        onChanged: (val) {
                          setState(() {
                            if (_title == 'Country') {
                              _countrySubList = _countryList
                                  .where(
                                    (element) =>
                                        element.name.toLowerCase().contains(
                                          controller.text.toLowerCase(),
                                        ),
                                  )
                                  .toList();
                            } else if (_title == 'State') {
                              _stateSubList = _stateList
                                  .where(
                                    (element) =>
                                        element.name.toLowerCase().contains(
                                          controller.text.toLowerCase(),
                                        ),
                                  )
                                  .toList();
                            } else if (_title == 'City') {
                              _citySubList = _cityList
                                  .where(
                                    (element) =>
                                        element.name.toLowerCase().contains(
                                          controller2.text.toLowerCase(),
                                        ),
                                  )
                                  .toList();
                            }
                          });
                        },
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 16.0,
                        ),
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: "Search here...",
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 5,
                          ),
                          isDense: true,
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),

                      ///Dropdown Items
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 12,
                          ),
                          itemCount: _title == 'Country'
                              ? _countrySubList.length
                              : _title == 'State'
                              ? _stateSubList.length
                              : _citySubList.length,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () async {
                                setState(() {
                                  if (_title == 'Country') {
                                    widget.country.text =
                                        _countrySubList[index].name;
                                    _getState(_countrySubList[index].id);
                                    _countrySubList = _countryList;
                                    widget.state.clear();
                                    widget.city.clear();
                                  } else if (_title == 'State') {
                                    widget.state.text =
                                        _stateSubList[index].name;
                                    _getCity(_stateSubList[index].id);
                                    _stateSubList = _stateList;
                                    widget.city.clear();
                                  } else if (_title == 'City') {
                                    widget.city.text = _citySubList[index].name;
                                    _citySubList = _cityList;
                                  }
                                });
                                controller.clear();
                                controller2.clear();
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 20.0,
                                  left: 10.0,
                                  right: 10.0,
                                ),
                                child: Text(
                                  _title == 'Country'
                                      ? _countrySubList[index].name
                                      : _title == 'State'
                                      ? _stateSubList[index].name
                                      : _citySubList[index].name,
                                  style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                        onPressed: () {
                          if (_title == 'City' && _citySubList.isEmpty) {
                            widget.city.text = controller2.text;
                          }
                          controller.clear();
                          controller2.clear();
                          Navigator.pop(context);
                        },
                        child: const Text("Custom Input"),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: themeChangerViewModel.getRedColor,
      ),
    );
  }
}
