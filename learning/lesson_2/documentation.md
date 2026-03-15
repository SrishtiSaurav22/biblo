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
