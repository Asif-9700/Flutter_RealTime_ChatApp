import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nine_hour_chat_app/logic/cubit/auth/auth_cubit.dart';

import '../../firebase_options.dart';
import '../../router/app_router.dart';
import '../repositories/auth_repository.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  getIt.registerLazySingleton(() => AppRouter());
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton(() => AuthRepository());
  getIt.registerFactory(() => AuthCubit(authRepository: AuthRepository()));
  //   getIt.registerLazySingleton(() => ContactRepository());
  //   getIt.registerLazySingleton(() => ChatRepository());
  //   getIt.registerLazySingleton(
  //     () => AuthCubit(authRepository: AuthRepository()),
  //   );
}
