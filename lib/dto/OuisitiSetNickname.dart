class OuistitiSetNickname {
  const OuistitiSetNickname(this.nickname);

  final String nickname;

  Map<String, dynamic> toJson() => {'nickname': nickname};
}
