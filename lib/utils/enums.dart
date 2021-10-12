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

Gender? genderFromInt(int gender) {
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
        return 'Opened';
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

enum FileType {
  jpgImage,
  pngImage,
  video,
  doc,
  pdf,
  audio,
  ppt,
  sheet,
  noMedia
}

extension FileTypeString on FileType {
  int get toInt {
    switch (this) {
      case FileType.doc:
        return 1;
      case FileType.jpgImage:
        return 2;
      case FileType.video:
        return 3;
      case FileType.pdf:
        return 4;
      case FileType.pngImage:
        return 2;
      case FileType.audio:
        return 5;
      case FileType.ppt:
        return 6;
      case FileType.sheet:
        return 7;
      default:
        return 0;
    }
  }

  String get fileTypeString {
    switch (this) {
      case FileType.doc:
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case FileType.jpgImage:
        return 'image/jpeg';
      case FileType.video:
        return 'video/mp4';
      case FileType.pdf:
        return 'application/pdf';
      case FileType.pngImage:
        return 'image/png';
      case FileType.audio:
        return 'audio/mpeg';
      case FileType.ppt:
        return 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
      case FileType.sheet:
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      default:
        return '';
    }
  }

  String get assetName {
    switch (this) {
      case FileType.doc:
        return 'assets/docx.png';
      case FileType.video:
        return 'assets/mp4.png';
      case FileType.pdf:
        return 'assets/pdf.png';
      case FileType.audio:
        return 'assets/mp3.png';
      case FileType.ppt:
        return 'assets/pptx.png';
      case FileType.sheet:
        return 'assets/xlsx.png';
      default:
        return '';
    }
  }
}

FileType? fromStringToFileType(String str) {
  if (str == FileType.doc.fileTypeString) {
    return FileType.doc;
  } else if (str == FileType.jpgImage.fileTypeString) {
    return FileType.jpgImage;
  } else if (str == FileType.pdf.fileTypeString) {
    return FileType.pdf;
  } else if (str == FileType.pngImage.fileTypeString) {
    return FileType.pngImage;
  } else if (str == FileType.video.fileTypeString) {
    return FileType.video;
  } else if (str == FileType.audio.fileTypeString) {
    return FileType.audio;
  } else if (str == FileType.ppt.fileTypeString) {
    return FileType.ppt;
  } else if (str == FileType.sheet.fileTypeString) {
    return FileType.sheet;
  } else
    return null;
}

FileType fromintToFileType(int i) {
  switch (i) {
    case 1:
      return FileType.doc;
    case 2:
      return FileType.jpgImage;
    case 3:
      return FileType.video;
    case 4:
      return FileType.pdf;
    case 2:
      return FileType.pngImage;
    case 5:
      return FileType.audio;
    case 6:
      return FileType.ppt;
    case 7:
      return FileType.sheet;
    default:
      return FileType.noMedia;
  }
}
