import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../news/domain/usecases/usecase.dart';
import '../../domain/usecases/get_user_profile.dart';
import '../../domain/usecases/update_user_profile.dart';
import 'profile_event.dart';
import 'profile_state.dart';

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfile getUserProfile;
  final UpdateUserProfile updateUserProfileUseCase;

  ProfileBloc({
    required this.getUserProfile,
    required this.updateUserProfileUseCase,
  }) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
  }

  Future<void> _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    final result = await getUserProfile(NoParams());
    result.fold(
      (failure) => emit(const ProfileError('Failed to load profile')),
      (profile) => emit(ProfileLoaded(profile)),
    );
  }

  Future<void> _onUpdateProfile(UpdateProfile event, Emitter<ProfileState> emit) async {
    if (state is ProfileLoaded) {
      final currentProfile = (state as ProfileLoaded).profile;
      
      // Optimistic update
      emit(ProfileLoaded(event.profile));
      
      final result = await updateUserProfileUseCase(event.profile);
      result.fold(
        (failure) {
          emit(const ProfileError('Failed to update profile'));
          emit(ProfileLoaded(currentProfile)); // Revert on error
        },
        (_) {},
      );
    }
  }
}
