import 'package:example_messaging/core/constants/firebase_constants.dart';
import 'package:example_messaging/core/constants/system_constants.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:uuid/uuid.dart';

// ! Yapay Zeka Servis Katmanı
// Gemini entegrasyonu ile sohbet akışını ve daktilo efektli mesaj güncellemelerini yönetir
class FirebaseAiService {
  // Initialize the Gemini Developer API backend service
  // Create a `GenerativeModel` instance with a model that supports your use case
  final _chatController = InMemoryChatController();
  InMemoryChatController get chatController => _chatController;

  // ! Modeli seç
  final _model = FirebaseAI.googleAI().generativeModel(
    model: FirebaseConstants.geminiModel,
  );

  // ! Oturumu başlat
  late final _chatSession = _model.startChat();

  Future<void> askAI(String text, String currentUserId) async {
    // ! Kullanıcının mesajını ekrana yazdır
    final userMessage = TextMessage(
      id: const Uuid().v4(),
      authorId: currentUserId,
      text: text,
      createdAt: DateTime.now().toUtc(),
    );
    _chatController.insertMessage(userMessage);

    // ! Gemini'nin cevabı için boş bir başlangıç mesajı oluştur
    final aiMessageId = const Uuid().v4();
    var aiMessage = TextMessage(
      id: aiMessageId,
      authorId: FirebaseConstants.geminiBotId,
      text: FirebaseConstants
          .loadingPlaceholder, // Başlangıçta yükleniyor hissi vermek için 3 nokta koyuyoruz
      status: MessageStatus
          .sending, // ! Saat ikonunu dönen bir loading animasyonu yapar
      createdAt: DateTime.now().toUtc(),
    );
    _chatController.insertMessage(aiMessage);

    try {
      // ! Gemini'ye mesajı gönder ve al
      final stream = _chatSession.sendMessageStream(Content.text(text));
      String accumulatedText = SystemConstants.emptyString;

      // ! Cevap parça parça (chunk) geldikçe bu döngü tetiklenir
      await for (final chunk in stream) {
        if (chunk.text != null) {
          final String chunkText = chunk.text!;

          // ! Gelen bloğu (chunk) zorla HARF HARF yazdırma döngüsü
          for (int i = 0; i < chunkText.length; i++) {
            await Future.delayed(const Duration(milliseconds: 15));

            accumulatedText += chunkText[i];

            // ! Mesajı yeni metinle kopyalayıp ekranda güncelliyoruz (Daktilo Efekti)
            final updatedMessage = aiMessage.copyWith(
              text: accumulatedText,
              status: MessageStatus
                  .delivered, // ! Artık kelimeler geldiği için loading ikonunu kaldır
            );

            _chatController.updateMessage(aiMessage, updatedMessage);

            // ! Referansı bir sonraki harf için güncelliyoruz
            aiMessage = updatedMessage;
          }
        }
      }
    } catch (e) {
      // ! Hatayı tam bir metin olarak hazırla
      final String fullErrorText = "${FirebaseConstants.errorMessagePrefix}: $e";
      String accumulatedErrorText = "";

      // ! Önce mesajın ikonunu anında "hata" durumuna (kırmızı ünlem vb.) çevir
      var errorStatusMessage = aiMessage.copyWith(
        text: SystemConstants.emptyString,
        status: MessageStatus.error,
      );
      _chatController.updateMessage(aiMessage, errorStatusMessage);

      // ! Referansı mesaja ata
      aiMessage = errorStatusMessage;

      // ! Hatayı harf harf yazdırma döngüsü
      for (int i = 0; i < fullErrorText.length; i++) {
        await Future.delayed(const Duration(milliseconds: 15));

        accumulatedErrorText += fullErrorText[i];

        final updatedMessage = aiMessage.copyWith(text: accumulatedErrorText);

        _chatController.updateMessage(aiMessage, updatedMessage);

        // ! Referansı ata
        aiMessage = updatedMessage;
      }
    }
  }
}
