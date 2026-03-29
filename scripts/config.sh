#!/usr/bin/env bash
# Project configuration — edit this file to match your project

# Project size controls how much process overhead is enforced.
#
#   small  — solo or short-lived project
#            TODO linting and structured tracking are disabled.
#            docs/todos.md can be a simple free-form checklist.
#
#   normal — team or long-lived project (default)
#            Full TODO system enforced: T-XX format, lint on commit,
#            spec files in docs/plan/, verify script checks format.
#
PROJECT_SIZE="${PROJECT_SIZE:-normal}"
