class OwnerAuthModel {
  final String? accessToken;
  final String? tokenType;
  final String? message;
  final Map<String, dynamic>? ownerUser;

  OwnerAuthModel({
    this.accessToken,
    this.tokenType = 'Bearer',
    this.message,
    this.ownerUser,
  });

  factory OwnerAuthModel.fromJson(Map<String, dynamic> json) {
    return OwnerAuthModel(
      accessToken: json['access_token'] as String?,
      tokenType: json['token_type'] as String? ?? 'Bearer',
      message: json['message'] as String?,
      ownerUser: json['user'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'token_type': tokenType,
      'message': message,
      'user': ownerUser,
    };
  }
}
