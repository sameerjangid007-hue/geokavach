
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() => runApp(const IndiaCadastralApp());

class IndiaCadastralApp extends StatelessWidget {
  const IndiaCadastralApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const AllIndiaCadastralScreen(),
    );
  }
}

class CadastralPlot {
  final String title;
  final String state;
  final String district;
  final double totalHectare;
  final int parts;
  final LatLng center;
  final List<LatLng> oldBoundary;
  final List<LatLng> newBoundary;
  final List<Map<String, String>> rtkLedger;

  CadastralPlot({
    required this.title,
    required this.state,
    required this.district,
    required this.totalHectare,
    required this.parts,
    required this.center,
    required this.oldBoundary,
    required this.newBoundary,
    required this.rtkLedger,
  });
}

class AllIndiaCadastralScreen extends StatefulWidget {
  const AllIndiaCadastralScreen({super.key});

  @override
  State<AllIndiaCadastralScreen> createState() => _AllIndiaCadastralScreenState();
}

class _AllIndiaCadastralScreenState extends State<AllIndiaCadastralScreen> {
  final MapController _mapController = MapController();

  final List<CadastralPlot> allIndiaPlots = [
    CadastralPlot(
      title: "Dhule Gat 142/1",
      state: "Maharashtra",
      district: "Dhule",
      totalHectare: 2.000,
      parts: 6,
      center: const LatLng(20.90420, 74.77346),
      oldBoundary: [
        const LatLng(20.90520, 74.77220),
        const LatLng(20.90520, 74.77442),
        const LatLng(20.90320, 74.77442),
        const LatLng(20.90320, 74.77220),
      ],
      newBoundary: [
        const LatLng(20.90520, 74.77250),
        const LatLng(20.90520, 74.77442),
        const LatLng(20.90320, 74.77442),
        const LatLng(20.90320, 74.77250),
      ],
      rtkLedger: [
        {"pt": "NW", "lat": "20.90520° N", "lon": "74.77250° E", "err": "±0.8 cm"},
        {"pt": "NE", "lat": "20.90520° N", "lon": "74.77442° E", "err": "±1.1 cm"},
        {"pt": "SE", "lat": "20.90320° N", "lon": "74.77442° E", "err": "±0.9 cm"},
        {"pt": "SW", "lat": "20.90320° N", "lon": "74.77250° E", "err": "±0.7 cm"},
      ],
    ),
    CadastralPlot(
      title: "Surat Block 308",
      state: "Gujarat",
      district: "Surat",
      totalHectare: 1.850,
      parts: 4,
      center: const LatLng(21.1702, 72.8311),
      oldBoundary: [
        const LatLng(21.1712, 72.8300),
        const LatLng(21.1712, 72.8322),
        const LatLng(21.1692, 72.8322),
        const LatLng(21.1692, 72.8300),
      ],
      newBoundary: [
        const LatLng(21.1710, 72.8303),
        const LatLng(21.1712, 72.8322),
        const LatLng(21.1692, 72.8322),
        const LatLng(21.1690, 72.8303),
      ],
      rtkLedger: [
        {"pt": "P1", "lat": "21.1710° N", "lon": "72.8303° E", "err": "±1.0 cm"},
        {"pt": "P2", "lat": "21.1712° N", "lon": "72.8322° E", "err": "±0.9 cm"},
        {"pt": "P3", "lat": "21.1692° N", "lon": "72.8322° E", "err": "±1.2 cm"},
        {"pt": "P4", "lat": "21.1690° N", "lon": "72.8303° E", "err": "±0.8 cm"},
      ],
    ),
    CadastralPlot(
      title: "Indore Khasra 512",
      state: "Madhya Pradesh",
      district: "Indore",
      totalHectare: 3.100,
      parts: 5,
      center: const LatLng(22.7196, 75.8577),
      oldBoundary: [
        const LatLng(22.7210, 75.8560),
        const LatLng(22.7210, 75.8595),
        const LatLng(22.7180, 75.8595),
        const LatLng(22.7180, 75.8560),
      ],
      newBoundary: [
        const LatLng(22.7208, 75.8564),
        const LatLng(22.7210, 75.8595),
        const LatLng(22.7180, 75.8595),
        const LatLng(22.7178, 75.8564),
      ],
      rtkLedger: [
        {"pt": "K1", "lat": "22.7208° N", "lon": "75.8564° E", "err": "±0.7 cm"},
        {"pt": "K2", "lat": "22.7210° N", "lon": "75.8595° E", "err": "±0.9 cm"},
        {"pt": "K3", "lat": "22.7180° N", "lon": "75.8595° E", "err": "±1.1 cm"},
        {"pt": "K4", "lat": "22.7178° N", "lon": "75.8564° E", "err": "±0.8 cm"},
      ],
    ),
  ];

  int selectedIndex = 0;
  bool showOld = true;
  bool showNew = true;
  bool showDispute = true;
  bool showPartition = true;
  List<LatLng> customPins = [];

  void _zoomIn() {
    _mapController.move(_mapController.camera.center, _mapController.camera.zoom + 1.0);
  }

  void _zoomOut() {
    _mapController.move(_mapController.camera.center, _mapController.camera.zoom - 1.0);
  }

  void _resetToIndia() {
    _mapController.move(const LatLng(21.7679, 78.8718), 5.0);
  }

  @override
  Widget build(BuildContext context) {
    final plot = allIndiaPlots[selectedIndex];
    final double shareSize = plot.totalHectare / plot.parts;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C1317),
        title: DropdownButtonHideUnderline(
          child: DropdownButton<int>(
            value: selectedIndex,
            dropdownColor: const Color(0xFF1E293B),
            icon: const Icon(Icons.arrow_drop_down, color: Colors.tealAccent),
            items: List.generate(
              allIndiaPlots.length,
              (idx) => DropdownMenuItem(
                value: idx,
                child: Text(
                  "${allIndiaPlots[idx].title} (${allIndiaPlots[idx].state})",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                ),
              ),
            ),
            onChanged: (val) {
              setState(() {
                selectedIndex = val!;
                customPins.clear();
              });
              _mapController.move(allIndiaPlots[selectedIndex].center, 16.5);
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.public, color: Colors.tealAccent),
            tooltip: 'View Entire India Map',
            onPressed: _resetToIndia,
          ),
          IconButton(
            icon: const Icon(Icons.pin_drop),
            tooltip: 'RTK Coordinates',
            onPressed: () => _showCoordinatesLedger(context, plot),
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: plot.center,
              initialZoom: 16.5,
              minZoom: 3.0,
              maxZoom: 19.0,
              onTap: (tapPosition, point) {
                setState(() => customPins.add(point));
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(milliseconds: 900),
                    content: Text('Pinned RTK Point at ${point.latitude.toStringAsFixed(5)}°N, ${point.longitude.toStringAsFixed(5)}°E (Fix: ±0.9cm)'),
                  ),
                );
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                userAgentPackageName: 'com.geokavach.app',
              ),
              PolygonLayer(
                polygons: [
                  if (showOld)
                    Polygon(
                      points: plot.oldBoundary,
                      color: Colors.blue.withOpacity(0.20),
                      borderColor: Colors.blueAccent,
                      borderStrokeWidth: 2.5,
                    ),
                  if (showDispute && showOld && showNew)
                    Polygon(
                      points: [
                        plot.oldBoundary[0],
                        plot.newBoundary[0],
                        plot.newBoundary[3],
                        plot.oldBoundary[3],
                      ],
                      color: Colors.red.withOpacity(0.70),
                      borderColor: Colors.redAccent,
                      borderStrokeWidth: 2.0,
                    ),
                  if (showNew)
                    Polygon(
                      points: plot.newBoundary,
                      color: Colors.green.withOpacity(0.18),
                      borderColor: Colors.greenAccent,
                      borderStrokeWidth: 2.5,
                    ),
                ],
              ),
              if (showPartition)
                PolylineLayer(
                  polylines: _createSubDivisionLines(plot),
                ),
              MarkerLayer(
                markers: customPins.map((pt) {
                  return Marker(
                    point: pt,
                    width: 30,
                    height: 30,
                    child: const Icon(Icons.location_on, color: Colors.amberAccent, size: 28),
                  );
                }).toList(),
              ),
            ],
          ),
          Positioned(
            left: 12,
            bottom: 180,
            child: Column(
              children: [
                FloatingActionButton.small(
                  heroTag: 'zoomIn',
                  backgroundColor: const Color(0xFF1E293B),
                  foregroundColor: Colors.white,
                  onPressed: _zoomIn,
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 6),
                FloatingActionButton.small(
                  heroTag: 'zoomOut',
                  backgroundColor: const Color(0xFF1E293B),
                  foregroundColor: Colors.white,
                  onPressed: _zoomOut,
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(height: 6),
                FloatingActionButton.small(
                  heroTag: 'recenter',
                  backgroundColor: const Color(0xFF1E293B),
                  foregroundColor: Colors.tealAccent,
                  onPressed: () => _mapController.move(plot.center, 16.5),
                  child: const Icon(Icons.my_location),
                ),
              ],
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A).withOpacity(0.92),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Map Layers', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.white70)),
                  _buildToggle('Old 7/12 (Blue)', Colors.blueAccent, showOld, (v) => setState(() => showOld = v!)),
                  _buildToggle('RTK Ground (Green)', Colors.greenAccent, showNew, (v) => setState(() => showNew = v!)),
                  _buildToggle('Error / Shift (Red)', Colors.redAccent, showDispute, (v) => setState(() => showDispute = v!)),
                  _buildToggle('${plot.parts}-Way Partition', Colors.orangeAccent, showPartition, (v) => setState(() => showPartition = v!)),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFF0F172A),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 10)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(plot.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                          Text("${plot.district}, ${plot.state}", style: const TextStyle(fontSize: 10, color: Colors.grey)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(color: Colors.red.withOpacity(0.2), borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.redAccent)),
                        child: const Text('Discrepancy Detected', style: TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(6)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _metricCol('Total Size', '${plot.totalHectare.toStringAsFixed(3)} Ha'),
                        _metricCol('Sub-Plots', '${plot.parts} Equal Hissas'),
                        _metricCol('Per Share', '${shareSize.toStringAsFixed(3)} Ha', color: Colors.tealAccent),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.tealAccent), padding: const EdgeInsets.symmetric(vertical: 8)),
                          icon: const Icon(Icons.pin_drop, size: 14),
                          label: const Text('RTK Coordinates', style: TextStyle(fontSize: 11, color: Colors.white)),
                          onPressed: () => _showCoordinatesLedger(context, plot),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 8)),
                          icon: const Icon(Icons.download_done, size: 14),
                          label: const Text('Export Panchanama', style: TextStyle(fontSize: 11)),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${plot.title} partition data saved to offline SQLite')),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Polyline> _createSubDivisionLines(CadastralPlot plot) {
    final b = plot.newBoundary;
    List<Polyline> polylines = [];
    int slices = plot.parts;

    for (int i = 1; i < slices; i++) {
      double frac = i / slices;
      double topLat = b[0].latitude + frac * (b[1].latitude - b[0].latitude);
      double topLon = b[0].longitude + frac * (b[1].longitude - b[0].longitude);

      double botLat = b[3].latitude + frac * (b[2].latitude - b[3].latitude);
      double botLon = b[3].longitude + frac * (b[2].longitude - b[3].longitude);

      polylines.add(
        Polyline(
          points: [LatLng(topLat, topLon), LatLng(botLat, botLon)],
          strokeWidth: 2.0,
          color: Colors.orangeAccent,
        ),
      );
    }
    return polylines;
  }

  Widget _buildToggle(String label, Color col, bool val, Function(bool?) onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(value: val, activeColor: col, checkColor: Colors.black, onChanged: onChanged, visualDensity: VisualDensity.compact),
        Text(label, style: TextStyle(color: col, fontSize: 9, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _metricCol(String title, String val, {Color color = Colors.white}) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 9, color: Colors.grey)),
        Text(val, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  void _showCoordinatesLedger(BuildContext context, CadastralPlot plot) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F172A),
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${plot.title} RTK Benchmarks', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                const Text('Survey of India CORS Fix', style: TextStyle(color: Colors.tealAccent, fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Table(
              border: TableBorder.all(color: Colors.white24),
              children: [
                const TableRow(
                  decoration: BoxDecoration(color: Color(0xFF1E293B)),
                  children: [
                    Padding(padding: EdgeInsets.all(5), child: Text('Corner', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white))),
                    Padding(padding: EdgeInsets.all(5), child: Text('Latitude', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white))),
                    Padding(padding: EdgeInsets.all(5), child: Text('Longitude', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white))),
                    Padding(padding: EdgeInsets.all(5), child: Text('Accuracy', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.tealAccent))),
                  ],
                ),
                ...plot.rtkLedger.map((n) => TableRow(
                  children: [
                    Padding(padding: const EdgeInsets.all(5), child: Text(n['pt']!, style: const TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold))),
                    Padding(padding: const EdgeInsets.all(5), child: Text(n['lat']!, style: const TextStyle(fontSize: 9, color: Colors.white70))),
                    Padding(padding: const EdgeInsets.all(5), child: Text(n['lon']!, style: const TextStyle(fontSize: 9, color: Colors.white70))),
                    Padding(padding: const EdgeInsets.all(5), child: Text(n['err']!, style: const TextStyle(fontSize: 9, color: Colors.greenAccent, fontWeight: FontWeight.bold))),
                  ],
                )),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, minimumSize: const Size.fromHeight(36)),
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close Ledger', style: TextStyle(color: Colors.white, fontSize: 11)),
            ),
          ],
        ),
      ),
    );
  }
}
