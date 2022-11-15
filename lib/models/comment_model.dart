import 'package:ecom_users/models/user_model.dart';

const String collectionComment = 'Comments';

const String commentFieldCommentId = 'commentId';
const String commentFieldUserModel = 'userModel';
const String commentFieldProductId = 'productId';
const String commentFieldComment = 'comment';
const String commentFieldApproved = 'approved';

class CommentModel {
  String commentId;
  UserModel userModel;
  String productId;
  String comment;
  bool approved;

  CommentModel({
    required this.commentId,
    required this.userModel,
    required this.productId,
    required this.comment,
    this.approved = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      commentFieldCommentId: commentId,
      commentFieldUserModel: userModel.toMap(),
      commentFieldProductId: productId,
      commentFieldComment: comment,
      commentFieldApproved: approved,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) => CommentModel(
        commentId: map[commentFieldCommentId],
        userModel: UserModel.fromMap(map[commentFieldUserModel]),
        productId: map[commentFieldProductId],
        comment: map[commentFieldComment],
        approved: map[commentFieldApproved],
      );
}
