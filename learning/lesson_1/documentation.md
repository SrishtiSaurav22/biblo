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
<img src="assets/image_1.png" width="600">

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
<img src="assets/image_2.png" width="600"> 

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

<img src="assets/image_3.png" width="600">


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
