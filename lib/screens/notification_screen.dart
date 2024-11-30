import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uas_ezrent/models/notification.dart';
import 'package:uas_ezrent/services/notification_service.dart';

class NotificationScreen extends StatelessWidget {
  final NotificationService _notificationService = NotificationService();

  NotificationScreen({super.key});

  Widget _buildNotificationContent(BuildContext context, List<NotificationModel> notifications) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Notifikasi',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Card(
                    color: Colors.white,
                    elevation: 2,
                    child: ListTile(
                      title: Text(
                        notification.title,
                        style: GoogleFonts.poppins(
                          fontWeight: notification.isRead
                              ? FontWeight.normal
                              : FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notification.message,
                            style: GoogleFonts.poppins(),
                          ),
                          Text(
                            DateFormat('dd MMM yyyy HH:mm').format(notification.timestamp),
                            style: GoogleFonts.poppins(
                              color: Colors.grey, 
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      trailing: !notification.isRead 
                          ? const Icon(Icons.circle, color: Colors.blue, size: 10)
                          : null,
                      onTap: () {
                        _notificationService.markNotificationAsRead(notification.id);
                      },
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Notifikasi',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: StreamBuilder<List<NotificationModel>>(
        stream: _notificationService.getUserNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'Tidak ada notifikasi',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            );
          }

          return _buildNotificationContent(context, snapshot.data!);
        },
      ),
    );
  }
}