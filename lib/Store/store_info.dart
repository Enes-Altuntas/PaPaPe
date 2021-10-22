import 'package:bulovva/Models/store_model.dart';
import 'package:flutter/material.dart';

class StoreInfo extends StatefulWidget {
  final StoreModel storeData;

  StoreInfo({Key key, this.storeData}) : super(key: key);

  @override
  _StoreInfoState createState() => _StoreInfoState();
}

class _StoreInfoState extends State<StoreInfo> {
  final TextEditingController name = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController pers1 = TextEditingController();
  final TextEditingController pers2 = TextEditingController();
  final TextEditingController pers3 = TextEditingController();
  final TextEditingController pers1Phone = TextEditingController();
  final TextEditingController pers2Phone = TextEditingController();
  final TextEditingController pers3Phone = TextEditingController();
  bool _isLoading = false;
  bool isInit = true;

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    if (isInit) {
      name.text = widget.storeData.storeName;
      address.text = widget.storeData.storeAddress;
      phone.text = widget.storeData.storePhone;
      pers1.text = widget.storeData.pers1;
      pers2.text = widget.storeData.pers2;
      pers3.text = widget.storeData.pers3;
      pers1Phone.text = widget.storeData.pers1Phone;
      pers2Phone.text = widget.storeData.pers2Phone;
      pers3Phone.text = widget.storeData.pers3Phone;
      setState(() {
        isInit = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return (_isLoading == false)
        ? SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: Image.network(widget.storeData.storePicRef,
                      fit: BoxFit.fitWidth,
                      loadingBuilder: (context, child, loadingProgress) {
                    return loadingProgress == null
                        ? child
                        : Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          );
                  }),
                  color: Theme.of(context).colorScheme.primary,
                  height: MediaQuery.of(context).size.height / 3.5,
                  width: MediaQuery.of(context).size.width,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: TextFormField(
                          onTap: () {},
                          controller: name,
                          readOnly: true,
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Theme.of(context).hintColor),
                          decoration: InputDecoration(
                              labelText: 'İşletme İsmi',
                              icon: Icon(Icons.announcement_sharp),
                              border: OutlineInputBorder()),
                          maxLength: 50,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: TextFormField(
                          maxLength: 255,
                          maxLines: 3,
                          controller: address,
                          readOnly: true,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Theme.of(context).hintColor),
                          decoration: InputDecoration(
                              labelText: 'İşletme Adresi',
                              icon: Icon(Icons.add_location_rounded),
                              border: OutlineInputBorder()),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: TextFormField(
                          controller: phone,
                          readOnly: true,
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          decoration: InputDecoration(
                              labelText: 'İşletme Telefon Numarası',
                              prefix: Text('+90'),
                              icon: Icon(Icons.phone),
                              border: OutlineInputBorder()),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: TextFormField(
                          controller: pers1,
                          readOnly: true,
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          maxLength: 50,
                          decoration: InputDecoration(
                              labelText: 'İlgili kişi isim-soyisim (1)',
                              icon: Icon(Icons.account_circle_outlined),
                              border: OutlineInputBorder()),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: TextFormField(
                          controller: pers1Phone,
                          readOnly: true,
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          decoration: InputDecoration(
                              labelText: 'İlgili kişi telefon (1)',
                              prefix: Text('+90'),
                              icon: Icon(Icons.phone),
                              border: OutlineInputBorder()),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: TextFormField(
                          controller: pers2,
                          readOnly: true,
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          maxLength: 50,
                          decoration: InputDecoration(
                              labelText: 'İlgili kişi isim-soyisim (2)',
                              icon: Icon(Icons.account_circle_outlined),
                              border: OutlineInputBorder()),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: TextFormField(
                          controller: pers2Phone,
                          readOnly: true,
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          decoration: InputDecoration(
                              labelText: 'İlgili kişi telefon (2)',
                              prefix: Text('+90'),
                              icon: Icon(Icons.phone),
                              border: OutlineInputBorder()),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: TextFormField(
                          readOnly: true,
                          controller: pers3,
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          maxLength: 50,
                          decoration: InputDecoration(
                              labelText: 'İlgili kişi isim-soyisim (3)',
                              icon: Icon(Icons.account_circle_outlined),
                              border: OutlineInputBorder()),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                        child: TextFormField(
                          controller: pers3,
                          readOnly: true,
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          decoration: InputDecoration(
                              labelText: 'İlgili kişi telefon (3)',
                              prefix: Text('+90'),
                              icon: Icon(Icons.phone),
                              border: OutlineInputBorder()),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          );
  }
}
