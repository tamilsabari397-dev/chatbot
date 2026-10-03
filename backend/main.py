from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session

import models
import schemas
import crud

from database import engine, Base, SessionLocal


app = FastAPI(
    title="Daily Expense Tracker API"
)


Base.metadata.create_all(bind=engine)


def get_db():
    db = SessionLocal()

    try:
        yield db
    finally:
        db.close()


@app.get("/")
def home():
    return {
        "message": "Daily Expense Tracker API is running"
    }


@app.post(
    "/expenses",
    response_model=schemas.ExpenseResponse
)
def create_expense(
    expense: schemas.ExpenseCreate,
    db: Session = Depends(get_db)
):
    return crud.create_expense(db, expense)


@app.get(
    "/expenses",
    response_model=list[schemas.ExpenseResponse]
)
def get_expenses(
    db: Session = Depends(get_db)
):
    return crud.get_expenses(db)


@app.get(
    "/expenses/{expense_id}",
    response_model=schemas.ExpenseResponse
)
def get_expense(
    expense_id: int,
    db: Session = Depends(get_db)
):
    expense = crud.get_expense(db, expense_id)

    if expense is None:
        raise HTTPException(
            status_code=404,
            detail="Expense not found"
        )

    return expense


@app.put(
    "/expenses/{expense_id}",
    response_model=schemas.ExpenseResponse
)
def update_expense(
    expense_id: int,
    expense: schemas.ExpenseCreate,
    db: Session = Depends(get_db)
):
    updated = crud.update_expense(
        db,
        expense_id,
        expense
    )

    if updated is None:
        raise HTTPException(
            status_code=404,
            detail="Expense not found"
        )

    return updated


@app.delete("/expenses/{expense_id}")
def delete_expense(
    expense_id: int,
    db: Session = Depends(get_db)
):
    deleted = crud.delete_expense(
        db,
        expense_id
    )

    if deleted is None:
        raise HTTPException(
            status_code=404,
            detail="Expense not found"
        )

    return {
        "message": "Expense deleted successfully"
    }