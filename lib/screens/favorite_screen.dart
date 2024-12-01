import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uas_ezrent/data/dummy_vehicles.dart';
import 'package:uas_ezrent/models/vehicle.dart';
import 'package:uas_ezrent/widgets/favorite/favorite_empty_state.dart';
import 'package:uas_ezrent/widgets/favorite/favorite_list_card.dart';
import 'package:uas_ezrent/widgets/favorite/favorite_skeleton.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  Future<VehicleModel?> _getVehicleDetails(String vehicleId) async {
    try {
      return DummyVehicles.popularVehicles.firstWhere(
        (v) => v.id == vehicleId,
      );
    } catch (e) {
      return null;
    }
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

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Kendaraan dihapus dari favorit',
              style: GoogleFonts.poppins(),
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.blueAccent,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal menghapus dari favorit',
              style: GoogleFonts.poppins(),
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text(
            'Kendaraan Favoritku',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0,
        ),
        body: const FavoriteEmptyState(isLoggedIn: false),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Kendaraan Favoritku',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: RefreshIndicator(
        backgroundColor: Colors.white,
        color: Colors.blueAccent,
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
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: 4,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) => const FavoriteSkeleton(),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const FavoriteEmptyState(isLoggedIn: true);
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: snapshot.data!.docs.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
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