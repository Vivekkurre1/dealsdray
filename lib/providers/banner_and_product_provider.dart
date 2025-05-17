import 'package:dealsdray/models/product.dart';
import 'package:dealsdray/models/promo_banner.dart';
import 'package:dealsdray/providers/dummyData.dart';
import 'package:dealsdray/services/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum HomeScreenStep { idle, loading, loaded, error }

class HomeScreenState {
  final HomeScreenStep step;
  final String? error;
  final List<PromoBanner>? banners;
  final List<Product>? products;

  HomeScreenState({
    this.step = HomeScreenStep.idle,
    this.error,
    this.banners,
    this.products,
  });

  HomeScreenState copyWith({
    HomeScreenStep? step,
    String? error,
    List<PromoBanner>? banners,
    List<Product>? products,
  }) => HomeScreenState(
    step: step ?? this.step,
    error: error,
    banners: banners ?? this.banners,
    products: products ?? this.products,
  );
}

class BannerAndProductNotifier extends StateNotifier<HomeScreenState> {
  final ApiService apiService;

  BannerAndProductNotifier({required this.apiService})
    : super(HomeScreenState());

  Future<void> fetchBanners() async {
    state = state.copyWith(step: HomeScreenStep.loading, error: null);
    try {
      final response =
          dummyGetBannersResponse; // await apiService.getBanners();
      final List<PromoBanner> banners =
          (response['body'] as List)
              .map((banner) => PromoBanner.fromJson(banner))
              .toList();
      state = state.copyWith(step: HomeScreenStep.loaded, banners: banners);
    } catch (e) {
      state = state.copyWith(step: HomeScreenStep.error, error: e.toString());
    }
  }

  Future<void> fetchProducts() async {
    state = state.copyWith(step: HomeScreenStep.loading, error: null);
    try {
      final response =
          dummyGetProductsResponse; // await apiService.getProducts();
      final List<Product> products =
          (response['body'] as List)
              .map((product) => Product.fromJson(product))
              .toList();
      state = state.copyWith(step: HomeScreenStep.loaded, products: products);
    } catch (e) {
      state = state.copyWith(step: HomeScreenStep.error, error: e.toString());
    }
  }
}

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final bannerAndProductProvider =
    StateNotifierProvider<BannerAndProductNotifier, HomeScreenState>((ref) {
      final apiService = ref.watch(apiServiceProvider);
      return BannerAndProductNotifier(apiService: apiService);
    });
