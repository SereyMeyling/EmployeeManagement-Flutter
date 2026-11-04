class TokenModel {
  final String accessToken;
  final String? refreshToken;
  TokenModel({required this.accessToken, this.refreshToken});

  factory TokenModel.fromJson(Map<String, dynamic> j) {
    final access = (j['accessToken'] ?? j['access_token'] ?? j['token'] ?? '').toString();
    final refresh = (j['refreshToken'] ?? j['refresh_token'])?.toString();
    if (access.isEmpty) throw const FormatException('No access token in response');
    return TokenModel(accessToken: access, refreshToken: refresh);
  }
}
