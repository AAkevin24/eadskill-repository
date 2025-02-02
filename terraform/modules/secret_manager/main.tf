resource "aws_secretsmanager_secret" "db_credentials" {
    name = "db_credentialsv24"
}

resource "aws_secretsmanager_secret_version" "db_credentials_value" {
  secret_id     = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = "eadskill"
    password = "eadskill"
  })
}

