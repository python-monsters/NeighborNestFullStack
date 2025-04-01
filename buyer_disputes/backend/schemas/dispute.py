
from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class DisputeCreate(BaseModel):
    buyer_id: int
    seller_id: int
    listing_id: int
    issue: str

class DisputeOut(BaseModel):
    id: int
    buyer_id: int
    seller_id: int
    listing_id: int
    issue: str
    created_at: datetime

    class Config:
        orm_mode = True
