import 'package:get_it/get_it.dart';
import 'package:freeqrgen/core/platform/file_picker_service.dart';
import 'package:freeqrgen/core/platform/file_saver_service.dart';
import 'package:freeqrgen/core/platform/implementations/file_picker_service_impl.dart';
import 'package:freeqrgen/core/platform/implementations/file_saver_service_impl.dart';
import 'package:freeqrgen/core/services/qr_export_service.dart';
import 'package:freeqrgen/core/services/platform_file_saver.dart';
import 'package:freeqrgen/core/theme/bloc/theme_bloc.dart';
import 'package:freeqrgen/features/qr_generator/data/datasources/qr_generator_datasource.dart';
import 'package:freeqrgen/features/qr_generator/data/repositories/qr_repository_impl.dart';
import 'package:freeqrgen/features/qr_generator/domain/repositories/qr_repository.dart';
import 'package:freeqrgen/features/qr_generator/domain/usecases/generate_qr_code.dart';
import 'package:freeqrgen/features/qr_generator/domain/usecases/validate_content.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_bloc.dart';

final sl = GetIt.instance;

/// Initialize dependency injection
Future<void> initializeDependencies() async {
  // Core Services
  sl.registerLazySingleton<FilePickerService>(() => FilePickerServiceImpl());

  sl.registerLazySingleton<FileSaverService>(() => FileSaverServiceImpl());

  sl.registerLazySingleton<QRExportService>(() => QRExportService());

  sl.registerLazySingleton<PlatformFileSaver>(() => PlatformFileSaver());

  // Core BLoCs
  sl.registerLazySingleton<ThemeBloc>(() => ThemeBloc());

  // QR Generator Feature
  // Data sources
  sl.registerLazySingleton<QRGeneratorDataSource>(
    () => QRGeneratorDataSource(),
  );

  // Repositories
  sl.registerLazySingleton<QRRepository>(() => QRRepositoryImpl(sl()));

  // Use cases
  sl.registerLazySingleton<GenerateQRCode>(() => GenerateQRCode(sl()));

  sl.registerLazySingleton<ValidateContent>(() => ValidateContent(sl()));

  // BLoC
  sl.registerFactory<QRGeneratorBloc>(
    () => QRGeneratorBloc(
      generateQRCode: sl(),
      validateContent: sl(),
      filePickerService: sl(),
      exportService: sl(),
      fileSaver: sl(),
    ),
  );
}
