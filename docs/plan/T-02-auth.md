# T-02: Add authentication

## Why

No authentication is in place, making the application unsafe for public deployment. Parked at P3 until launch prep — needs to be addressed before going live.

## Scope

### Covers
- Auth strategy selection (JWT, session-based, or OAuth)
- Auth middleware implementation
- Login and logout endpoints
- Route protection for authenticated-only endpoints
- Tests for auth flows
- Documentation updates

### Does not cover
- Authorization / role-based access control (separate task)
- Password reset / email verification flows (follow-up)
- Social login / OAuth providers (can be added later)

## Deliverables

- [ ] Choose and document auth strategy in docs/decisions.md
- [ ] Implement auth middleware
- [ ] Add login/logout endpoints
- [ ] Protect routes requiring authentication
- [ ] Tests (happy path, expired token, missing token, invalid token)
- [ ] Update docs/context.md with auth entry points

## Success criteria

- Unauthenticated requests to protected routes return 401
- Valid credentials return a working session/token
- Expired/invalid tokens are rejected
- Tests pass

## Validation

- Integration test: login → access protected route → success
- Integration test: no token → access protected route → 401
- Integration test: expired token → access protected route → 401

## Dependencies

- No blocking dependencies; can be implemented independently
- Will touch all protected routes — coordinate with any in-flight route work

## Files / surfaces

- `TBD` — depends on project stack
- `tests/auth/`
