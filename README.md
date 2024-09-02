### Hexlet tests and linter status:
[![Actions Status](https://github.com/AlexRedisson18/rails-project-66/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/AlexRedisson18/rails-project-66/actions)
[![CI](https://github.com/AlexRedisson18/rails-project-66/actions/workflows/main.yml/badge.svg)](https://github.com/AlexRedisson18/rails-project-66/actions/workflows/main.yml)

[Repository Quality Analyzer](https://rails-project-66-gsqa.onrender.com) a project that helps to automatically monitor the quality of repositories on Github. It tracks the changes and runs them through the built-in analyzers. Then it generates reports and sends them to the user.


### Installation

You can install project and prepare DB by one command.


```bash
make setup
```

or you can do it separately


```bash
make install # install dependecies

make db-prepare # reset DB, run migrations, run seed file

make copy-env # copy ENV variables
```
