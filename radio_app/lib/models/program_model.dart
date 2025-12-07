// This program contains the title, description, image, and schedule of the program.
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

// This ProgramSchedule represents each individual schedule, indicating the day, start time, and end time.
class ProgramSchedule {
  final String day;
  final String start;
  final String end;

  const ProgramSchedule(
      {required this.day, required this.start, required this.end});
}
