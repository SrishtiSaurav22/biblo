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

Here, notice this:

```
if not user:
    return {"error": "Invalid credentials"}
```
and:
```
if not verify_password(...):
    return {"error": "Invalid credentials"}
```
We use the same message for both, and this is a good security practice because it prevents attackers from knowing whether the email exists.

### g. Testing
If the current state of the project structure is as follows:
<br>
<img src="assets/project-structure-screenshot.png" width="900">
<br>
And the ```main.py``` file looks like this:
```
from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session

import models
import schemas
from database import engine, get_db
from models import Base, User

app = FastAPI()

Base.metadata.create_all(bind=engine)


@app.post("/users", response_model=schemas.UserResponse)
def create_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    new_user = User(name=user.name, email=user.email)
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return new_user


@app.get("/users")
def get_users(db: Session = Depends(get_db)):
    return db.query(User).all()


@app.get("/users/{user_id}")
def get_user(user_id: int, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.id == user_id).first()

    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    return user


@app.delete("/users/{user_id}")
def delete_user(user_id: int, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.id == user_id).first()

    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    db.delete(user)
    db.commit()

    return {"message": "User deleted"}
```

Then, when you run the command:
```
uvicorn main:app --reload
```
You see the following output on the terminal:
```
(venv) PS X:\xxxx\xxxx\xxxx\xxxx\project-related-learning> uvicorn main:app --reload
INFO:     Will watch for changes in these directories: ['X:\\xxxx\\xxxx\\xxxx\\xxxx\\project-related-learning']
INFO:     Uvicorn running on http://127.0.0.1:8000 (Press CTRL+C to quit)
INFO:     Started reloader process [22668] using StatReload
INFO:     Started server process [10724]
INFO:     Waiting for application startup.
INFO:     Application startup complete.
INFO:     127.0.0.1:51817 - "GET / HTTP/1.1" 404 Not Found
INFO:     127.0.0.1:51817 - "GET /favicon.ico HTTP/1.1" 404 Not Found
INFO:     127.0.0.1:50177 - "GET / HTTP/1.1" 404 Not Found
INFO:     127.0.0.1:50177 - "GET / HTTP/1.1" 404 Not Found
```
And on the browser:
<br>
<img src="assets/404_screenshot.png" width="900">
<br>
This is because:<br>
i. Your FastAPI server is running perfectly. <br>
ii. You visited http://127.0.0.1:8000/ <br>
iii. But you haven’t created a route for / yet <br>
iv. So FastAPI is saying: “I’m running, but no endpoint exists at the homepage.” <br>
v. Right now, your app does not have the route: ```@app.get("/")``` <br>
vi. So, the root page returns 404. <br>
vii. To fix this, add the following to your ```main.py``` file:
```
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def home():
    return {"message": "API is running"}
```
So, now your main.py file should look like:
```
from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session

import models
import schemas
from database import engine, get_db
from models import Base, User

app = FastAPI()

Base.metadata.create_all(bind=engine)

@app.get("/")
def home():
    return {"message": "API is running"}


@app.post("/users", response_model=schemas.UserResponse)
def create_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    new_user = User(name=user.name, email=user.email)
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return new_user


@app.get("/users")
def get_users(db: Session = Depends(get_db)):
    return db.query(User).all()


@app.get("/users/{user_id}")
def get_user(user_id: int, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.id == user_id).first()

    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    return user


@app.delete("/users/{user_id}")
def delete_user(user_id: int, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.id == user_id).first()

    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    db.delete(user)
    db.commit()

    return {"message": "User deleted"}
```
Now, run:
```
uvicorn main:app --reload
```
And you'll get the following output on the terminal:
```
INFO:     Will watch for changes in these directories: ['X:\\xxxx\\xxxx\\xxxx\\xxxx\\project-related-learning']
INFO:     Uvicorn running on http://127.0.0.1:8000 (Press CTRL+C to quit)
INFO:     Started reloader process [21764] using StatReload
INFO:     Started server process [36672]
INFO:     Waiting for application startup.
INFO:     Application startup complete.
INFO:     127.0.0.1:56923 - "GET / HTTP/1.1" 200 OK
```
And on the browser:
<img src="assets/200_screenshot.png" width="900">
<img src="assets/swagger_ui_ss.png" width="900">

