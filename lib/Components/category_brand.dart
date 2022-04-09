import 'package:myrest/Constants/colors_constants.dart';
import 'package:myrest/Constants/localization_constants.dart';
import 'package:myrest/Models/store_category.dart';
import 'package:myrest/Providers/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:myrest/Providers/filter_provider.dart';
import 'package:provider/provider.dart';

class BrandWidget extends StatefulWidget {
  final StoreCategory storeCategory;

  const BrandWidget({Key? key, required this.storeCategory}) : super(key: key);

  @override
  _BrandWidgetState createState() => _BrandWidgetState();
}

class _BrandWidgetState extends State<BrandWidget> {
  FilterProvider? _filterProvider;

  changeCat(String value) {
    _filterProvider!.changeCat(value);
  }

  @override
  Widget build(BuildContext context) {
    _filterProvider = Provider.of<FilterProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        onTap: () {
          changeCat(widget.storeCategory.storeCatName);
        },
        child: Column(
          children: [
            SizedBox(
              height: 50.0,
              width: 50.0,
              child: CircleAvatar(
                backgroundImage:
                    NetworkImage(widget.storeCategory.storeCatPicRef),
                backgroundColor: (_filterProvider!.getCat ==
                        widget.storeCategory.storeCatName)
                    ? ColorConstants.instance.primaryColor
                    : ColorConstants.instance.whiteContainer,
                radius: 30.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                context.read<LocaleProvider>().locale ==
                        LocalizationConstant.trLocale
                    ? widget.storeCategory.storeShort
                    : widget.storeCategory.storeShortEn,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.instance.primaryColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
