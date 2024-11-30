import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uas_ezrent/models/notification.dart';
import 'package:uas_ezrent/services/notification_service.dart';

class NotificationScreen extends StatelessWidget {
  final NotificationService _notificationService = NotificationService();

  NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
      ),
      body: StreamBuilder<List<NotificationModel>>(
        stream: _notificationService.getUserNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Tidak ada notifikasi',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final notification = snapshot.data![index];
              return ListTile(
                title: Text(
                  notification.title,
                  style: TextStyle(
                    fontWeight: notification.isRead 
                        ? FontWeight.normal 
                        : FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(notification.message),
                    Text(
                      DateFormat('dd MMM yyyy HH:mm').format(notification.timestamp),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                trailing: !notification.isRead 
                    ? const Icon(Icons.circle, color: Colors.blue, size: 10)
                    : null,
                onTap: () {
                  _notificationService.markNotificationAsRead(notification.id);
                },
              );
            },
          );
        },
      ),
    );
  }
}