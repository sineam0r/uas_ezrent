import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uas_ezrent/data/dummy_vehicles.dart';
import 'package:uas_ezrent/models/vehicle.dart';
import 'package:uas_ezrent/widgets/favorite/favorite_empty_state.dart';
import 'package:uas_ezrent/widgets/favorite/favorite_grid_card.dart';
import 'package:uas_ezrent/widgets/favorite/favorite_list_card.dart';
import 'package:uas_ezrent/widgets/favorite/favorite_skeleton.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  bool _isGridView = true;

  Future<VehicleModel?> _getVehicleDetails(String vehicleId) async {
    final dummyVehicle = DummyVehicles.popularVehicles.firstWhere(
      (v) => v.id == vehicleId,
      orElse: () => DummyVehicles.popularVehicles.first,
    );
    return dummyVehicle;
  }

  Future<void> _removeFavorite(String documentId) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('favorites')
          .doc(documentId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kendaraan dihapus dari favorit'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menghapus dari favorit'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Kendaraan Favoritku'),
        ),
        body: const FavoriteEmptyState(isLoggedIn: false),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kendaraan Favoritku'),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .collection('favorites')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _isGridView
                  ? GridView.builder(
                      padding: const EdgeInsets.all(8),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: 4,
                      itemBuilder: (context, index) => const FavoriteSkeleton(),
                    )
                  : ListView.builder(
                      itemCount: 4,
                      itemBuilder: (context, index) => const FavoriteSkeleton(),
                    );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const FavoriteEmptyState(isLoggedIn: true);
            }

            return _isGridView
                ? GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var favorite = snapshot.data!.docs[index];
                      return FutureBuilder<VehicleModel?>(
                        future: _getVehicleDetails(favorite['vehicleId']),
                        builder: (context, vehicleSnapshot) {
                          if (!vehicleSnapshot.hasData) {
                            return const FavoriteSkeleton();
                          }
                          return FavoriteGridCard(
                            favorite: favorite,
                            vehicle: vehicleSnapshot.data!,
                            onRemove: _removeFavorite,
                          );
                        },
                      );
                    },
                  )
                : ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var favorite = snapshot.data!.docs[index];
                      return FutureBuilder<VehicleModel?>(
                        future: _getVehicleDetails(favorite['vehicleId']),
                        builder: (context, vehicleSnapshot) {
                          if (!vehicleSnapshot.hasData) {
                            return const FavoriteSkeleton();
                          }
                          return FavoriteListCard(
                            favorite: favorite,
                            vehicle: vehicleSnapshot.data!,
                            onRemove: _removeFavorite,
                          );
                        },
                      );
                    },
                  );
          },
        ),
      ),
    );
  }
}