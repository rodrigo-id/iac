#Definicion de variables
variable access_key {
  description = "Access_key para acceder a AWS"
}

variable secret_key {
  description = "Secret_key del usuario de conexion a AWS"
}

variable region {
  default     = "us-east-1"
  description = "Nombre de la Region en AWS"
}

variable master_ami {
  default     = "ami-946eb4eb"
  description = "Nombre de la AMI (imagen) del Master a deployar."
}

variable node_ami {
  default     = "ami-4563b93a"
  description = "Nombre de la AMI (imagen) de los Nodos a deployar."
}

variable master_type {
  description = "Nombre del tipo de maquina master."
}

variable node_type {
  description = "Nombre del tipo de maquina node."
}

variable cantnode {
  default     = 2
  description = "Cantidad de nodos a crear."
}
