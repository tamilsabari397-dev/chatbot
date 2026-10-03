from sqlalchemy.orm import Session

import models
import schemas


def create_expense(
    db: Session,
    expense: schemas.ExpenseCreate
):
    new_expense = models.Expense(
        amount=expense.amount,
        category=expense.category,
        description=expense.description,
        date=expense.date
    )

    db.add(new_expense)
    db.commit()
    db.refresh(new_expense)

    return new_expense


def get_expenses(db: Session):
    return db.query(models.Expense).order_by(
        models.Expense.date.desc()
    ).all()


def get_expense(db: Session, expense_id: int):
    return db.query(models.Expense).filter(
        models.Expense.id == expense_id
    ).first()


def update_expense(
    db: Session,
    expense_id: int,
    expense: schemas.ExpenseCreate
):
    existing = get_expense(db, expense_id)

    if existing is None:
        return None

    existing.amount = expense.amount
    existing.category = expense.category
    existing.description = expense.description
    existing.date = expense.date

    db.commit()
    db.refresh(existing)

    return existing


def delete_expense(db: Session, expense_id: int):
    existing = get_expense(db, expense_id)

    if existing is None:
        return None

    db.delete(existing)
    db.commit()

    return existing