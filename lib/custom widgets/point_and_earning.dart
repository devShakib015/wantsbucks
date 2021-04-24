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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: FutureBuilder<int>(
            future: Provider.of<PointProvider>(context).getCurrentPoints(),
            initialData: 0,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: 23.5,
                      child: Image.asset(
                        "assets/images/coin.png",
                        fit: BoxFit.fill,
                      )),
                  SizedBox(
                    width: 4,
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
        ),
        SizedBox(
          width: 1,
        ),
        Expanded(
          child: FutureBuilder<int>(
            future: Provider.of<EarningProvider>(context).getCurrentBalance(),
            initialData: 0,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: 23.5,
                      child: Image.asset(
                        "assets/images/taka.png",
                        fit: BoxFit.fill,
                      )),
                  SizedBox(
                    width: 4,
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
        ),
      ],
    );
  }
}
