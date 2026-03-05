## 🧠 Phase 1 – Core Backend Basics
Learn:
* [ ] How HTTP works
* [ ] REST APIs
* [ ] FastAPI basics
* [ ] Pydantic schemas
* [ ] Basic CRUD operations
* [ ] Connecting to PostgreSQL

### Goal:
 You can create endpoints like:
```
POST /signup
GET /books/random
POST /games/submit
```
## 🧠 Phase 2 – Database + ORM
Learn:
* [ ] SQL fundamentals
* [ ] Relationships (Foreign Keys)
* [ ] SQLAlchemy models
* [ ] How to query properly
* [ ] Alembic migrations

This makes your backend stable.

## 🧠 Phase 3 – Authentication
Learn:
* [ ] Password hashing (bcrypt)
* [ ] JWT tokens
* [ ] Protecting routes

Example:
```
GET /recommendations
Authorization: Bearer <token>
```
## 🧠 Phase 4 – ML Integration
Since your ML is not heavy, you can start with simple logic:
* [ ] Filter by genre
* [ ] Rank by preference
* [ ] Weighted scoring

Later you can add:
* [ ] Collaborative filtering
* [ ] Content-based recommendation

For now, ML can just be a Python module inside ```ml/```.
