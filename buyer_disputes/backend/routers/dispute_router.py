
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from database.database import get_db
from models.dispute import Dispute
from schemas.dispute import DisputeCreate

router = APIRouter(prefix="/api/disputes", tags=["Disputes"])

@router.post("/", response_model=DisputeCreate)
def create_dispute(dispute: DisputeCreate, db: Session = Depends(get_db)):
    new_dispute = Dispute(**dispute.dict())
    db.add(new_dispute)
    db.commit()
    db.refresh(new_dispute)
    return new_dispute

@router.get("/user/{user_id}")
def get_user_disputes(user_id: int, db: Session = Depends(get_db)):
    return db.query(Dispute).filter(Dispute.buyer_id == user_id).all()
