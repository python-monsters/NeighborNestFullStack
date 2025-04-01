
from pydantic import BaseModel
from datetime import datetime

class AuctionClipOut(BaseModel):
    id: int
    auction_id: int
    buyer_id: int
    seller_id: int
    clip_filename: str
    uploaded_at: datetime

    class Config:
        orm_mode = True
