import 'package:flutter/material.dart';

class ChatContent extends StatefulWidget {
  const ChatContent({Key? key}) : super(key: key);

  @override
  State<ChatContent> createState() => _ChatContentState();
}

class _ChatContentState extends State<ChatContent> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  String _selectedUser = "Jason Ray";

  final List<ChatUser> _users = [
    ChatUser(
      name: "Jason Ray",
      lastMessage: "How are you today?",
      time: "12m",
      hasUnread: true,
      imageUrl: "assets/images/avatar1.png",
    ),
    ChatUser(
      name: "Jamie Taylor",
      lastMessage: "Let me know when you're free",
      time: "24m",
      hasUnread: false,
      imageUrl: "assets/images/avatar2.png",
    ),
    ChatUser(
      name: "Sarah Town",
      lastMessage: "Thanks for your help",
      time: "1h",
      hasUnread: false,
      imageUrl: "assets/images/avatar3.png",
    ),
    ChatUser(
      name: "Amy Ford",
      lastMessage: "I'll check and get back to you",
      time: "2h",
      hasUnread: true,
      imageUrl: "assets/images/avatar4.png",
    ),
    ChatUser(
      name: "Paul Wilson",
      lastMessage: "The results look good",
      time: "3h",
      hasUnread: false,
      imageUrl: "assets/images/avatar5.png",
    ),
    ChatUser(
      name: "Ana Williams",
      lastMessage: "See you tomorrow",
      time: "5h",
      hasUnread: false,
      imageUrl: "assets/images/avatar6.png",
    ),
  ];

  final List<ChatMessage> _messages = [
    ChatMessage(
      sender: "Jason Ray",
      message:
          "Today I don't feel very good. I still feel easily and have occasional dizziness. I'm not sure if it's related to my blood pressure. I'm still trying to understand what's going on. I don't feel very better.",
      time: "11:30 AM",
      isMe: false,
    ),
    ChatMessage(
      sender: "Admin",
      message:
          "I'm sorry to hear you're not feeling well. To better understand your situation and provide appropriate care, could you measure your blood pressure? I'll let you know if we need to make any adjustments to your medications. Also, continue to drink water.",
      time: "11:32 AM",
      isMe: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      child: Row(
        children: [
          // Users List
          Container(
            width: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                right: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search here...",
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                // Users List
                Expanded(
                  child: ListView.builder(
                    itemCount: _users.length,
                    itemBuilder: (context, index) {
                      final user = _users[index];
                      final isSelected = user.name == _selectedUser;
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedUser = user.name;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          color:
                              isSelected ? Colors.blue[50] : Colors.transparent,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.grey[300],
                                child: Text(user.name[0]),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      user.lastMessage,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    user.time,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                  if (user.hasUnread)
                                    Container(
                                      margin: const EdgeInsets.only(top: 4),
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Chat Area
          Expanded(
            child: Column(
              children: [
                // Chat Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey[300],
                        child: Text(_selectedUser[0]),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _selectedUser,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.more_vert),
                    ],
                  ),
                ),
                // Messages Area
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.builder(
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: message.isMe
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              if (!message.isMe) ...[
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Colors.grey[300],
                                  child: Text(message.sender[0]),
                                ),
                                const SizedBox(width: 8),
                              ],
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.4,
                                ),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: message.isMe
                                      ? Colors.blue
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      message.message,
                                      style: TextStyle(
                                        color: message.isMe
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      message.time,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: message.isMe
                                            ? Colors.white.withOpacity(0.7)
                                            : Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Message Input
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: "Write something...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: IconButton(
                          icon: const Icon(Icons.send, color: Colors.white),
                          onPressed: () {
                            if (_messageController.text.trim().isNotEmpty) {
                              setState(() {
                                _messages.add(
                                  ChatMessage(
                                    sender: "Admin",
                                    message: _messageController.text,
                                    time: "Just now",
                                    isMe: true,
                                  ),
                                );
                              });
                              _messageController.clear();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatUser {
  final String name;
  final String lastMessage;
  final String time;
  final bool hasUnread;
  final String imageUrl;

  ChatUser({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.hasUnread,
    required this.imageUrl,
  });
}

class ChatMessage {
  final String sender;
  final String message;
  final String time;
  final bool isMe;

  ChatMessage({
    required this.sender,
    required this.message,
    required this.time,
    required this.isMe,
  });
}
