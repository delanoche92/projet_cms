# dans terraform/variables.tf

variable "resource_group_name" {
  description = "Le nom du groupe de ressources pour l'usine logicielle."
  type        = string
  default     = "UsineLogicielle-RG"
}

variable "location" {
  description = "La région Azure où créer les ressources."
  type        = string
  default     = "France Central"
}
