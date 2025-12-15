import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../injection_container.dart' as di;
import '../../../auth/domain/usecases/get_profile_usecase.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../auth/data/models/profile_response_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = true;
  ProfileDataModel? _profileData;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // First, get the User_ID from saved login response
      final repository = di.sl<AuthRepository>();
      final loginResponseResult = await repository.getLoginResponse();

      loginResponseResult.fold(
        (failure) {
          setState(() {
            _errorMessage = 'Failed to get user ID: ${failure.message}';
            _isLoading = false;
          });
        },
        (loginResponse) async {
          int? userId;

          if (loginResponse != null && loginResponse.userDescription.userId != 0) {
            userId = loginResponse.userDescription.userId;
          } else {
            // Fallback to cached user description
            final userDescResult = await repository.getUserDescription();
            userDescResult.fold((_) {}, (userDesc) {
              if (userDesc != null && userDesc.userId != 0) {
                userId = userDesc.userId;
              }
            });
          }

          if (userId == null || userId == 0) {
            setState(() {
              _errorMessage = 'User ID not found. Please login again.';
              _isLoading = false;
            });
            return;
          }

          // Now fetch profile using the User_ID
          final getProfileUseCase = di.sl<GetProfileUseCase>();
          final result = await getProfileUseCase(userId!);

          result.fold(
            (failure) {
              setState(() {
                _errorMessage = failure.message;
                _isLoading = false;
              });
            },
            (profileResponse) {
              if (profileResponse.isSuccess && profileResponse.firstProfile != null) {
                setState(() {
                  _profileData = profileResponse.firstProfile;
                  _isLoading = false;
                });
              } else {
                setState(() {
                  _errorMessage = profileResponse.message;
                  _isLoading = false;
                });
              }
            },
          );
        },
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(onPressed: _loadProfile, child: const Text('Retry')),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.paddingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Profile', style: AppTextStyles.h1.copyWith(color: AppColors.primary, fontSize: 28)),
                  const SizedBox(height: 8),
                  Text('Update your profile and change advance settings', style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey)),
                  const SizedBox(height: 32),
                  _buildInfoField('Name', _profileData?.userName ?? '-'),
                  const SizedBox(height: 24),
                  _buildInfoField('Branches', _profileData?.branchNames ?? '-'),
                  const SizedBox(height: 24),
                  _buildInfoField('Phone', _profileData?.userPhone ?? '-'),
                  const SizedBox(height: 24),
                  _buildInfoField('Email', _profileData?.userEmail ?? '-'),
                  const SizedBox(height: 24),
                  _buildInfoField('Accounts Expiry Date', _profileData?.accountExpiryDate ?? '-'),
                  const SizedBox(height: 24),
                  _buildInfoField('Designation', _profileData?.designationDescription ?? '-'),
                  const SizedBox(height: 24),
                  _buildInfoField('Rights Group', _profileData?.groupName ?? '-'),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _loadProfile, // Refresh profile data
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        'Update',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Text(value.isEmpty ? '' : value, style: AppTextStyles.h3.copyWith(color: AppColors.primary)),
      ],
    );
  }
}
