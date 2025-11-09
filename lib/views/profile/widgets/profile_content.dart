import 'package:flutter/material.dart';
import 'package:pami/domain/core/entities/user.dart';
import 'package:pami/views/core/theme/text_styles.dart';
import 'package:pami/views/core/widgets/user_avatar.dart';
import 'package:pami/views/profile/widgets/transaction_history.dart';

/// Displays the fetched user profile contents
class ProfileContent extends StatelessWidget {
  /// Default constructor
  const ProfileContent({
    required this.user,
    super.key,
  });

  /// The user profile to display
  final User user;

  @override
  Widget build(BuildContext context) {
    final positive = user.karma.getOrCrash().toInt();
    final negative = 100 - positive;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 8,
            left: 8,
            right: 8,
          ),
          child: Column(
            children: [
              Center(
                child: SizedBox(
                  height: 140,
                  width: 160,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      UserAvatar(user: user, size: 100),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Text(
                          '$positive%',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.green,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Text(
                          '$negative%',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      user.name.getOrCrash(),
                      style: AppTextStyles.headlineMedium,
                    ),
                    if (user.isVerified) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.verified, color: Colors.blue, size: 18),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  '@${user.username.getOrCrash()}',
                  style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  user.bio.getOrCrash(),
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyLarge,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: TransactionHistory(userId: user.id),
        ),
      ],
    );
  }
}
