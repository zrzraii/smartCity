import 'package:flutter/material.dart';
import 'package:smart_city/l10n/gen/app_localizations.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';

import '../data/mock.dart';
import '../ui/design.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(t.tabMap)),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
        options: MapOptions(
          initialCenter: const LatLng(43.238949, 76.889709),
          initialZoom: 11,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'smart_city',
          ),
          MarkerLayer(
            markers: [
              for (final place in mockPlaces)
                Marker(
                  point: LatLng(place.lat, place.lng),
                  width: 44,
                  height: 44,
                  child: GestureDetector(
                    onTap: () => context.push('/map/place/${place.id}'),
                    child: Icon(
                      place.type == 'airport' ? Icons.flight : Icons.train,
                      color: Theme.of(context).colorScheme.primary,
                      size: 32,
                    ),
                  ),
                ),
            ],
          ),
        ],
            ),
          ),
        ],
      ),
    );
  }
}
