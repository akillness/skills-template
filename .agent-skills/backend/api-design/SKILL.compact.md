# api-design

> Design RESTful and GraphQL APIs following best practices. Use when creating new APIs, refactoring existing endpoints, or documenting API specificat...

## When to use this skill
• Designing new REST APIs
• Creating GraphQL schemas
• Refactoring API endpoints
• Documenting API specifications
• API versioning strategies
• Defining data models and relationships

## Instructions
▶ S1: Define API requirements
• Identify resources and entities
• Define relationships between entities
• Specify operations (CRUD, custom actions)
• Plan authentication/authorization
• pagination, filtering, sorting
▶ S2: Design REST API
**Resource naming**:
• Use nouns, not verbs: `/users` not `/getUsers`
• Use plural names: `/users/{id}`
• Nest resources logically: `/users/{id}/posts`
• Keep URLs short and intuitive
**HTTP methods**:
• `GET`: Retrieve resources (idempotent)
• `POST`: Create new resources
• `PUT`: Replace entire resource
• `PATCH`: Partial update
• `DELETE`: Remove resources (idempotent)
**Response codes**:
• `200 OK`: Success with response body
• `201 Created`: Resource created successfully
• `204 No Content`: Success with no response body
• `400 Bad Request`: Invalid input
• `401 Unauthorized`: Authentication required
• `403 Forbidden`: No permission
• `404 Not Found`: Resource doesn't exist
• `409 Conflict`: Resource conflict
• `422 Unprocessable Entity`: Validation failed
• `500 Internal Server Error`: Server error
**Example REST endpoint**:
▶ S3: Request/Response format
**Request example**:
**Response example**:
▶ S4: Error handling
**Error response format**:
▶ S5: Pagination
**Query parameters**:
**Response with pagination**:
▶ S6: Authentication
**Options**:
• JWT (JSON Web Tokens)
• OAuth 2.0
• API Keys
• Session-based
**Example with JWT**:
▶ S7: Versioning
**URL versioning** (recommended):
**Header versioning**:
▶ S8: Documentation
Create OpenAPI 3.0 specification:

## Best practices
1. Consistency
2. Versioning
3. Security
4. Validation
5. Rate limiting
