# Створення ECR репозиторію
resource "aws_ecr_repository" "ecr_repo" {
  # Назва репозиторію, яку передаємо через змінну repository_name
  name = var.repository_name   

  # Налаштування можливості оновлення тегів для образів:
  # - MUTABLE: дозволяє оновлювати теги (наприклад, "latest").
  # - IMMUTABLE: не дозволяє оновлювати теги (захищає від випадкових перезаписів).
  image_tag_mutability = "MUTABLE"  

  # Встановлює можливість видаляти репозиторій разом із усіма образами:
  # - true: дозволяє примусове видалення репозиторію.
  # - false: вимагає попереднього очищення репозиторію перед видаленням.
  force_delete = true                 

  # Додаємо теги для ресурсу, щоб краще ідентифікувати репозиторій в AWS:
  # Теги допомагають в управлінні ресурсами у великих інфраструктурах.
  tags = {
    Name        = var.repository_name  # Тег з назвою репозиторію
    Environment = var.environment      # Тег для середовища (dev, staging, production)
  }
}

# Політика життєвого циклу для автоматичного видалення старих образів
resource "aws_ecr_lifecycle_policy" "ecr_policy" {
  # Прив'язуємо політику до створеного репозиторію ECR
  repository = aws_ecr_repository.ecr_repo.name  

  # Опис політики у форматі JSON
  policy = jsonencode({
    rules = [
      {
        rulePriority = 1  # Пріоритет правила, якщо є кілька політик
        description  = "Delete untagged images after 7 days"  # Опис правила
        
        # Умова відбору образів для видалення:
        # - tagStatus: untagged — застосовується до образів без тегів.
        # - countType: sinceImagePushed — відрахунок часу з моменту завантаження образу.
        # - countUnit: days — одиниця виміру часу (дні).
        # - countNumber: 7 — кількість днів, після яких образ видаляється.
        selection = {
          tagStatus   = "untagged"      
          countType   = "sinceImagePushed"  
          countUnit   = "days"          
          countNumber = 7               
        }
        
        # Дія, яку треба виконати:
        # - expire: видаляє образи, що відповідають критеріям.
        action = {
          type = "expire"
        }
      }
    ]
  })
}
