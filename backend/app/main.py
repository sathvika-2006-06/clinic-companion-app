from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager
import logging

from app.config import APP_NAME, DEBUG, ENVIRONMENT, CORS_ORIGINS
from app.models import Base
from app.database import engine, SessionLocal
from app.routers import auth, students, referrals, cases, departments, locations, analytics

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# Create tables on startup
@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup
    Base.metadata.create_all(bind=engine)
    logger.info("Database tables initialized")
    
    # Initialize demo data
    from app.init_db import init_demo_data
    init_demo_data()
    logger.info("Demo data initialized")
    
    yield
    # Shutdown
    logger.info("Application shutting down")

app = FastAPI(
    title=APP_NAME,
    description="Inter-Department Referral System for Dental Colleges",
    version="1.0.0",
    lifespan=lifespan,
    debug=DEBUG
)

# Middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Health check
@app.get("/health")
async def health_check():
    return {"status": "healthy", "environment": ENVIRONMENT}

# Routes
app.include_router(auth.router, prefix="/api/v1/auth", tags=["Authentication"])
app.include_router(students.router, prefix="/api/v1/students", tags=["Students"])
app.include_router(referrals.router, prefix="/api/v1/referrals", tags=["Referrals"])
app.include_router(cases.router, prefix="/api/v1/cases", tags=["Clinical Cases"])
app.include_router(departments.router, prefix="/api/v1/departments", tags=["Departments"])
app.include_router(locations.router, prefix="/api/v1/locations", tags=["Locations"])
app.include_router(analytics.router, prefix="/api/v1/analytics", tags=["Analytics"])

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
