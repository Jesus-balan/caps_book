part of 'myride_bloc.dart';

@immutable
abstract class MyrideEvent {}

class FetchBookingEvent extends MyrideEvent{}

class SelectCategory extends MyrideEvent {
  final String category;
  SelectCategory(this.category);
}
