import 'package:bulovva/Constants/colors_constants.dart';
import 'package:bulovva/Models/store_category.dart';
import 'package:flutter/material.dart';
import 'package:bulovva/Providers/filter_provider.dart';
import 'package:provider/provider.dart';

class BrandWidget extends StatefulWidget {
  final StoreCategory storeCategory;

  const BrandWidget({Key key, this.storeCategory}) : super(key: key);

  @override
  _BrandWidgetState createState() => _BrandWidgetState();
}

class _BrandWidgetState extends State<BrandWidget> {
  FilterProvider _filterProvider;

  changeCat(String value) {
    _filterProvider.changeCat(value);
  }

  @override
  Widget build(BuildContext context) {
    _filterProvider = Provider.of<FilterProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: () {
          changeCat(widget.storeCategory.storeCatName);
        },
        child: Column(
          children: [
            SizedBox(
              height: 60.0,
              width: 60.0,
              child: CircleAvatar(
                backgroundImage:
                    NetworkImage(widget.storeCategory.storeCatPicRef),
                backgroundColor: (_filterProvider.getCat ==
                        widget.storeCategory.storeCatName)
                    ? ColorConstants.instance.inactiveColor
                    : ColorConstants.instance.whiteContainer,
                maxRadius: 30.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                widget.storeCategory.storeShort,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.instance.textOnColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
