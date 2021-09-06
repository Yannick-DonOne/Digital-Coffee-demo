import 'package:flutter/material.dart';
import 'package:flutter_application_1/colors.dart';
import 'package:flutter_application_1/dats_model.dart';

class HistoryPage extends StatelessWidget {
  final DataModel data;

  const HistoryPage(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var episodeData = data.episodesData;
    var currenyIndex = data.index;
    var max = data.max;
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.only(top: 15.0),
      child: Row(
        children: [
          Container(
            height: size.height * 0.08,
            width: size.width * 0.16,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(size.width * 0.05),
              ),
              image: const DecorationImage(
                image: NetworkImage(
                    'https://cdn.pixabay.com/photo/2017/01/18/17/14/girl-1990347_960_720.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            width: size.width * 0.04,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: size.width * 0.7,
                child: Text(
                  episodeData[currenyIndex]['episodeTitle'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: TextStyle(
                      color: textColor,
                      fontSize: size.width * 0.04,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: size.width * 0.005,
              ),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: size.width * 0.045,
                    color: subTextColor,
                  ),
                  SizedBox(
                    width: size.width * 0.02,
                  ),
                  Text(
                    '29 ' 'mins',
                    style: TextStyle(
                      color: subTextColor,
                      fontSize: size.width * 0.035,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
