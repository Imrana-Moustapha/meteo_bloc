abstract class SearchState {
  final List<String> history;
  SearchState(this.history);
}

class SearchHistoryLoaded extends SearchState {
  SearchHistoryLoaded(super.history);
}