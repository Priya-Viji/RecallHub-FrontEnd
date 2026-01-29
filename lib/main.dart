import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recallhub_frontend/features/auth/data/auth_repository_impl.dart';
import 'package:recallhub_frontend/features/auth/domain/repositories/auth_repository.dart';
import 'package:recallhub_frontend/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:recallhub_frontend/features/auth/presentation/pages/auth_gate.dart';
import 'package:recallhub_frontend/features/notes/domain/folder_model.dart';
import 'package:recallhub_frontend/features/notes/domain/note_model.dart';
import 'package:recallhub_frontend/features/notes/presentation/bloc/notes_bloc/notes_bloc.dart';
import 'package:recallhub_frontend/features/notes/presentation/bloc/theme_bloc/theme_bloc.dart';
import 'package:recallhub_frontend/firebase_options.dart';
import 'package:hive_flutter/hive_flutter.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(FolderModelAdapter());
  Hive.registerAdapter(NoteModelAdapter());
  await Hive.openBox<FolderModel>('folders');
  await Hive.openBox<NoteModel>('notes');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AuthRepository>(
      create: (_) => AuthRepositoryImpl(), // provide once
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ThemeBloc()),
          BlocProvider(create: (_) => NotesBloc()),
          BlocProvider(
            create: (context) =>
                AuthBloc(context.read<AuthRepository>())
                  ..add(CheckAuthStatus()),
          ), // read repository from context
        ],
        child: BlocBuilder<ThemeBloc, ThemeMode>(
          builder: (context, themeMode) {
            return MaterialApp(
              title: 'RecallHub',
              debugShowCheckedModeBanner: false,
              themeMode: themeMode,
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              home: AuthGate(),
            );
          },
        ),
      ),
    );
  }
}
