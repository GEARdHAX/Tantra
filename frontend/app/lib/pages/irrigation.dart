import 'package:flutter/material.dart';
import 'fertilizerPage.dart';

class FieldScreen extends StatefulWidget {
  @override
  _FieldScreenState createState() => _FieldScreenState();
}

class _FieldScreenState extends State<FieldScreen> {
  final List<Map<String, String>> fields = [
    {
      "name": "Wheat Field",
      "image": "assets/pic1.jpg",
      "irrigation": "70%",
      "pesticides": "2 sprays",
    },
    {
      "name": "Corn Field",
      "image": "assets/pic3.jpg",
      "irrigation": "50%",
      "pesticides": "1 spray",
    },
    {
      "name": "Empty Field",
      "image": "assets/pic1.jpg",
      "irrigation": "0%",
      "pesticides": "None",
    },
  ];

  double progress = 0.0;
  bool isIrrigating = false;

  void startIrrigation() {
    setState(() {
      isIrrigating = true;
      progress = 0.0;
    });

    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 200));
      if (progress >= 1.0) return false;
      setState(() => progress += 0.1);
      return true;
    }).then((_) {
      setState(() => isIrrigating = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(229, 237, 225, 1.0),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Fields Overview",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black45,
              ),
            ),
          ),
          const SizedBox(height: 20),

          SizedBox(
            height: 500,
            child: PageView.builder(
              itemCount: fields.length,
              controller: PageController(viewportFraction: 0.8),
              itemBuilder: (context, index) {
                final field = fields[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FieldDashboard(farm: farmDataList[index]), // ✅ send correct farm by index
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        image: DecorationImage(
                          image: AssetImage(field["image"]!),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.4),
                            BlendMode.darken,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 40.0, bottom: 40),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                field["name"]!,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Irrigation: ${field["irrigation"]}",
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "Pesticides: ${field["pesticides"]}",
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 20),

                              ElevatedButton(
                                onPressed: isIrrigating ? null : startIrrigation,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  "Perform Irrigation Now",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              const SizedBox(height: 10),

                              if (isIrrigating)
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: SizedBox(
                                      width: 200,
                                      child: LinearProgressIndicator(
                                        value: progress,
                                        minHeight: 10,
                                        backgroundColor: Colors.white24,
                                        valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          Colors.green,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
