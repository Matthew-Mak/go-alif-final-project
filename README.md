# Workout Tracker (Трекер тренировок)

![Go Version](https://img.shields.io/badge/Go-1.24.2-blue.svg)
![Test Coverage](https://img.shields.io/badge/coverage-70%25-green.svg)
![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg)

REST API сервис на Go для ведения дневника тренировок. Позволяет пользователям планировать, записывать и отслеживать тренировки, управлять упражнениями и получать агрегированные отчёты.

## Особенности

- 🔐 JWT-аутентификация с refresh токенами
- 👤 Управление пользователями с ролевой системой
- 💪 Создание и управление тренировками
- 🏋️ Управление упражнениями (для администраторов)
- 📸 Загрузка фотографий тренировок
- 🐘 PostgreSQL в качестве базы данных
- 🏗️ Dependency Injection с помощью dig
- 📊 Структурированное логирование с zap
- ✅ Покрытие тестами

## Технологический стек

- **Backend:** Go 1.24+
- **Web Framework:** Gin
- **База данных:** PostgreSQL
- **Аутентификация:** JWT
- **ORM/Query Builder:** pgx/v5
- **Dependency Injection:** go.uber.org/dig
- **Логирование:** go.uber.org/zap
- **Тестирование:** testify

## Качество кода

- ✅ **Test Coverage**: 70% (1035/1481 строк)
- ✅ **golangci-lint**: все проверки пройдены
- ✅ **GitHub Actions**: автоматические сборка и тестирование
- ✅ **Архитектура**: Clean Architecture с разделением на слои

## Быстрый старт

### Требования
- Go 1.24.2+
- PostgreSQL 12+
- Make (опционально)

### Установка

1. **Клонируйте репозиторий**
```bash
git clone https://github.com/Matthew-Mak/go-alif-final-project
cd workout-tracker
```

2. **Настройте окружение**
```bash
cp .env.example .env
# Отредактируйте .env файл с вашими настройками
```

3. **Установите зависимости**
```bash
go mod download
```

4. **Запустите базу данных**
```bash
docker-compose up -d postgres
```

5. **Запустите приложение**
```bash
go run cmd/main.go
```

Сервер будет доступен по адресу: `http://localhost:8080` (Или как вы указали в докер контейнере)

## Архитектура

Проект следует принципам Clean Architecture с разделением на слои:

```text
workout-tracker/
├── cmd/                    # Точки входа приложения
├── internal/               # Внутренняя логика приложения
│   ├── app/               # Конфигурация и инициализация
│   ├── dto/               # Data Transfer Objects
│   ├── handler/           # HTTP handlers
│   │   ├── admin/         # Админские handlers
│   │   ├── auth/          # Аутентификация handlers
│   │   └── workout/       # Workout handlers
│   ├── model/             # Модели данных
│   ├── repository/        # Слой доступа к данным
│   └── service/           # Бизнес-логика
├── pkg/                   # Общие пакеты
│   ├── db/               # Подключение к БД
│   └── logger/           # Конфигурация логирования
├── go.mod
├── go.sum
└── README.md
```

## API Endpoints

### Аутентификация
- `POST /auth/register` - Регистрация пользователя
```json
{
  "username" : "<your-username>",
  "password" : "<your-password>"
}
```
- `POST /auth/login` - Вход в систему
```json
{
  "username" : "<your-username>",
  "password" : "<your-password>"
}
```
- `POST /auth/refresh` - Обновление access токена
```json
{
  "refresh_token" : "<your-refresh-token>"
}
```

### Тренировки (требуется аутентификация)
- `GET /workouts` - Получить все тренировки пользователя
- `GET /workouts/:id` - Получить конкретную тренировку
- `POST /workouts` - Создать новую тренировку
```json
    {
  "name": "My first Workout",
  "title": "Push Day",
  "category": "Upper Body",
  "exercises": [
    {
      "exercise_id": 1,
      "reps": 10,
      "sets": 3
    },
    {
      "exercise_id": 2,
      "reps": 8,
      "sets": 4
    }
  ]
}
```
- `PUT /workouts/:id` - Обновить тренировку
```json
    {
  "name": "My first Workout",
  "title": "Push Day",
  "category": "Upper Body",
  "exercises": [
    {
      "exercise_id": 1,
      "reps": 10,
      "sets": 3
    },
    {
      "exercise_id": 2,
      "reps": 8,
      "sets": 4
    }
  ]
}
```
- `DELETE /workouts/:id` - Удалить тренировку
- `POST /workouts/:id/photo` - Загрузить фото тренировки
- `GET /workouts/:id/photo` - Получить фото тренировки

### Упражнения
- `GET /exercises` - Получить все упражнения (требуется аутентификация)

### Администрирование (требуется роль админа)
- `GET /admin/exercises` - Получить все упражнения
- `POST /admin/exercises` - Создать упражнение
```json
{
  "name" : "<exercise-name>",
  "description" : "<exercise-description>"
}
```
- `PUT /admin/exercises/:id` - Обновить упражнение
```json
{
  "name" : "<exercise-name>",
  "description" : "<exercise-description>"
}
```
- `DELETE /admin/exercises/:id` - Удалить упражнение


## Быстрый старт
### Тестирование API
Вы можете сразу протестировать API, используя развернутую версию:

- Регистрация нового пользователя:
```bash
curl -X POST https://go-alif-final-project5-production.up.railway.app/auth/register \
-H "Content-Type: application/json" \
-d '{"username": "testuser", "password": "password123"}'
```

- Вход в систему:
```bash
curl -X POST https://go-alif-final-project5-production.up.railway.app/auth/login \
-H "Content-Type: application/json" \
-d '{"username": "testuser", "password": "password123"}'
```

- Создание упражнений (нужны права администратора):
```bash
curl -X POST https://go-alif-final-project5-production.up.railway.app/admin/exercises \
-H "Authorization: Bearer YOUR_ACCESS_TOKEN"
-d '{"name": "присидания", "description": "для ног"}'
```

- Просмотр всех упражнений
```bash
curl -X GET https://go-alif-final-project5-production.up.railway.app/exercises \
-H "Authorization: Bearer YOUR_ACCESS_TOKEN" 
```

- Создание тренировки из выбранных упражнений
```bash
curl -X POST https://go-alif-final-project5-production.up.railway.app/workouts \
-H "Authorization: Bearer YOUR_ACCESS_TOKEN"
-d '{
"name" : "день ног",
"title": "тренировка для ног",
"category": "Lower Body",
"exercises": [
    {
      "exercise_id": 1,
      "reps": 10,
      "sets": 3
    },
    {
      "exercise_id": 2,
      "reps": 8,
      "sets": 4
    }
  ]
}'
```

- Просмотр тренировок после создания
```bash
curl -X GET https://go-alif-final-project5-production.up.railway.app/workouts \
-H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

## Деплой
### Приложение автоматически развертывается на Railway при пуше в основную ветку.

- Railway конфигурация

```text
URL: https://go-alif-final-project5-production.up.railway.app
База данных: PostgreSQL (управляется Railway)
Переменные окружения настроены через Railway Dashboard
```


## Благодарности

- Менторам Alif Academy за отличное обучение языку программирования.
- Всем студентам академии.