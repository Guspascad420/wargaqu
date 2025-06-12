import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wargaqu/pages/auth/RW/rw_login_form.dart';
import 'package:wargaqu/pages/auth/RT/rt_login_form.dart';
import 'package:wargaqu/pages/auth/citizen/citizen_login_form.dart';

class LoginChoiceScreen extends StatelessWidget {
  const LoginChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/wargaqu.png', scale: 2.5,),
            const SizedBox(height: 20),
            Text('Anda Ingin Masuk Sebagai', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const CitizenLoginForm())
                    );
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: Color(0xFF5D9BF8),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Image.asset('images/pana.png', scale: 2.3),
                          const SizedBox(height: 10),
                          Text('Sebagai Warga', style: GoogleFonts.roboto(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )),
                        ],
                      )
                  )
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const RtLoginForm())
                    );
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                      decoration: BoxDecoration(
                        color: Color(0xFFEE4F57),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Image.asset('images/admin_pana.png', scale: 2.3),
                          const SizedBox(height: 10),
                          Text('Sebagai RT', style: GoogleFonts.roboto(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )),
                        ],
                      )
                  )
                )
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const RwLoginForm())
                );
              },
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    color: Color(0xFF58B961),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Image.asset('images/rafiki.png', scale: 2.3),
                      const SizedBox(height: 10),
                      Text('Sebagai RW', style: GoogleFonts.roboto(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )),
                    ],
                  )
              )
            ),
          ],
        ),
      )
    );
  }
}