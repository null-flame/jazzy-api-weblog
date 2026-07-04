# Jazzy Blog SQLite

A simple blog API built with Nim, Jazzy, and SQLite.

## Features

- User registration
- User login with email and password
- Create posts
- View a post
- Like a post
- Delete a post
- Pagination for listing posts
- SQLite database support

## Project Structure

```text
.
├── app.nim
├── config.nim
├── handlers/
│   ├── actions.nim
│   ├── auth.nim
│   └── posts.nim
├── models/
│   ├── interactions.nim
│   ├── post.nim
│   └── user.nim
├── views/
├── README.md
└── LICENSE
```

## Requirements

- Nim compiler
- Nimble
- SQLite

## Installation

1. Install Nim and Nimble if not already installed.
2. Install required dependencies:

```bash
nimble install jazzy
nimble install norm
```

3. Clone the repository and move into the project folder:

```bash
cd jazzy_weblog_sqlite
```

## Running the Project

Run the application with:

```bash
nim c -r app.nim
```

The server will start on port 8080.

## API Endpoints

### Public Routes

- POST /api/reg — Register a new user
- POST /api/loginEmail — Login with email and password
- POST /api/view — View a specific post
- GET /api/get_post — Get paginated list of posts

### Protected Routes

- POST /api/create_post — Create a new post
- POST /api/like — Like a post
- DELETE /api/delete — Delete a post

## Database

The project uses SQLite and stores the database in the file `test.db`.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contribution

Contributions are welcome. Please open an issue or submit a pull request if you want to improve the project.
