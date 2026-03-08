# database.py
#
# This file sets up the database connection for the backend.
#
# Steps performed in this file:
# 1. Define the database connection URL (PostgreSQL in this case).
# 2. Create a SQLAlchemy engine which manages the connection to the database.
# 3. Configure a session factory using sessionmaker().
# 4. The session object created from this factory will be used to interact with the database
#    (run queries, insert data, update records, delete records).
# 5. The session is later injected into FastAPI routes so each request can safely access the database.

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

# Database connection string
DATABASE_URL = "postgresql://user:password@localhost/biblo"

# Engine manages the connection pool to PostgreSQL
engine = create_engine(DATABASE_URL)

# Session factory used to create database sessions
SessionLocal = sessionmaker(
    autocommit=False,  # changes must be committed manually
    autoflush=False,   # prevents automatic flushing of changes
    bind=engine        # bind session to the database engine
)

from sqlalchemy.orm import declarative_base

Base = declarative_base()


