from sqlalchemy.orm import Session
from app.database import SessionLocal
from app.models import User, Student, Faculty, Department, Block, Floor, Room, Unit, Patient
from app.auth.jwt_handler import get_password_hash
import uuid

def init_demo_data():
    """Initialize demo data"""
    db = SessionLocal()
    
    try:
        # Check if data already exists
        if db.query(User).count() > 0:
            return
        
        # Create departments
        departments = [
            ("Periodontics", "PERIO"),
            ("Oral Medicine", "OMFD"),
            ("Oral Surgery", "OMS"),
            ("Conservative Dentistry", "CONS"),
            ("Prosthodontics", "PROS"),
            ("Pedodontics", "PEDO"),
        ]
        
        dept_map = {}
        for dept_name, dept_code in departments:
            dept = Department(name=dept_name, code=dept_code)
            db.add(dept)
            db.flush()
            dept_map[dept_name] = dept.id
        
        db.commit()
        
        # Create blocks
        block_a = Block(name="Block A", location="Main Building")
        block_b = Block(name="Block B", location="North Wing")
        db.add_all([block_a, block_b])
        db.commit()
        
        # Create floors
        floors = []
        for block in [block_a, block_b]:
            for floor_num in range(1, 3):
                floor = Floor(block_id=block.id, floor_number=floor_num, name=f"{floor_num}st Floor")
                db.add(floor)
                db.flush()
                floors.append(floor)
        
        db.commit()
        
        # Create rooms
        rooms = []
        for floor in floors:
            dept = db.query(Department).first()
            for room_num in range(1, 5):
                room = Room(
                    floor_id=floor.id,
                    department_id=dept.id,
                    room_number=f"{floor.floor_number}0{room_num}",
                    room_name=f"Room {floor.floor_number}0{room_num}"
                )
                db.add(room)
                db.flush()
                rooms.append(room)
        
        db.commit()
        
        # Create units (chairs)
        for room in rooms:
            for unit_num in range(1, 4):
                unit = Unit(
                    room_id=room.id,
                    unit_number=unit_num,
                    unit_name=f"Chair {unit_num}"
                )
                db.add(unit)
        
        db.commit()
        
        # Create users and students
        for i in range(1, 3):
            user = User(
                email=f"student{i}@clinic.demo",
                password_hash=get_password_hash("Demo@123"),
                role="STUDENT",
                first_name=f"Student",
                last_name=f"User{i}",
                phone=f"+91-98765432{10+i}"
            )
            db.add(user)
            db.flush()
            
            dept = db.query(Department).first()
            student = Student(
                user_id=user.id,
                student_id=f"STU00{i}",
                department_id=dept.id,
                semester=5
            )
            db.add(student)
        
        db.commit()
        
        # Create faculty
        for i in range(1, 3):
            user = User(
                email=f"faculty{i}@clinic.demo",
                password_hash=get_password_hash("Demo@123"),
                role="FACULTY",
                first_name=f"Dr.",
                last_name=f"Faculty{i}",
                phone=f"+91-98765432{20+i}"
            )
            db.add(user)
            db.flush()
            
            dept = db.query(Department).offset(i-1).first()
            faculty = Faculty(
                user_id=user.id,
                faculty_id=f"FAC00{i}",
                department_id=dept.id,
                designation="Professor"
            )
            db.add(faculty)
        
        db.commit()
        
        # Create admin
        admin_user = User(
            email="admin@clinic.demo",
            password_hash=get_password_hash("Demo@123"),
            role="ADMIN",
            first_name="Admin",
            last_name="User",
            phone="+91-9876543200"
        )
        db.add(admin_user)
        db.commit()
        
        # Create patients (No login)
        for i in range(1, 6):
            patient = Patient(
                patient_id=f"P{i:03d}",
                phone=f"+91-999999990{i}",
                patient_name=f"Patient {i}",
                age=25+i*2,
                gender="M" if i % 2 == 0 else "F"
            )
            db.add(patient)
        
        db.commit()
        
        print("✓ Demo data initialized successfully!")
        print("✓ Student Logins: student1@clinic.demo / student2@clinic.demo")
        print("✓ Faculty Logins: faculty1@clinic.demo / faculty2@clinic.demo")
        print("✓ Admin Login: admin@clinic.demo")
        print("✓ All passwords: Demo@123")
        print("✓ Patients (No login): P001, P002, P003, P004, P005")
        
    except Exception as e:
        print(f"Error initializing demo data: {e}")
        db.rollback()
    finally:
        db.close()
