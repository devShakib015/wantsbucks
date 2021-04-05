import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wantsbucks/providers/earning_provider.dart';
import 'package:wantsbucks/providers/point_provider.dart';

class PointAndEarning extends StatelessWidget {
  const PointAndEarning({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FutureBuilder<int>(
          future: Provider.of<PointProvider>(context).getCurrentPoints(),
          initialData: 0,
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            return Row(
              children: [
                Container(
                    width: 30,
                    child: Image.asset(
                      "assets/images/coin.png",
                      fit: BoxFit.fill,
                    )),
                Text(
                  "${snapshot.data}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            );
          },
        ),
        VerticalDivider(
          width: 20,
        ),
        FutureBuilder<int>(
          future: Provider.of<EarningProvider>(context).getCurrentBalance(),
          initialData: 0,
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            return Row(
              children: [
                Container(
                    width: 23.5,
                    child: Image.asset(
                      "assets/images/taka.png",
                      fit: BoxFit.fill,
                    )),
                SizedBox(
                  width: 3,
                ),
                Text(
                  "${snapshot.data}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
