
from fastapi import APIRouter, UploadFile, File, Form, Depends
from sqlalchemy.orm import Session
from models.auction_clip import AuctionClip
from database.database import get_db
import shutil
import os
from datetime import datetime

router = APIRouter(prefix="/api/clips", tags=["Auction Clips"])

@router.post("/")
async def upload_auction_clip(
    auction_id: int = Form(...),
    buyer_id: int = Form(...),
    seller_id: int = Form(...),
    file: UploadFile = File(...),
    db: Session = Depends(get_db)
):
    filename = f"{datetime.utcnow().isoformat()}_{file.filename}"
    file_path = f"uploads/clips/{filename}"

    os.makedirs("uploads/clips", exist_ok=True)
    with open(file_path, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)

    clip = AuctionClip(
        auction_id=auction_id,
        buyer_id=buyer_id,
        seller_id=seller_id,
        clip_filename=filename
    )
    db.add(clip)
    db.commit()
    db.refresh(clip)
    return {"message": "Clip uploaded successfully", "clip_id": clip.id}

@router.get("/buyer/{buyer_id}")
def get_clips_for_buyer(buyer_id: int, db: Session = Depends(get_db)):
    return db.query(AuctionClip).filter(AuctionClip.buyer_id == buyer_id).all()
