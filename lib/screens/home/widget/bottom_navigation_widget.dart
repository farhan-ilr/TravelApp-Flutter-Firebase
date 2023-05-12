import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:travel_app/screens/home/home_screen.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: HomeScreen.selectedBottomSwitch,
      builder: (ctx, updateIndex, _) {
        return SalomonBottomBar(
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          currentIndex: HomeScreen.selectedBottomSwitch.value,
          onTap: (index) => HomeScreen.selectedBottomSwitch.value = index,
          items: [
            SalomonBottomBarItem(
              icon: const Icon(Icons.home),
              title: const Text('Home'),
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.search),
              title: const Text('Search'),
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.messenger),
              title: const Text('Messege'),
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.person),
              title: const Text('Profile'),
            ),
          ],
        );
      },
    );
  }
}



// class BottomNavigationCustom extends StatelessWidget {
//   BottomNavigationCustom({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder(
//       valueListenable: HomeScreen.selectedBottomSwitch,
//       builder: (BuildContext ctx, int updateIndex, _) {
//         return Container(
//           padding: const EdgeInsets.only(
//             left: 25,
//             right: 25,
//             bottom: 5,
//           ),
//           color: const Color.fromARGB(135, 255, 255, 255),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(15),
//             child: BottomNavigationBar(
//               currentIndex: updateIndex,
//               onTap: (value) {
//                 HomeScreen.selectedBottomSwitch.value = value;
//               },
//               iconSize: 24,
//               backgroundColor: const Color.fromARGB(255, 165, 160, 160),
//               selectedItemColor: Colors.blue,
//               unselectedItemColor: Color.fromARGB(255, 82, 82, 80),
//               items: const [
//                 BottomNavigationBarItem(
//                   icon: Padding(
//                     padding: EdgeInsets.only(top: 10),
//                     child: Icon(
//                       Icons.home,
//                     ),
//                   ),
//                   label: '',
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Padding(
//                     padding: EdgeInsets.only(top: 10),
//                     child: Icon(Icons.search),
//                   ),
//                   label: '',
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Padding(
//                     padding: EdgeInsets.only(top: 10),
//                     child: Icon(Icons.person),
//                   ),
//                   label: '',
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// const itemList = <IconData>[
//   Icons.home,
//   Icons.search,
//   Icons.message,
//   Icons.person,
// ];

// class BottomNavigation extends StatelessWidget {
//   const BottomNavigation({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder(
//       valueListenable: HomeScreen.selectedBottomSwitch,
//       builder: (ctx, updateIndex, _) {
//         return AnimatedBottomNavigationBar(
//           icons: itemList,
//           gapLocation: GapLocation.center,
//           notchSmoothness: NotchSmoothness.verySmoothEdge,
//           leftCornerRadius: 32,
//           rightCornerRadius: 32,
//           backgroundColor:const
//            Color.fromARGB(107, 54, 51, 39),
//           activeIndex: HomeScreen.selectedBottomSwitch.value,
//           onTap: (index) {
//             HomeScreen.selectedBottomSwitch.value = index;
//           },
//         );
//       },
//     );
//   }
// }


