# Add API Endpoint Skill

## Steps

### 1. Find the Right File
- Read the router/controller file to understand existing patterns.

### 2. Add Endpoint
Follow existing patterns for:
- Request/response models
- Error handling
- Input validation

### 3. Add Tests
Cover: happy path, validation errors, not-found, error handling.

### 4. Update Docs
- Mark task done in `docs/todos.md` if applicable

### 5. Verify
```bash
./scripts/verify-memory-and-checks.sh
```
