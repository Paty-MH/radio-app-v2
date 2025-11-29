class Program {
  final String title;
  final String description;
  final String imageAsset;
  final List<ProgramSchedule> schedules;

  const Program({
    required this.title,
    required this.description,
    required this.imageAsset,
    required this.schedules,
  });
}

class ProgramSchedule {
  final String day;
  final String start;
  final String end;

  const ProgramSchedule(
      {required this.day, required this.start, required this.end});
}
