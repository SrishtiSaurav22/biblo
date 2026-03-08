# 1. Create your first backend server

## a. Check if Python is installed in your system
```
PS C:\Windows\System32> python --version
Python was not found; run without arguments to install from the Microsoft Store, or disable this shortcut from Settings > Apps > Advanced app settings > App execution aliases.
```
```
PS C:\Windows\System32> py --version
Python 3.14.2
```
## b. Go to your project and create a virtual environment
```
PS C:\Users\srish\OneDrive\Documents\project-related-learning> py -m venv venv

PS C:\Users\srish\OneDrive\Documents\project-related-learning> venv\Scripts\activate
```
You may get this error:
```
venv\Scripts\activate : File C:\Users\srish\OneDrive\Documents\project-related-learning\venv\Scripts\Activate.ps1 cannot be loaded because running scripts is disabled on this system. For more information, see about_Execution_Policies at https:/go.microsoft.com/fwlink/?LinkID=135170. At line:1 char:1 + venv\Scripts\activate + ~~~~~~~~~~~~~~~~~~~~~ + CategoryInfo : SecurityError: (:) [], PSSecurityException + FullyQualifiedErrorId : UnauthorizedAccess
```
So to fix it, run this in PowerShell:
```
PS C:\Windows\System32> Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```
<strong>NOTE:</strong>

PowerShell execution policies:
* Restricted → no scripts allowed
* RemoteSigned → local scripts allowed (safe)
* Unrestricted → everything allowed (not recommended)
We set it to RemoteSigned, which is the standard dev setup.

Now, try again:
```
PS C:\Users\srish\OneDrive\Documents\project-related-learning> venv\Scripts\activate

(venv) PS C:\Users\srish\OneDrive\Documents\project-related-learning>
```
## c. Install FastAPI 
```
(venv) PS C:\Users\srish\OneDrive\Documents\project-related-learning> pip install fastapi uvicorn
```
Now, press 
```
Ctrl + Shift + P
```
Select 
```
Python: Select Interpreter
```
If you don't see an interpreter within venv then, make sure venv actually exists:

### (i) In your project folder, check:
```
project-related-learning/
│
├── venv/
│    ├── Scripts/
│    │     ├── python.exe   ← THIS must exist
```
### (ii) Then, close VS Code completely

### (iii) Now, go to your project folder in File Explorer. 
Right-click inside folder
Click "Open with Code" (You should see a VS Code icon) (This ensures VS Code opens from the correct directory)

### (iv) Now, select the interpreter properly

Inside VS Code, press:
```
Ctrl + Shift + P
```
Type:
```
Python: Select Interpreter
```
If you still don’t see the venv interpreter:
Click:
```
Enter interpreter path
```
→ Find
Then manually navigate to:
project-related-learning/venv/Scripts/python.exe
Select it.

## d. Create main.py

```
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def root():
    return {"message": "Biblo backend is running"}
```

## e. Then in the terminal run:
```
uvicorn main:app --reload
```
Open in a browser: 
```
http://127.0.0.1:8000/
```
You should see:
```
{"message": "Biblo backend is running"}
 ```
<img src="assets/image_1.png" width="900">

You just built a backend server.

## f. What Just Happened?

* FastAPI created an HTTP server.
* @app.get("/") means:
* When someone sends GET request to /
* It calls root()
* Returns JSON automatically

# 2. Making it Biblo specific:

To stimulate: 
```
POST /signup
```
## a. In main.py, put this code:

```
from pydantic import BaseModel

class UserSignup(BaseModel):
    username: str
    email: str
    password: str

@app.post("/signup")
def signup(user: UserSignup):
    return {
        "message": f"User {user.username} registered successfully"
    }
```

After adding the above piece of code, the full code looks like:

```
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def root():
    return {"message": "Biblo backend is running"}

from pydantic import BaseModel

class UserSignup(BaseModel):
    username: str
    email: str
    password: str

@app.post("/signup")
def signup(user: UserSignup):
    return {
        "message": f"User {user.username} registered successfully"
    }

```

## b. Restart the server

## c. Go to:
```
http://127.0.0.1:8000/docs
```
<img src="assets/image_2.png" width="1200"> 

## d. What Is Pydantic Doing Here?
Pydantic:
*	Validates incoming JSON
*	Ensures types are correct
*	Converts JSON → Python object

If Flutter sends:
```
{
  "username": "srishti",
  "email": "test@email.com",
  "password": "1234"
}
```
FastAPI automatically converts it into:
```
user.username
user.email
```
No manual parsing.

# CRUD operations

## Implementing CRUD (Without database)

### a. Create book schema
```
from pydantic import BaseModel

class Book(BaseModel):
    id: int
    title: str
    author: str
```

### b. Fake database
```
books = []
```

### c. CREATE
```
@app.post("/books")
def create_book(book: Book):
    books.append(book)
    return {"message": "Book added", "book": book}
```

### d. READ
```
@app.get("/books")
def get_books():
    return books
```

### e. UPDATE
```
@app.put("/books/{book_id}")
def update_book(book_id: int, updated_book: Book):
    for i, book in enumerate(books):
        if book.id == book_id:
            books[i] = updated_book
            return {"message": "Book updated"}
    return {"error": "Book not found"}
```

### f. DELETE
```
@app.delete("/books/{book_id}")
def delete_book(book_id: int):
    for book in books:
        if book.id == book_id:
            books.remove(book)
            return {"message": "Book deleted"}
    return {"error": "Book not found"}
```

<img src="assets/image_3.png" width="1200">
<img src="assets/image_4.png" width="1200">

# Database connections

## a. Installing SQLAlchemy:
```
pip install sqlalchemy psycopg2-binary
```

## b. To verify if the installation went through correctly, you may run:
```
pip list
```

## c. Explanation
The ```database.py``` file sets up the following backend steps:
```
FastAPI endpoint => SQLAlchemy Session => SQL Query => PostGreSQL Database
```

Example: This automatically creates SQL tables:
```
class User(Base):
    __tablename__ = "users"

    id = Column(UUID, primary_key=True)
    username = Column(String)
    email = Column(String)
```
## d. Create database file
1. Review ```database.py```.
2. Create the database connection engine. See the below example setup:
```
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

DATABASE_URL = "postgresql://user:password@localhost/biblo"

engine = create_engine(DATABASE_URL)

SessionLocal = sessionmaker(
    autocommit=False,
    autoflush=False,
    bind=engine
)
```
3. We will be creating SQL tables, refer to the example below:
```
class User(Base):
    __tablename__ = "users"

    id = Column(UUID, primary_key=True)
    username = Column(String)
    email = Column(String)
```
4. What we achieved so far:
```
Flutter App => HTTP Request => FastAPI Endpoint => Validation (Pydantic) => Business Logic => Database Query => JSON Response
```
## e. Install [PostgreSQL](https://www.postgresql.org/download/windows/)
1. Click: Download the installer (EDB Installer). This will redirect you to EnterpriseDB.
2. Download the latest PostgreSQL version.
3. Run the installer.
4. What the ```database.py``` files does now:
a. The database URL ```postgresql://postgres:password@localhost:5432/biblo``` tells you where the database lives.
b. ```engine = create_engine(...)``` manages connections to PstgreSQL (it's like a bridge to the database).
c. Each API request will create a database session to run queries:
```
SessionLocal = sessionmaker(...)
```
d. The base is used to define database models (tables):
```
Base = declarative_base()
```
e. Test database connection:
(i) Create a temporary file: ```test_db.py```
(ii) File contet:
```
from database import engine

try:
    connection = engine.connect()
    print("Database connection successful!")
    connection.close()
except Exception as e:
    print("Database connection failed:", e)
```
(iii) Run it: ```python test_db.py```
(iv) Expected output: ```Database connection successful!```
f. What we have achieved so far:
```
FastAPI server => SQLAlchemy => PostgreSQL connection => Biblo database
```
## f. Configure pgadmin 4
1. Create a server, and configure the following settings:
```
Host name/address: localhost
Port: 5432
Maintenance database: postgres
Username: postgres
Password: your_password
```
2. The hostname is localhost because the PostgreSQL server is running on your own computer. ```localhost``` means "connect to the database server on this machine".
3. Create the biblo Database
4. Connect FastAPI → PostgreSQL
a. Install dependency (one more library):
```
pip install python-dotenv
```
b. Update ```database.py``` as:
```
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base

DATABASE_URL = "postgresql://postgres:yourpassword@localhost:5432/biblo"

engine = create_engine(DATABASE_URL)

SessionLocal = sessionmaker(
    autocommit=False,
    autoflush=False,
    bind=engine
)

Base = declarative_base()
```
5. Create Your First Table ```Users```:
a. Create a new file ```models.py``` and add the following content in it:
```
from sqlalchemy import Column, Integer, String
from database import Base


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True)
    email = Column(String, unique=True, index=True)
```
b. Create the Table in the Database:
(i) Add the following to ```main.py```:
```
from database import engine
from models import Base
import models
```
(ii) After creating the FastAPI app, add this line:
```
Base.metadata.create_all(bind=engine)
```
(iii) Example:
```
from fastapi import FastAPI
from database import engine
import models
from models import Base

app = FastAPI()

Base.metadata.create_all(bind=engine)


@app.get("/")
def root():
    return {"message": "API is running"}
```
c. Run the Server:
```
uvicorn main:app --reload
```
d. Verify Table Was Created:
Go to:
```
Databases
  → biblo
      → Schemas
          → public
              → Tables
```
Under ```Tables``` you should see ```users```.
e. If you face issues, review your ```models.py``` file that should look like this:
```
from sqlalchemy import Column, Integer, String
from database import Base


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True)
    email = Column(String, unique=True, index=True)
```
f. In case you don't see the server, refresh pgAdmin as it does not auto-refresh.
