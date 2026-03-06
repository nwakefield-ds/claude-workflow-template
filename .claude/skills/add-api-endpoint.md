# Add API Endpoint Skill

**Agent-callable skill for adding new API endpoints consistently.**

---

## Inputs

- **router/module**: Which file owns this endpoint
- **endpoint**: API path (e.g., `/api/users/{id}`)
- **method**: HTTP method (GET | POST | PUT | DELETE | PATCH)
- **description**: What the endpoint does (1-2 sentences)

---

## Steps

### 1. Find the Right File

Read `docs/context.md` Key Files section to find the correct router/controller.
If no clear owner, create a new file following existing conventions.

### 2. Read the File

```bash
cat [router_file]
```

Understand:
- Existing endpoint patterns
- Request/response model conventions
- Error handling style
- Logging patterns

### 3. Define Models

Create typed request/response models at the top of the file (adapt to your stack):

```python
# Python / FastAPI
class CreateUserRequest(BaseModel):
    name: str
    email: str

class UserResponse(BaseModel):
    id: int
    name: str
    email: str
    created_at: datetime
```

```typescript
// TypeScript
interface CreateUserRequest {
  name: string;
  email: string;
}

interface UserResponse {
  id: number;
  name: string;
  email: string;
  createdAt: string;
}
```

### 4. Add Endpoint

Follow the existing error handling pattern in the file. Ensure:
- Input validation at the boundary
- Specific exception handling (not bare `except`)
- Logging on success and failure
- Consistent response format

### 5. Update docs/context.md

Increment endpoint count:
```diff
- - 42 API endpoints total
+ - 43 API endpoints total
```

### 6. Add Tests

Create test covering:
- Happy path (201/200 response)
- Validation error (400 response)
- Not found (404 response)
- Server error path

### 7. Run Verification

```bash
./scripts/verify-memory-and-checks.sh
```

---

## Success Criteria

- [ ] Endpoint added to correct file
- [ ] Request/response types defined
- [ ] Error handling consistent with file patterns
- [ ] docs/context.md endpoint count updated
- [ ] Test added and passing
- [ ] Verification script passes
