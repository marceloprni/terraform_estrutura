terraform {
  backend "s3" {
    bucket         = "state-terraform-configuration"
    region         = "us-east-1"
    # Aqui, não inclui o key
    # Deixe o key de fora para passar na linha de comando
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}