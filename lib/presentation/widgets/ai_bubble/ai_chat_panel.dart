import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/data_sources/remote/ai_photo_edit_service.dart';
import '../../../data/data_sources/remote/photo_service.dart';
import '../../../data/local/storage_service.dart';
import '../image_picker_bottom_sheet.dart';
import 'widgets/chat_message_bubble.dart';
import 'widgets/chat_input_bar.dart';
import 'widgets/suggested_prompt_chips.dart';

class AiChatPanel extends StatefulWidget {
  final String? initialPhotoId;
  final String? initialPhotoUrl;

  const AiChatPanel({
    super.key,
    this.initialPhotoId,
    this.initialPhotoUrl,
  });

  @override
  State<AiChatPanel> createState() => _AiChatPanelState();
}

class _AiChatPanelState extends State<AiChatPanel> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String? _currentPhotoId;
  String? _currentPhotoUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _addBotGreeting();
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addBotGreeting() {
    if (widget.initialPhotoId != null) {
      _currentPhotoId = widget.initialPhotoId;
      _currentPhotoUrl = widget.initialPhotoUrl;

      _messages.add(ChatMessage(
        isBot: false,
        imageUrl: widget.initialPhotoUrl,
      ));
      _messages.add(ChatMessage(
        isBot: true,
        text: 'Bạn muốn chỉnh sửa gì?',
        actions: [
          'Làm sáng hơn',
          'Làm ấm hơn',
          'Xóa nền',
          'Thêm hoàng hôn',
          'Phong cách tranh vẽ',
        ],
      ));
    } else {
      _messages.add(ChatMessage(
        isBot: true,
        text: 'Chào bạn! Hãy chọn hoặc chụp ảnh để mình chỉnh sửa nhé!',
        actions: ['Chọn từ thư viện', 'Chụp ảnh mới'],
      ));
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _handleAction(String action) async {
    switch (action) {
      case 'Chọn từ thư viện':
      case 'Chụp ảnh mới':
        await _pickImage();
        break;
      case 'Lưu ảnh':
        _savePhoto();
        break;
      case 'Sửa tiếp':
        _continueEditing();
        break;
      case 'Thử lại':
        _retryLastPrompt();
        break;
      default:
        // Treat as a prompt suggestion
        _sendPrompt(action);
    }
  }

  Future<void> _pickImage() async {
    final imagePath = await ImagePickerBottomSheet.show(context);
    if (imagePath == null || !mounted) return;

    setState(() {
      _messages.add(ChatMessage(
        isBot: false,
        imageUrl: imagePath,
      ));
      _isLoading = true;
      _messages.add(ChatMessage(isBot: true, isLoading: true));
    });
    _scrollToBottom();

    // Upload the local image to get a photoId
    try {
      final userId = StorageService.instance.userId;
      if (userId == null) {
        _replaceLastBotMessage(ChatMessage(
          isBot: true,
          text: 'Bạn cần đăng nhập để sử dụng tính năng này.',
        ));
        return;
      }

      final photoDto = await PhotoService.instance.uploadPhoto(
        localFilePath: imagePath,
        userId: userId,
      );

      if (photoDto == null) {
        _replaceLastBotMessage(ChatMessage(
          isBot: true,
          text: 'Không thể tải ảnh lên. Vui lòng thử lại.',
          actions: ['Chọn từ thư viện', 'Chụp ảnh mới'],
        ));
        return;
      }

      _currentPhotoId = photoDto.id;
      _currentPhotoUrl = photoDto.filePath;

      _replaceLastBotMessage(ChatMessage(
        isBot: true,
        text: 'Đã nhận ảnh! Bạn muốn chỉnh sửa gì?',
      ));

      // Add suggestion chips as a separate message
      setState(() {
        _messages.add(ChatMessage(
          isBot: true,
          text: 'Gợi ý:',
          actions: [
            'Làm sáng hơn',
            'Làm ấm hơn',
            'Xóa nền',
            'Thêm hoàng hôn',
            'Phong cách tranh vẽ',
          ],
        ));
      });
    } catch (e) {
      _replaceLastBotMessage(ChatMessage(
        isBot: true,
        text: 'Lỗi khi tải ảnh: $e',
        actions: ['Chọn từ thư viện', 'Chụp ảnh mới'],
      ));
    } finally {
      setState(() => _isLoading = false);
      _scrollToBottom();
    }
  }

  void _sendPrompt(String prompt) {
    if (prompt.trim().isEmpty) return;

    if (_currentPhotoId == null) {
      setState(() {
        _messages.add(ChatMessage(isBot: false, text: prompt));
        _messages.add(ChatMessage(
          isBot: true,
          text: 'Bạn cần chọn ảnh trước khi chỉnh sửa.',
          actions: ['Chọn từ thư viện', 'Chụp ảnh mới'],
        ));
      });
      _scrollToBottom();
      return;
    }

    _inputController.clear();
    _callAiEdit(prompt);
  }

  Future<void> _callAiEdit(String prompt) async {
    setState(() {
      _messages.add(ChatMessage(isBot: false, text: prompt));
      _isLoading = true;
      _messages.add(ChatMessage(isBot: true, isLoading: true));
    });
    _scrollToBottom();

    try {
      final result = await AiPhotoEditService.instance.editPhoto(
        photoId: _currentPhotoId!,
        prompt: prompt,
      );

      _currentPhotoId = result.id;
      _currentPhotoUrl = result.filePath;

      _replaceLastBotMessage(ChatMessage(
        isBot: true,
        text: 'Đây là kết quả! Bạn thích không?',
        imageUrl: result.filePath,
        photoId: result.id,
        actions: ['Lưu ảnh', 'Sửa tiếp'],
      ));
    } on AiEditFailure catch (e) {
      _replaceLastBotMessage(ChatMessage(
        isBot: true,
        text: '${e.message}${e.suggestion != null ? '\n💡 ${e.suggestion}' : ''}',
        actions: ['Thử lại', 'Chọn từ thư viện'],
      ));
    } catch (e) {
      _replaceLastBotMessage(ChatMessage(
        isBot: true,
        text: 'Đã xảy ra lỗi: $e',
        actions: ['Thử lại'],
      ));
    } finally {
      setState(() => _isLoading = false);
      _scrollToBottom();
    }
  }

  void _replaceLastBotMessage(ChatMessage newMessage) {
    setState(() {
      // Find and replace the last bot loading message
      for (int i = _messages.length - 1; i >= 0; i--) {
        if (_messages[i].isBot && _messages[i].isLoading) {
          _messages[i] = newMessage;
          return;
        }
      }
      // If no loading message found, just add
      _messages.add(newMessage);
    });
  }

  Future<void> _savePhoto() async {
    if (_currentPhotoUrl == null || !mounted) return;

    try {
      setState(() => _isLoading = true);

      // Download image from presigned URL
      final appDir = await getApplicationDocumentsDirectory();
      final photosDir = Directory('${appDir.path}/memore/photos');
      if (!await photosDir.exists()) {
        await photosDir.create(recursive: true);
      }

      final fileName = 'ai_edited_${DateTime.now().millisecondsSinceEpoch}.png';
      final savePath = '${photosDir.path}/$fileName';

      await Dio().download(_currentPhotoUrl!, savePath);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ảnh đã được lưu vào thư viện!'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lưu ảnh thất bại: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _continueEditing() {
    setState(() {
      _messages.add(ChatMessage(
        isBot: true,
        text: 'Bạn muốn chỉnh sửa thêm gì?',
        actions: [
          'Làm sáng hơn',
          'Làm ấm hơn',
          'Xóa nền',
          'Thêm hoàng hôn',
          'Phong cách tranh vẽ',
        ],
      ));
    });
    _scrollToBottom();
  }

  void _retryLastPrompt() {
    // Find the last user text message
    for (int i = _messages.length - 1; i >= 0; i--) {
      if (!_messages[i].isBot && _messages[i].text != null) {
        _callAiEdit(_messages[i].text!);
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.auto_fix_high, size: 16, color: Colors.white),
            ),
            const SizedBox(width: 10),
            const Text(
              'Memore AI',
              style: TextStyle(
                color: AppColors.text,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ChatMessageBubble(
                  message: _messages[index],
                  onActionTap: _handleAction,
                );
              },
            ),
          ),
          if (_currentPhotoId != null && !_isLoading)
            SuggestedPromptChips(
              onPromptSelected: _sendPrompt,
            ),
          ChatInputBar(
            controller: _inputController,
            isLoading: _isLoading,
            onSend: () => _sendPrompt(_inputController.text),
            onAttach: _pickImage,
          ),
        ],
      ),
    );
  }
}
