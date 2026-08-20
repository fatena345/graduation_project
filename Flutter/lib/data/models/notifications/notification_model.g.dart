// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      body: json['body'] as String?,
      notificationType: json['notification_type'] as String?,
      data: json['data'] as Map<String, dynamic>?,
      isRead: json['is_read'] as bool?,
      createdAt: json['created_at'] as String?,
    );

NotificationsListModel _$NotificationsListModelFromJson(
  Map<String, dynamic> json,
) => NotificationsListModel(
  notifications: (json['notifications'] as List<dynamic>?)
      ?.map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  unreadCount: (json['unread_count'] as num?)?.toInt(),
);
