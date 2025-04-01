
from pydantic import BaseModel
from datetime import datetime

class NotificationCreate(BaseModel):
    user_id: int
    message: str

class NotificationOut(BaseModel):
    id: int
    user_id: int
    message: str
    created_at: datetime
    is_read: bool

    class Config:
        orm_mode = True
