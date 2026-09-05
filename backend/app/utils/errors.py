"""Custom error classes"""

class ClinicCompanionError(Exception):
    """Base exception for Clinic Companion"""
    pass

class AuthenticationError(ClinicCompanionError):
    """Raised when authentication fails"""
    pass

class AuthorizationError(ClinicCompanionError):
    """Raised when user lacks required permissions"""
    pass

class ResourceNotFoundError(ClinicCompanionError):
    """Raised when requested resource is not found"""
    pass

class ValidationError(ClinicCompanionError):
    """Raised when validation fails"""
    pass

class NotificationError(ClinicCompanionError):
    """Raised when notification sending fails"""
    pass
