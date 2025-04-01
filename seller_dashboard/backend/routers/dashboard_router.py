
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from database.database import get_db
from models.listing import Listing
from models.review import Review
from models.auction import Auction
from models.user import User
from sqlalchemy import func

router = APIRouter(prefix="/api/dashboard", tags=["Dashboard"])

@router.get("/seller/{seller_id}")
def get_seller_dashboard(seller_id: int, db: Session = Depends(get_db)):
    # Total active listings
    active_listings = db.query(Listing).filter(Listing.seller_id == seller_id, Listing.status == "active").count()

    # Total sales
    sold_listings = db.query(Listing).filter(Listing.seller_id == seller_id, Listing.status == "sold").count()

    # Average views (fake placeholder: implement with tracking system)
    avg_views = 42  # You would normally track this per item view

    # Auction participation
    auctions = db.query(Auction).filter(Auction.seller_id == seller_id).all()
    total_auctions = len(auctions)
    total_bids = sum([auction.current_bid for auction in auctions if auction.current_bid])

    # Average review rating
    avg_rating = db.query(func.avg(Review.rating)).filter(Review.seller_id == seller_id).scalar() or 0.0

    return {
        "active_listings": active_listings,
        "sold_listings": sold_listings,
        "avg_views": avg_views,
        "auction_stats": {
            "total_auctions": total_auctions,
            "total_bids_earned": total_bids
        },
        "avg_rating": round(avg_rating, 2)
    }
