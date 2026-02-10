abstract class SearchState {
  final List<String> history;
  SearchState(this.history);
}

class SearchHistoryLoaded extends SearchState {
  SearchHistoryLoaded(List<String> history) : super(history);
}