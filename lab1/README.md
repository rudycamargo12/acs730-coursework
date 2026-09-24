# Lab 1

Instructions for this section will be provided in class and on Blackboard when we reach it.

Put your work for Lab 1 in this folder.

# Lab 1 - AWS CLI Automation

## Scripts Overview
- **create-security-group.sh**: Crea un Security Group dinámico permitiendo tráfico SSH exclusivamente desde la IP actual del usuario (`/32`).
- **create-instance.sh**: Obtiene la última AMI de Amazon Linux 2023 y despliega una instancia `t3.micro` con el perfil `LabInstanceProfile`.
- **delete-instance.sh**: Busca y termina de forma segura las instancias etiquetadas como `acs730-week1`.
- **delete-security-group.sh**: Elimina el Security Group de prueba creado en el script de aprovisionamiento.
