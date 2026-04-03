# Database Migrations

## 1. What a Migration Is

A migration is a file that records how to change the database schema

Example migration:
```
Add column created_at to users
```
Migration files are version-controlled and stored in your project.

This allows:

* Upgrade database
* Downgrade database
* Recreate database
* Track schema history

## 2. What Alembic Does

Alembic compares:
```
Your SQLAlchemy models
vs
Your current database
```
Then generates a migration script.

Example generated migration:
```
def upgrade():
    op.add_column("users",
        sa.Column("created_at", sa.DateTime())
    )

def downgrade():
    op.drop_column("users", "created_at")
```
Meaning:
```
upgrade()   → apply change
downgrade() → revert change
```

## 3. Setting Up Alembic

### a. Inside your project folder run:
```
pip install alembic
```
### b. Then initialize Alembic:
```
alembic init alembic
```
This creates a structure like:
```
project
│
├── alembic/
│   ├── versions/
│   ├── env.py
│
├── alembic.ini
```
### c. Edit alembic.ini
Find:
```
sqlalchemy.url = driver://user:pass@localhost/dbname
```
And put in your real PostgreSQL URL (Use the same URL from ```database.py```):
```
sqlalchemy.url = postgresql://postgres:yourpassword@localhost/biblo
```
This tells Alembic which database to update.
### d. Edit alembic/env.py
Find:
```
target_metadata = None
```
And put in:
```
from models import Base

target_metadata = Base.metadata
```
Because Alembic must read your SQLAlchemy models. Without this Alembic won't detect your tables.

## 4. Running Alembic
### a. Making a model change/update
Open ```models.py``` and change this:
```
class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True)
    email = Column(String, unique=True, index=True)
```
To this:
```
class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True)
    email = Column(String, unique=True, index=True)

    # added a new column to the table "users"
    favorite_genre = Column(String, index=True)
```
### b. Generating a migration
In the project terminal, run:
```
alembic revision --autogenerate -m "add favorite_genre to users"
```
This creates a file inside ```alembic/versions/```.
Example: ```92jd8_add_favorite_genre_to_users.py```

Open it and you should see something like:
```
def upgrade():
    op.add_column(
        "users",
        sa.Column("favorite_genre", sa.String(), nullable=True)
    )
```
This is the exact DB change.
### c. Apply the migration
Now run:
```
alembic upgrade head
```
This is to apply the latest migration to the database. Now PostgreSQL updates the table safely.
### d. Verify the changes
Open pgAdmin 4 and go to:
```
biblo
→ Schemas
→ public
→ Tables
→ users
→ Columns
```
Hit refresh and you should see:
```
id
name
email
favorite_genre
```
This shows that the migration was successful.
