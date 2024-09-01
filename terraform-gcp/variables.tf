variable "project" {
  description = "ID do Projeto no GCP"
  type        = string
}

variable "region" {
  description = "Região padrão para os recursos"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Zona padrão para os recursos"
  type        = string
  default     = "us-central1-c"
}
