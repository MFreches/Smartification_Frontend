class Project {
  final int projectId,
      projectState,
      furnitureSpecificationsId,
      validationStateProblem;
  final String name,
      problemDescription,
      problemTags,
      furnitureSpecifcationTags,
      solutionsTags,
      validationFeedbackProblem,
      furniture,
      electronicTntegrationFile;
  Project({
    required this.projectId,
    required this.projectState,
    required this.furnitureSpecificationsId,
    required this.validationStateProblem,
    required this.problemDescription,
    required this.problemTags,
    required this.name,
    required this.furnitureSpecifcationTags,
    required this.solutionsTags,
    required this.validationFeedbackProblem,
    required this.furniture,
    required this.electronicTntegrationFile,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      projectId: json['projectId'] as int,
      projectState: json['projectState'] as int,
      furnitureSpecificationsId: json['furnitureSpecificationsId'] as int,
      validationStateProblem: json['validationStateProblem'] as int,
      problemDescription: json['problemDescription'] as String,
      problemTags: json['problemTags'] as String,
      name: json['username'] as String,
      furnitureSpecifcationTags: json['furnitureSpecifcationTags'] as String,
      solutionsTags: json['solutionsTags'] as String,
      validationFeedbackProblem: json['validationFeedbackProblem'] as String,
      furniture: json['furniture'] as String,
      electronicTntegrationFile: json['electronicTntegrationFile'] as String,
    );
  }
  Map<String, dynamic> toJson() => {
        "projectId": projectId,
        "projectState": projectState,
        "furnitureSpecificationsId": furnitureSpecificationsId,
        "validationStateProblem": validationStateProblem,
        "problemDescription": problemDescription,
        "problemTags": problemTags,
        "name": name,
        "furnitureSpecifcationTags": furnitureSpecifcationTags,
        "solutionsTags": solutionsTags,
        "validationFeedbackProblem": validationFeedbackProblem,
        "furniture": furniture,
        "electronicTntegrationFile": electronicTntegrationFile,
      };
}
