import 'package:flutter/material.dart';
import 'package:myapp/screens/home_screen.dart';
import 'package:myapp/screens/widgets/page_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  bool isLastPage = false;
  final controller = PageController();
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  late List<PageModel> pages;
  void _addPages() {
    pages = <PageModel>[];
    pages.add(
      PageModel('assets/images/image1.jpg', Icons.ac_unit, 'Welcome!',
          '1- Making friends is easy as waving your hand back and forth  in easy step'),
    );
    pages.add(PageModel('assets/images/image2.jpg', Icons.alarm, 'Alarm',
        '2- Making friends is easy as waving your hand back and forth  in easy step'));
    pages.add(PageModel('assets/images/image3.jpg', Icons.print, 'Print',
        '3- Making friends is easy as waving your hand back and forth  in easy step'));
    pages.add(PageModel('assets/images/image4.jpg', Icons.map, 'Map',
        '4- Making friends is easy as waving your hand back and forth  in easy step'));
  }

  @override
  Widget build(BuildContext context) {
    _addPages();

    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 70),
            child: PageView.builder(
              controller: controller,
              itemBuilder: ((context, index) {
                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: ExactAssetImage(pages[index].image!),
                            fit: BoxFit.cover),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Transform.translate(
                          offset: Offset(0, -100),
                          child: Icon(
                            pages[index].icon,
                            size: 150,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          pages[index].title!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 48, right: 48),
                          child: Text(
                            pages[index].description!,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
              itemCount: pages.length,
              onPageChanged: (index) => setState(() {
                isLastPage = index == 3;
              }),
            ),
          ),
        ],
      ),
      bottomSheet: isLastPage
          ? SizedBox(
              width: double.infinity,
              height: 70,
              child: ElevatedButton(
                  child: Text(
                    'GET STARTED',
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade800),
                  onPressed: () {
                    _updateSeen();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  }))
          : Container(
              color: Colors.grey.shade900,
              padding: EdgeInsets.symmetric(horizontal: 8),
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: Text(
                      'SKIP',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => controller.jumpToPage(pages.length),
                  ),
                  Center(
                    child: SmoothPageIndicator(
                        controller: controller,
                        count: pages.length,
                        effect: WormEffect(
                          spacing: 16,
                          dotColor: Colors.grey,
                          activeDotColor: Colors.red,
                        ),
                        onDotClicked: (index) => controller.animateToPage(index,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut)),
                  ),
                  TextButton(
                    child: Text(
                      'NEXT',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut),
                  ),
                ],
              ),
            ),
    );
  }

  void _updateSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('seen', true);
  }
}
