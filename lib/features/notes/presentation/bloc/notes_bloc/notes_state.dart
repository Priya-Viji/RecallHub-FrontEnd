import 'package:equatable/equatable.dart';

class NotesState extends Equatable {
  final List<String> allNotes;
  final List<String> filteredNotes;

  const NotesState({
    this.allNotes = const ["Note A", "Note B", "Note C"],
    this.filteredNotes = const ["Note A", "Note B", "Note C"],
  });

  NotesState copyWith({List<String>? allNotes, List<String>? filteredNotes}) {
    return NotesState(
      allNotes: allNotes ?? this.allNotes,
      filteredNotes: filteredNotes ?? this.filteredNotes,
    );
  }

  @override
  List<Object?> get props => [allNotes, filteredNotes];
}
