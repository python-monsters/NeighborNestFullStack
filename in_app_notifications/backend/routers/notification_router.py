
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from database.database import get_db
from models.notification import Notification
from schemas.notification import NotificationCreate

router = APIRouter(prefix="/api/notifications", tags=["Notifications"])

@router.post("/", response_model=NotificationCreate)
def create_notification(note: NotificationCreate, db: Session = Depends(get_db)):
    new_note = Notification(**note.dict())
    db.add(new_note)
    db.commit()
    db.refresh(new_note)
    return new_note

@router.get("/user/{user_id}")
def get_user_notifications(user_id: int, db: Session = Depends(get_db)):
    return db.query(Notification).filter(Notification.user_id == user_id).order_by(Notification.created_at.desc()).all()
