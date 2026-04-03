from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from auth.hashing import hash_password
from models import User
from auth.hashing import verify_password
from database import get_db
from auth.token import create_access_token

from fastapi.security import OAuth2PasswordRequestForm

router = APIRouter()

@router.post("/signup")
def signup(email: str, password: str, db: Session = Depends(get_db)):
    hashed = hash_password(password)

    new_user = User(
        email=email,
        password_hash=hashed
    )

    db.add(new_user)
    db.commit()

    return {"message": "User created"}

#@router.post("/login")
#def login(email: str, password: str, db: Session = Depends(get_db)):
#    user = db.query(User).filter(User.email == email).first()
#
#    if not user:
#        return {"error": "Invalid credentials"}
#
#    if not verify_password(password, user.password_hash):
#        return {"error": "Invalid credentials"}
#
#    return {"message": "Login success"}

#@router.post("/login")
#def login(email: str, password: str, db: Session = Depends(get_db)):
#    user = db.query(User).filter(User.email == email).first()
#
#    if not user:
#        return {"error": "Invalid credentials"}
#
#    if not verify_password(password, user.password_hash):
#        return {"error": "Invalid credentials"}
#
#    token = create_access_token({"sub": user.email})
#
#    return {
#        "access_token": token,
#        "token_type": "bearer"
#    }

@router.post("/login")
def login(
    form_data: OAuth2PasswordRequestForm = Depends(),
    db: Session = Depends(get_db)
):
    user = db.query(User).filter(
        User.email == form_data.username
    ).first()

    if not user:
        return {"error": "Invalid credentials"}

    if not verify_password(
        form_data.password,
        user.password_hash
    ):
        return {"error": "Invalid credentials"}

    token = create_access_token({"sub": user.email})

    return {
        "access_token": token,
        "token_type": "bearer"
    }