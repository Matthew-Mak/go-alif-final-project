# Workout Tracker (Трекер тренировок)

![Go Version](https://img.shields.io/badge/Go-1.24.2-blue.svg)
![Test Coverage](https://img.shields.io/badge/coverage-70%25-green.svg)
![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg)

REST API сервис на Go для ведения дневника тренировок. Позволяет пользователям планировать, записывать и отслеживать тренировки, управлять упражнениями и получать агрегированные отчёты.

## Основные возможности

### Для пользователей
- ✅ Регистрация и авторизация через JWT
- ✅ Создание тренировок с набором упражнений
- ✅ Просмотр списка своих тренировок
- ✅ Редактирование и удаление тренировок
- ✅ Категоризация тренировок (cardio, strength, mobility)
- ✅ Загрузка и просмотр фото тренировок

### Для администраторов
- ✅ Создание и управление справочником упражнений
- ✅ Просмотр всех упражнений в системе
- ✅ Полный CRUD для упражнений

### Система безопасности
- ✅ JWT авторизация с refresh токенами
- ✅ Хэширование паролей через bcrypt
- ✅ Middleware для проверки ролей (user/admin)
- ✅ Разграничение доступа по ролям

## Технологический стек

| Компонент | Технология |
|-----------|------------|
| **Язык** | Go 1.24.2 |
| **Framework** | Gin |
| **База данных** | PostgreSQL |
| **Драйвер БД** | pgx |
| **Миграции** | ✅ Автоматические при запуске |
| **Конфигурация** | .env файл |
| **Авторизация** | JWT + bcrypt |

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

## API Эндпоинты

### Авторизация
```
POST   /auth/register     # Регистрация пользователя
POST   /auth/login        # Вход в систему
POST   /auth/refresh      # Обновление токена
```

### Тренировки (требует авторизации)
```
POST   /workouts          # Создать тренировку
GET    /workouts          # Список своих тренировок
GET    /workouts/:id      # Получить тренировку по ID
PUT    /workouts/:id      # Редактировать тренировку
DELETE /workouts/:id      # Удалить тренировку
POST   /workouts/:id/photo # Загрузить фото тренировки
GET    /workouts/:id/photo # Получить фото тренировки
```

### Упражнения
```
GET    /exercises         # Справочник упражнений (для всех пользователей)
```

### Администрирование (только для админов)
```
POST   /admin/exercises   # Создать упражнение
GET    /admin/exercises   # Все упражнения
PUT    /admin/exercises/:id # Обновить упражнение
DELETE /admin/exercises/:id # Удалить упражнение
```

## Работа с файлами

Приложение поддерживает загрузку фотографий тренировок:

- **Формат загрузки**: `multipart/form-data`
- **Хранение**: `./uploads/workouts/{id}/photo.jpg`
- **Доступ**: через эндпоинт `GET /workouts/:id/photo`
- **Поддерживаемые форматы**: JPG, JPEG, PNG
- **Автоматическое удаление**: при удалении тренировки

### Пример загрузки фото
```bash
curl -X POST \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -F "photo=@workout_photo.jpg" \
  http://localhost:8080/workouts/1/photo
```

## Примеры использования

### Регистрация пользователя
```bash
curl -X POST http://localhost:8080/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "john_doe",
    "email": "john@example.com",
    "password": "securepassword"
  }'
```

### Создание тренировки
```bash
curl -X POST http://localhost:8080/workouts \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Morning Workout",
    "title": "Утренняя кардио тренировка",
    "category": "cardio",
    "exercises": [
      {
        "exercise_id": 1,
        "sets": 3,
        "reps": 15
      }
    ]
  }'
```

## 🏗 Архитектура проекта

```
# Архитектура Go Fitness приложения

```
    go-alif-final-project/
    ├── .github/                # Github workflows
    │   └── workflows/         
    │       ├── golang-lint.yml # Линтер кода
    │       └── unit-tests.yml  # Юнит-тесты
    ├── cmd/                    # Точки входа приложения
    │   └── server/
    │       └── main.go        # Главный файл запуска
    ├── internal/               # Приватный код приложения
    │   ├── app/               # Конфигурация приложения
    │   │   ├── routes.go      # Маршрутизация
    │   │   └── server.go      # HTTP сервер
    │   ├── handler/           # HTTP обработчики (Presentation Layer)
    │   │   ├── admin/         # Админские эндпоинты
    │   │   ├── auth/          # Авторизация/регистрация
    │   │   ├── workout/       # Управление тренировками
    │   │   ├── interface.go   # Интерфейсы
    │   │   └── middleware.go  # HTTP middleware
    │   ├── service/           # Бизнес-логика (Business Layer)
    │   │   ├── admin/         # Админские сервисы
    │   │   ├── auth/          # Сервисы авторизации
    │   │   └── workout/       # Сервисы тренировок
    │   ├── repository/        # Слой данных (Data Access Layer)
    │   │   ├── exercise/      # Репозиторий упражнений
    │   │   ├── user/          # Репозиторий пользователей
    │   │   └── workout/       # Репозиторий тренировок
    │   ├── dto/               # Data Transfer Objects
    │   │   ├── exercise/      # DTO упражнений
    │   │   ├── user/          # DTO пользователей
    │   │   ├── workout/       # DTO тренировок
    │   │   └── workoutexercisejoin/ # DTO связей
    │   └── errors/            # Обработка ошибок
    │       └── error.go
    ├── model/                  # Доменные модели (Domain Layer)
    │   ├── exercise/          # Модель упражнений
    │   ├── statistics/        # Модель статистики
    │   ├── user/              # Модель пользователей
    │   ├── workout/           # Модель тренировок
    │   └── workoutexercisejoin/ # Связь many-to-many
    ├── config/                 # Конфигурация
    │   ├── .env              # Переменные окружения
    │   └── config.go         # Загрузка конфигов
    ├── docs/                   # Документация
    │   └── swagger.yaml      # API спецификация
    ├── migrations/            # Миграции БД
    │   ├── 001_create_users_table.up.sql
    │   └── 001_create_users_table.down.sql
    ├── pkg/                   # Переиспользуемые пакеты
    │   ├── db/               # Подключение к БД
    │   └── logger/           # Система логирования
    ├── uploads/               # Загруженные файлы
    │   └── workouts/         # Файлы тренировок
    ├── docker-compose.yml     # Docker конфигурация
    ├── go.mod                 # Go модули
    ├── golangci.yml          # Конфигурация линтера
    └── README.md             # Документация проекта
```

## Архитектурные принципы

**Clean Architecture** с разделением на 4 слоя:
- **Presentation** (`handler/`) - HTTP обработчики
- **Business Logic** (`service/`) - бизнес-правила  
- **Data Access** (`repository/`) - работа с БД
- **Domain** (`model/`) - доменные сущности

**Основные домены**: Users, Auth, Workouts, Exercises, Statistics, Admin

**Tech Stack**: Go, PostgreSQL, Swagger, GitHub Actions
```

## 🧪 Тестирование

```bash
# Запуск всех тестов
go test ./...

# Запуск тестов с покрытием
go test -cover ./...

# Подробный отчет о покрытии
go test -coverprofile=coverage.out ./...
go tool cover -html=coverage.out
```

## 🔧 Переменные окружения

```env
# Сервер
PORT=8080
GIN_MODE=release

# База данных
DB_HOST=localhost
DB_PORT=5432
DB_USER=workout_user
DB_PASSWORD=your_password
DB_NAME=workout_tracker
DB_SSLMODE=disable

# JWT
JWT_SECRET=your-super-secret-key
JWT_EXPIRE_HOURS=24
REFRESH_TOKEN_EXPIRE_HOURS=720

# Файлы
UPLOAD_PATH=./uploads
MAX_FILE_SIZE=10485760
```

## Авторы

- **ИМЯ АВТОРА** - [mamatsalay](https://github.com/mamatsalay)
- **Маковецкий Матвей** - [Matthew-Mak](https://github.com/Matthew-Mak)


## Благодарности

- Менторам Alif Academy за отличное обучение языку программирования.
- Всем студентам академии.