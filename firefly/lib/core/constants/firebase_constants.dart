abstract class FirebaseConstants {
  // ! Firebase AI
  static const String geminiModel = 'gemini-2.5-flash';
  static const String geminiBotId = 'gemini_bot';
  static const String geminiAssistant = 'Gemini Asistan';
  static const String errorMessagePrefix = "Bir hata oluştu: ";
  static const String loadingPlaceholder = '...';

  // ! Firebase Auth
  static const String usersCollection = 'users';
  static const String uidField = 'uid';
  static const String emailField = 'email';
  static const String usernameField = 'username';
  static const String createdAtField = 'createdAt';
  static const String defaultUsernamePrefix = 'user_';
  static const String successMessage =
      "Kullanıcı başarıyla Firestore 'users' koleksiyonuna kaydedildi!";

  // ! Firebase Chat
  static const String chatsCollection = 'chats';
  static const String messagesCollection = 'messages';
  static const String lastMessageField = 'lastMessage';
  static const String lastMessageTimeField = 'lastMessageTime';
  static const String typeField = 'type';
  static const String textType = 'text';
  static const String imageType = 'image';
  static const String fileType = 'file';
  static const String chatImagesPath = 'chat_images';
  static const String chatFilesPath = 'chat_files';
  static const String photoDisplay = '📷 Fotoğraf';
  static const String fileDisplayPrefix = '📁 ';

  // ! Firebase Cloud
  static const String notificationPermissionGranted =
      'Kullanıcı bildirim izni verdi.';
  static const String notificationPermissionDenied =
      'Kullanıcı bildirim iznini reddetti veya sınırladı.';
  static const String fcmTokenLog = 'TOKEN DEBUG: ';
  static const String foregroundMessageLog =
      'Uygulama açıkken bildirim geldi: ';
  static const String backgroundMessageLog = 'Arka planda mesaj geldi: ';
  static const String backgroundClickedLog =
      'Arka plandaki bildirime tıklandı. Veri: ';
  static const String terminatedClickedLog =
      'Uygulama tamamen kapalıyken bildirime tıklanarak açıldı. Veri: ';
  static const String fcmInitError =
      'Firebase Messaging başlatılırken hata oluştu: ';

  // ! Firebase Network
  static const String connectionRequestsCollection = 'connection_requests';
  static const String fromIdField = 'fromId';
  static const String toIdField = 'toId';
  static const String statusField = 'status';
  static const String senderUsernameField = 'senderUsername';
  static const String senderEmailField = 'senderEmail';
  static const String receiverUsernameField = 'receiverUsername';
  static const String statusPending = 'Bekliyor';
  static const String statusAccepted = 'accepted';
  static const String statusRejected = 'rejected';
  static const String participantsField = 'participants';
  static const String usernamesField = 'usernames';
  static const String connectionEstablishedMessage = 'Bağlantı kuruldu!';

  // ! Firebase Remote Config
  static const String welcomeMessageKey = 'welcome_message';
  static const String imageUrlKey = 'image_url';
  static const String isHiddenKey = 'is_hidden';
  static const String yearKey = 'year';
  static const String defaultWelcomeMessage = 'Hoş Geldiniz!';
  static const String defaultImageUrl = '';
  static const bool defaultIsHidden = false;
  static const int defaultYear = 2026;
  static const String remoteConfigUpdatedLog =
      "REMOTE CONFIG: Sunucuda değişiklik algılandı! Güncelleniyor...";
  static const String remoteConfigErrorLog = 'Remote Config Başlatılamadı: ';
}
