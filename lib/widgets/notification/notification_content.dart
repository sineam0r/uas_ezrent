import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uas_ezrent/models/notification.dart';
import 'package:uas_ezrent/services/notification_service.dart';
import 'package:uas_ezrent/services/booking_service.dart';
import 'package:uas_ezrent/screens/booking_detail_screen.dart';

class NotificationContent extends StatelessWidget {
  final List<NotificationModel> notifications;
  final NotificationService notificationService;

  const NotificationContent({
    super.key,
    required this.notifications,
    required this.notificationService,
  });

  @override
  Widget build(BuildContext context) {
    final bookingService = BookingService();

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          elevation: 0,
          color: notification.isRead ? Colors.white : Colors.blue[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              width: 0.5,
              color: Colors.grey[400]!,
            ),
          ),
          child: Dismissible(
            key: Key(notification.id),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) async {
              await notificationService.deleteNotification(notification.id);
            },
            child: InkWell(
              onTap: () async {
                if (!notification.isRead) {
                  await notificationService.markNotificationAsRead(notification.id);
                }
                if (notification.bookingId != null && notification.bookingId!.isNotEmpty) {
                  try {
                    final booking = await bookingService.getBooking(notification.bookingId!);
                    if (booking != null) {
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingDetailScreen(booking: booking),
                        ),
                      );
                    } else {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Booking tidak ditemukan'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } catch (e) {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error membuka detail booking: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: ListTile(
                title: Text(
                  notification.title,
                  style: GoogleFonts.poppins(
                    fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w600,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.message,
                      style: GoogleFonts.poppins(),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.timestamp.toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                trailing: !notification.isRead
                    ? Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                      )
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }
}