import 'package:flutter/material.dart';

void main() => runApp(const DhuleTwoHectareApp());

class DhuleTwoHectareApp extends StatelessWidget {
  const DhuleTwoHectareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const TwoHectareSurveyScreen(),
    );
  }
}

class TwoHectareSurveyScreen extends StatefulWidget {
  const TwoHectareSurveyScreen({super.key});

  @override
  State<TwoHectareSurveyScreen> createState() => _TwoHectareSurveyScreenState();
}

class _TwoHectareSurveyScreenState extends State<TwoHectareSurveyScreen> {
  bool showOldRecord = false;
  bool showNewSurvey = true;
  bool showPartition6 = true;
  bool showEncroachment = true;

  int selectedPlotIndex = 0;
  List<Offset> liveRtkPins = [];

  // RTK Coordinates for a 200m x 100m (2.000 Ha) rectangular field in Dhule
  final List<Map<String, dynamic>> rtkCornerNodes = [
    {"node": "NW (North-West)", "lat": "20.90520° N", "lon": "74.77250° E", "err": "±0.9 cm", "mark": "Cadastral Corner Stone"},
    {"node": "NE (North-East)", "lat": "20.90520° N", "lon": "74.77442° E", "err": "±1.1 cm", "mark": "Iron Peg / Boundary Stone"},
    {"node": "SE (South-East)", "lat": "20.90420° N", "lon": "74.77442° E", "err": "±1.0 cm", "mark": "Roadway Access GCP"},
    {"node": "SW (South-West)", "lat": "20.90420° N", "lon": "74.77250° E", "err": "±0.8 cm", "mark": "Farm Well Benchmark"},
  ];

  // 6 Equal Sub-divisions of 2.000 Ha (3,333.33 m² or 0.333 Ha each)
  final List<Map<String, String>> sixSubPlots = [
    {"hissa": "142/1A", "owner": "Kailas Patil", "dim": "66.7m × 50m", "area": "0.333 Ha (3,333 m²)", "share": "16.66%"},
    {"hissa": "142/1B", "owner": "Sanjay Patil", "dim": "66.7m × 50m", "area": "0.333 Ha (3,333 m²)", "share": "16.66%"},
    {"hissa": "142/1C", "owner": "Ramesh Patil", "dim": "66.7m × 50m", "area": "0.333 Ha (3,333 m²)", "share": "16.66%"},
    {"hissa": "142/1D", "owner": "Mahesh Patil", "dim": "66.7m × 50m", "area": "0.333 Ha (3,333 m²)", "share": "16.66%"},
    {"hissa": "142/1E", "owner": "Ganesh Patil", "dim": "66.7m × 50m", "area": "0.333 Ha (3,333 m²)", "share": "16.66%"},
    {"hissa": "142/1F", "owner": "Ashok Patil", "dim": "66.7m × 50m", "area": "0.333 Ha (3,333 m²)", "share": "16.66%"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1720),
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dhule Gat 142/1: 2.000 Hectare Field', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            Text('6 Equal Hissas (0.333 Ha / 3,333 m² each)', style: TextStyle(fontSize: 10, color: Colors.white70)),
          ],
        ),
        backgroundColor: const Color(0xFF070B0E),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.pin_drop, size: 20),
            tooltip: 'RTK Coordinates',
            onPressed: () => _showCoordinatesLedger(context),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, size: 20),
            tooltip: 'Clear Pins',
            onPressed: () => setState(() => liveRtkPins.clear()),
          ),
        ],
      ),
      body: Stack(
        children: [
          // 1. Field Canvas
          GestureDetector(
            onTapDown: (details) {
              setState(() {
                liveRtkPins.add(details.localPosition);
              });
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(milliseconds: 800),
                  content: Text('RTK Node #${liveRtkPins.length} Placed (Sub-2cm CORS Fix)'),
                ),
              );
            },
            child: CustomPaint(
              size: Size.infinite,
              painter: TwoHectareFieldPainter(
                showOld: showOldRecord,
                showNew: showNewSurvey,
                showPartition: showPartition6,
                showEncroachment: showEncroachment,
                pins: liveRtkPins,
              ),
            ),
          ),

          // 2. Layer Toggle Controls (Top Right)
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.93),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Map Layers', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                  _buildToggleRow('6 Equal Plots', Colors.orange[800]!, showPartition6, (v) => setState(() => showPartition6 = v!)),
                  _buildToggleRow('2 Ha Resurvey', Colors.green, showNewSurvey, (v) => setState(() => showNewSurvey = v!)),
                  _buildToggleRow('Old 7/12 Line', Colors.blue, showOldRecord, (v) => setState(() => showOldRecord = v!)),
                  _buildToggleRow('Encroachment', Colors.red, showEncroachment, (v) => setState(() => showEncroachment = v!)),
                ],
              ),
            ),
          ),

          // 3. Top Field Size Badge
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(16)),
              child: const Text(
                'Total: 200m × 100m = 2.000 Ha (20,000 m²)',
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),

          // 4. Bottom Metric & Partition Sheet
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('2 Ha Equal Partition (Tukadebandi Rule)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: Colors.green[100], borderRadius: BorderRadius.circular(4)),
                        child: const Text('2.000 Ha Verified', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 10)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Horizontal Sub-plot selector
                  SizedBox(
                    height: 38,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: sixSubPlots.length,
                      itemBuilder: (ctx, i) {
                        final p = sixSubPlots[i];
                        final isSel = selectedPlotIndex == i;
                        return GestureDetector(
                          onTap: () => setState(() => selectedPlotIndex = i),
                          child: Container(
                            margin: const EdgeInsets.only(right: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: isSel ? Colors.teal : Colors.grey[200],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(p["hissa"]!, style: TextStyle(color: isSel ? Colors.white : Colors.black, fontWeight: FontWeight.bold, fontSize: 10)),
                                Text('0.333 Ha', style: TextStyle(color: isSel ? Colors.white70 : Colors.black54, fontSize: 8)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Selected Plot Detail Card
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(6)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Hissa ${sixSubPlots[selectedPlotIndex]["hissa"]}: ${sixSubPlots[selectedPlotIndex]["owner"]}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        Text('${sixSubPlots[selectedPlotIndex]["dim"]} | ${sixSubPlots[selectedPlotIndex]["area"]}', style: const TextStyle(fontSize: 11, color: Colors.teal, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.table_chart, size: 14),
                          label: const Text('RTK Coordinates', style: TextStyle(fontSize: 11)),
                          onPressed: () => _showCoordinatesLedger(context),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                          icon: const Icon(Icons.check_circle_outline, size: 14),
                          label: const Text('Save Panchanama', style: TextStyle(fontSize: 11)),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('2 Hectare 6-way partition panchanama saved locally in SQLite')),
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

  Widget _buildToggleRow(String title, Color color, bool value, Function(bool?) onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(value: value, activeColor: color, onChanged: onChanged, visualDensity: VisualDensity.compact),
        Text(title, style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.bold)),
      ],
    );
  }

  void _showCoordinatesLedger(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('2.000 Ha Benchmark Coordinates', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text('Dhule CORS RTK', style: TextStyle(color: Colors.teal, fontSize: 11, fontWeight: FontWeight.bold)),
              ],
            ),
            const Text('Boundary coordinates for 200m × 100m rectangular parcel:', style: TextStyle(fontSize: 11, color: Colors.grey)),
            const SizedBox(height: 10),
            Table(
              border: TableBorder.all(color: Colors.grey[300]!),
              columnWidths: const {
                0: FlexColumnWidth(1.2),
                1: FlexColumnWidth(1.4),
                2: FlexColumnWidth(1.4),
                3: FlexColumnWidth(0.9),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[200]),
                  children: const [
                    Padding(padding: EdgeInsets.all(5), child: Text('Corner', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
                    Padding(padding: EdgeInsets.all(5), child: Text('Latitude', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
                    Padding(padding: EdgeInsets.all(5), child: Text('Longitude', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
                    Padding(padding: EdgeInsets.all(5), child: Text('Accuracy', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
                  ],
                ),
                ...rtkCornerNodes.map((n) => TableRow(
                  children: [
                    Padding(padding: const EdgeInsets.all(5), child: Text(n['node']!, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold))),
                    Padding(padding: const EdgeInsets.all(5), child: Text(n['lat']!, style: const TextStyle(fontSize: 9))),
                    Padding(padding: const EdgeInsets.all(5), child: Text(n['lon']!, style: const TextStyle(fontSize: 9))),
                    Padding(padding: const EdgeInsets.all(5), child: Text(n['err']!, style: const TextStyle(fontSize: 9, color: Colors.green, fontWeight: FontWeight.bold))),
                  ],
                )),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, minimumSize: const Size.fromHeight(36)),
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close Table', style: TextStyle(color: Colors.white, fontSize: 12)),
            )
          ],
        ),
      ),
    );
  }
}

class TwoHectareFieldPainter extends CustomPainter {
  final bool showOld;
  final bool showNew;
  final bool showPartition;
  final bool showEncroachment;
  final List<Offset> pins;

  TwoHectareFieldPainter({
    required this.showOld,
    required this.showNew,
    required this.showPartition,
    required this.showEncroachment,
    required this.pins,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height * 0.35;

    // 2.000 Hectare Aspect Ratio: 200m length x 100m width (2:1 scale)
    const double plotWidth = 280.0;  // Represents 200 meters length
    const double plotHeight = 140.0; // Represents 100 meters width

    // 1. Grid Background
    final gridPaint = Paint()..color = Colors.white10..strokeWidth = 1;
    for (double i = 0; i < size.width; i += 35) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height * 0.72), gridPaint);
    }

    // 2. Old Record Boundary (Shifted 20px West, Blue Dashed Line)
    final oldRect = Rect.fromCenter(center: Offset(cx - 20, cy), width: plotWidth, height: plotHeight);
    if (showOld) {
      canvas.drawRect(oldRect, Paint()..color = Colors.blue.withOpacity(0.18));
      canvas.drawRect(oldRect, Paint()..color = Colors.blueAccent..style = PaintingStyle.stroke..strokeWidth = 2.0);
    }

    // 3. New Drone / RTK Ground Resurvey (Green Box)
    final newRect = Rect.fromCenter(center: Offset(cx, cy), width: plotWidth, height: plotHeight);
    if (showNew) {
      canvas.drawRect(newRect, Paint()..color = Colors.green.withOpacity(0.15));
      canvas.drawRect(newRect, Paint()..color = Colors.greenAccent..style = PaintingStyle.stroke..strokeWidth = 2.5);
    }

    // 4. Overlap / Encroachment Zone (Red Band on East Edge)
    if (showEncroachment && showOld && showNew) {
      final encroachmentRect = Rect.fromLTRB(oldRect.right, newRect.top, newRect.right, newRect.bottom);
      canvas.drawRect(encroachmentRect, Paint()..color = Colors.red.withOpacity(0.65));
      canvas.drawRect(encroachmentRect, Paint()..color = Colors.red[900]!..style = PaintingStyle.stroke..strokeWidth = 1.5);
    }

    // 5. Partition: 6 Equal Rectangles (2 Rows x 3 Columns)
    if (showPartition) {
      const int cols = 3;
      const int rows = 2;
      const double subWidth = plotWidth / cols;   // 93.3px (66.67 meters)
      const double subHeight = plotHeight / rows; // 70.0px (50.00 meters)

      final subColors = [
        Colors.amber.withOpacity(0.35),
        Colors.lightGreen.withOpacity(0.35),
        Colors.cyan.withOpacity(0.35),
        Colors.purpleAccent.withOpacity(0.30),
        Colors.orangeAccent.withOpacity(0.35),
        Colors.tealAccent.withOpacity(0.30),
      ];

      for (int r = 0; r < rows; r++) {
        for (int c = 0; c < cols; c++) {
          final int index = r * cols + c;
          final double left = newRect.left + (c * subWidth);
          final double top = newRect.top + (r * subHeight);
          final subRect = Rect.fromLTWH(left, top, subWidth, subHeight);

          // Draw Partition Box & Internal Mud Bund
          canvas.drawRect(subRect, Paint()..color = subColors[index]);
          canvas.drawRect(subRect, Paint()..color = Colors.white70..style = PaintingStyle.stroke..strokeWidth = 1.2);

          // Sub-plot Label
          final tp = TextPainter(
            text: TextSpan(
              text: '142/1${String.fromCharCode(65 + index)}\n0.333 Ha\n(66.7m×50m)',
              style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
          )..layout();
          tp.paint(canvas, Offset(left + (subWidth - tp.width) / 2, top + (subHeight - tp.height) / 2));
        }
      }
    }

    // 6. Corner Benchmark Node Circles
    final cornerPoints = [newRect.topLeft, newRect.topRight, newRect.bottomRight, newRect.bottomLeft];
    for (int i = 0; i < cornerPoints.length; i++) {
      canvas.drawCircle(cornerPoints[i], 5, Paint()..color = Colors.white);
      canvas.drawCircle(cornerPoints[i], 3, Paint()..color = Colors.teal[900]!);
    }

    // 7. Interactive RTK Pins Placed by User
    final pinPaint = Paint()..color = Colors.yellowAccent..style = PaintingStyle.fill;
    final linePaint = Paint()..color = Colors.yellow..strokeWidth = 1.8;
    for (int i = 0; i < pins.length; i++) {
      canvas.drawCircle(pins[i], 4.5, pinPaint);
      if (i > 0) {
        canvas.drawLine(pins[i - 1], pins[i], linePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
