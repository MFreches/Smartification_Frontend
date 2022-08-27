class ProjectConstants {
  static int userId = 22;
  static int projectId = 11;
  static int furniture_id = 1;
  static int ideaId = -1;
  String projectTags = '';
  static String userName = '';
  static int projectIdSelected = 12;
  static String projectNameSelected = '';
  static String furnitureDimensions = '';
  static String projectName = '';
  static String furniture = '';
  static String furnitureCategory = '';
  static String tags = '';
  static bool control = false;
  static List<String> listTags = []; //todas as tags na bd
  static List<String> listTags2 = []; //tags geradas na segunda pergunta
  static List<String> listTags3 = []; //tags geradas na terceira pergunta
  static List<String> tagsToShow = []; //tags a mostrar na interface
  static List<String> tagsToAdd = []; //tags para adicionar a bd
  static List<String> tagsToIncrement = []; //tags para incrementar na bd
  static Map<String, int> mapTags = {}; //mapa das tags, contem a tag-tag_id
  static List<String> funcsToAdd = [];
  static String furnitureContext = ''; //1 question
  static String smartificationNeed = ''; //2 question
  static String smartificationPieceContext = ''; //3 question
  static String idea_spec =
      '{"version": 1,"date_time": {"minute": null,"hour": null,"day": null,"month": null,"year": null},"specifications": {"context": {"customer_solution_description": null,"problem_description": "","solution_description": ""},"furniture_specifications": {"description": "","3d_model_file": ""},"requirements":[{"user_type" : "","need" : "","goal" : ""}],"feedack":{"customer_state_idea": null,"customer_feeback_idea": "","invalid_feedback_idea": ""},"other": ""}}';
}
