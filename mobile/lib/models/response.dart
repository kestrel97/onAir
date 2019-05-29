class QuestionResponse {
  String sender;
  String question;
  String response;
  String image_link;
  QuestionResponse(
      {this.sender, this.question, this.response, this.image_link});

  factory QuestionResponse.fromJson(Map<String, dynamic> parsedJson) {
    return QuestionResponse(
      sender: parsedJson['sender'],
      question: parsedJson['question'],
      response: parsedJson['response'],
      image_link: parsedJson['image_link'],
    );
  }
}
