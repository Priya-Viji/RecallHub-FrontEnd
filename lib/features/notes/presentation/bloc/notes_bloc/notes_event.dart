abstract class NotesEvent {}

class SearchNotes extends NotesEvent {
  final String query;
  SearchNotes(this.query);
}
