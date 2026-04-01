# Password hashing (using bcrypt)

## 1. Setup

### a. Inside your virtual environment, run:
```
pip install passlib[bcrypt]
```
We usually use Passlib, which wraps bcrypt nicely.

### b. Recommended project structure
```
app/
│
├── auth/
│   ├── hashing.py
│   └── routes.py
│
├── models/
├── schemas/
├── db/
└── main.py
```
### c. Create hashing utility
In app/auth/hashing.py, put in:
```
# app/auth/hashing.py
from passlib.context import CryptContext

pwd_context = CryptContext(
    schemes=["bcrypt"],
    deprecated="auto"
)

def hash_password(password: str) -> str:
    return pwd_context.hash(password)

def verify_password(plain_password: str, hashed_password: str) -> bool:
    return pwd_context.verify(plain_password, hashed_password)
```
### d. Update the user model
Add the following to ```models.py```:
```
# auth update
    password_hash = Column(String, nullable=False)
```
What the updated ```models.py``` file should look like:
```
from sqlalchemy import Column, Integer, String
from database import Base

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True)
    email = Column(String, unique=True, index=True)

    # added a new column to the table "users"
    favorite_genre = Column(String, index=True)

    # auth update
    password_hash = Column(String, nullable=False)
```
### e. Setup a signup route
Add the following to ```routes.py```:
```
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from auth.hashing import hash_password
from models import User
from auth.hashing import verify_password

router = APIRouter()

@router.post("/signup")
def signup(email: str, password: str, db: Session):
    hashed = hash_password(password)

    new_user = User(
        email=email,
        password_hash=hashed
    )

    db.add(new_user)
    db.commit()

    return {"message": "User created"}
```
### f. Setup the login route
Add the following to ```routes.py```:
```
@router.post("/login")
def login(email: str, password: str, db: Session):
    user = db.query(User).filter(User.email == email).first()

    if not user:
        return {"error": "Invalid credentials"}

    if not verify_password(password, user.password_hash):
        return {"error": "Invalid credentials"}

    return {"message": "Login success"}
```

