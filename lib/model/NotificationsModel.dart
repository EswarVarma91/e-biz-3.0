class NotificationsModel {
  int not_id;
  String ref_id;
  String notification_type;
  String senderName;
  String receiver_id;
  String created_date;
  String message;
  String created_by;
  String sender_id;
  int status;

  NotificationsModel(
      this.not_id,
      this.ref_id,
      this.notification_type,
      this.senderName,
      this.receiver_id,
      this.created_date,
      this.message,
      this.created_by,
      this.sender_id,
      this.status);

  NotificationsModel.fromJson(Map<String, dynamic> json)
      : not_id = json['not_id'],
        ref_id = json['ref_id'],
        notification_type = json['notification_type'],
        senderName = json['senderName'],
        receiver_id = json['receiver_id'],
        created_date = json['created_date'],
        message = json['message'],
        created_by = json['created_by'],
        sender_id = json['sender_id'],
        status = json['status'];

  Map<String, dynamic> toJson() => {
        'not_id': not_id,
        'ref_id': ref_id,
        'notification_type': notification_type,
        'senderName': senderName,
        'receiver_id': receiver_id,
        'created_date': created_date,
        'message': message,
        'created_by': created_by,
        'sender_id': sender_id,
        'status': status,
      };
}
