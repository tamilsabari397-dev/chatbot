from pydantic import BaseModel
from datetime import datetime


class ExpenseCreate(BaseModel):
    amount: float
    category: str
    description: str
    date: datetime


class ExpenseResponse(BaseModel):
    id: int
    amount: float
    category: str
    description: str
    date: datetime

    class Config:
        from_attributes = True