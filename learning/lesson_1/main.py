#__________________________________________________________________
# Basics
#__________________________________________________________________
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

#__________________________________________________________________
# Learning CRUD operations (without database)
#__________________________________________________________________
class Book(BaseModel):
    id: int
    title: str
    author: str

books=[] # Temporary in-memory database

# Add a book
@app.post("/books")
def create_book(book: Book):
    books.append(book)
    return {"message": "Book added", "book":book}

# Get all books
@app.get("/books/{book_id}")
def get_books():
    return books

# Update a book
@app.put("/books/{book_id}")
def update_book(book_id: int, updated_book: Book):
    for i,book in enumerate(books):
        if book.id == book_id:
            books[i] = updated_book
            return {"message":"Book updated"}
        return {"error":"book not found"}

@app.delete("/books/{book_id}")
def delete_book(book_id: int):
    for book in books:
        if book.id == book_id:
            books.remove(book)
            return {"message":"Book deleted"}
        return {"error":"Book not found"}

#__________________________________________________________________

#__________________________________________________________________
