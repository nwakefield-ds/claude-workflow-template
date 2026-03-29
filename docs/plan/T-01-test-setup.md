# T-01: Configure project test command

## Why

CLAUDE.md contains a placeholder test command (`python3 -m pytest tests/ -v`) that may not match the actual project. The verify script and CI depend on running the correct test command. Until this is set, automated checks may fail or silently pass on the wrong runner.

## Scope

### Covers
- Identifying the correct test command for this project
- Updating CLAUDE.md with the real command
- Verifying the command runs successfully

### Does not cover
- Writing new tests
- Setting up CI/CD pipelines

## Deliverables

- [ ] Replace placeholder test command in CLAUDE.md with real command
- [ ] Verify test command runs successfully

## Success criteria

- `./scripts/verify-memory-and-checks.sh` runs without errors related to the test command
- The test command in CLAUDE.md actually executes tests in this project

## Validation

- Run the test command manually and confirm it finds and executes tests
- Run `./scripts/verify-memory-and-checks.sh` end-to-end

## Dependencies

- Depends on the project having tests written
- No external dependencies

## Files / surfaces

- `CLAUDE.md`
- `scripts/verify-memory-and-checks.sh`
