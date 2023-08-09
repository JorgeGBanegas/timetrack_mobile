import 'package:flutter/material.dart';
import 'package:time_track/data/models/record.dart';

class ItemCard extends StatelessWidget {
  final Record item;
  const ItemCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Card(
        child: Row(
          children: [
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                      '${item.date.split(' ')[0].substring(0, 3)} ${item.date.split(' ')[0].substring(3, 5)}',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(item.date.split(' ')[3],
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Icon(Icons.door_front_door, color: Colors.green),
                      Text(item.checkIn, style: const TextStyle(fontSize: 18)),
                      const Icon(Icons.door_back_door, color: Colors.red),
                      Text(item.checkOut, style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
