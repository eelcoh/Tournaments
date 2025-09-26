# GEMINI.md

## Project Overview

This is a betting application for major football tournaments like the World Cup and European Championships. It's a hobbyist project built with the Elm programming language and utilizes the `elm-ui` library for its user interface. The application allows users to place bets on tournament outcomes, including match results, top scorers, and bracket predictions.

The project is structured to be easily extendable for future tournaments. Adding a new tournament involves creating a new module that defines the tournament structure (bracket, teams, and matches) and updating the main application to use it.

## Building and Running

The project uses a `Makefile` and a `make.sh` script to automate the build process.

### Key Commands:

*   **Build the application:**
    ```bash
    make build
    ```
    This command compiles the Elm code, optimizes it for production, and copies the necessary HTML file to the `build` directory.

*   **Build for debugging:**
    ```bash
    make debug
    ```
    This command compiles the Elm code without optimizations, making it easier to debug.

*   **Clean the project:**
    ```bash
    make clean
    ```
    This command removes the `build` directory and the `elm-stuff` directory, which contains cached build artifacts.

*   **Run the application:**
    After building the application, you can run it by serving the `build` directory with a simple HTTP server. For example:
    ```bash
    python -m http.server --directory build
    ```
    Then, open your web browser and navigate to `http://localhost:8000`.

## Development Conventions

### Adding a New Tournament

To add a new tournament, you need to:

1.  Create a new module under `src/Bets/Init/`. For example, `src/Bets/Init/MyNewTournament/Tournament.elm`.
2.  This new module must expose three functions:
    *   `bracket`: with the type `List Bets.Types.Bracket`
    *   `initTeamData`: with the type `Bets.Types.TeamData`
    *   `matches`: with the type `List Bets.Types.Match`
3.  Import the new tournament module in `src/Bets/Init.elm`. Note that only one tournament can be active at a time.

### Coding Style

The codebase follows standard Elm formatting and conventions. The use of `elm-ui` suggests a declarative approach to building the user interface. The code is organized into modules with clear responsibilities, such as `API`, `Bets`, `Form`, `Results`, and `UI`.
