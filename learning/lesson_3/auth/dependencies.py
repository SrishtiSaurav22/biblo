from fastapi import Depends, HTTPException
from fastapi.security import OAuth2PasswordBearer
from auth.token import verify_access_token

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login")


def get_current_user(token: str = Depends(oauth2_scheme)):
    email = verify_access_token(token)

    if email is None:
        raise HTTPException(
            status_code=401,
            detail="Invalid or expired token"
        )

    return email