import 'package:dealsdray/providers/banner_and_product_provider.dart';
import 'package:dealsdray/screens/home/widgets/banner_widget.dart';
import 'package:dealsdray/widgets/bottom_nav_widget.dart';
import 'package:dealsdray/widgets/category_widget.dart';
import 'package:dealsdray/screens/home/widgets/decorated_container.dart';
import 'package:dealsdray/widgets/kyc_card.dart';
import 'package:dealsdray/widgets/my_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(bannerAndProductProvider.notifier).fetchBanners(),
    );
    Future.microtask(
      () => ref.read(bannerAndProductProvider.notifier).fetchProducts(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bannerAndProductProvider);
    final bannerList = state.banners ?? [];
    final productList = state.products ?? [];
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(68),
        child: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: MyHeader(),
        ),
      ),

      backgroundColor: Color(0xffFAFAFA),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            // Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 160,
                child:
                    state.step == HomeScreenStep.loading
                        ? Center(child: CircularProgressIndicator())
                        : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: bannerList.length,
                          itemBuilder: (ctx, index) {
                            return PromoBannerCard(banner: bannerList[index]);
                          },
                        ),
              ),
            ),
            SizedBox(height: 12),
            // KYC Card
            KycCard(),
            SizedBox(height: 18),
            // Categories horizontal
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                height: 83,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CategoryIcon('Mobile', Icons.phone_android, Colors.purple),
                    CategoryIcon('Laptop', Icons.laptop, Colors.green),
                    CategoryIcon('Camera', Icons.camera_alt, Colors.redAccent),
                    CategoryIcon('LED', Icons.tv, Colors.orange),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            DecoratedContainer(productList: productList),
          ],
        ),
      ),
      // Floating Chat Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: Colors.redAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: Colors.white, width: 2),
        ),
        icon: Icon(Icons.chat_bubble_outline, color: Colors.white),
        label: Text(
          'Chat',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            fontFamily: 'Montserrat',
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavWidget(),
    );
  }
}
