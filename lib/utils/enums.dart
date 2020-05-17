enum Gender { male, female, others }

extension GenderExtension on Gender {
  int get toInt {
    switch (this) {
      case Gender.male:
        return 1;
      case Gender.female:
        return 2;
      case Gender.others:
        return 3;
      default:
        return 0;
    }
  }

  String get toGenderString {
    switch (this) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
      case Gender.others:
        return 'Others';
      default:
        return 'Unknown';
    }
  }
}

Gender genderFromInt(int gender) {
  switch (gender) {
    case 1:
      return Gender.male;
    case 2:
      return Gender.female;
    case 3:
      return Gender.others;
    default:
      return null;
  }
}

enum TaskStatus { created, running, submitted, completed }

extension TaskStatusExtension on TaskStatus {
  int get toInt {
    switch (this) {
      case TaskStatus.created:
        return 1;
      case TaskStatus.running:
        return 2;
      case TaskStatus.submitted:
        return 3;
      case TaskStatus.completed:
        return 4;
      default:
        return 0;
    }
  }

  String get toTaskString {
    switch (this) {
      case TaskStatus.created:
        return 'Created';
      case TaskStatus.running:
        return 'Running';
      case TaskStatus.submitted:
        return 'Submitted';
      case TaskStatus.completed:
        return 'Completed';
      default:
        return 'Created';
    }
  }
}

TaskStatus taskStatusFromInt(int status) {
  switch (status) {
    case 1:
      return TaskStatus.created;
    case 2:
      return TaskStatus.running;
    case 3:
      return TaskStatus.submitted;
    case 4:
      return TaskStatus.completed;
    default:
      return TaskStatus.created;
  }
}
