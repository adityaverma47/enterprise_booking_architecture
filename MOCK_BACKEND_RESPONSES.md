# Mock Backend Response Examples

This document provides example API responses for integration testing and backend development.

## Authentication Endpoints

### POST /auth/login

**Request:**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response (200 OK):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ1c2VyXzEyMyIsInJvbGUiOiJ1c2VyIiwiaWF0IjoxNjE2MjM5MDIyfQ.example",
  "refresh_token": "refresh_token_abc123",
  "user": {
    "id": "user_123",
    "email": "user@example.com",
    "name": "John Doe",
    "role": "user",
    "phone_number": "+1234567890",
    "avatar_url": null,
    "created_at": "2024-01-01T00:00:00Z"
  }
}
```

### POST /auth/register

**Request:**
```json
{
  "email": "newuser@example.com",
  "password": "password123",
  "name": "Jane Smith",
  "role": "user"
}
```

**Response (201 Created):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh_token": "refresh_token_xyz789",
  "user": {
    "id": "user_456",
    "email": "newuser@example.com",
    "name": "Jane Smith",
    "role": "user",
    "phone_number": null,
    "avatar_url": null,
    "created_at": "2024-02-20T10:00:00Z"
  }
}
```

### POST /auth/refresh

**Request:**
```json
{
  "refresh_token": "refresh_token_abc123"
}
```

**Response (200 OK):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.new_token",
  "refresh_token": "new_refresh_token_xyz",
  "user": {
    "id": "user_123",
    "email": "user@example.com",
    "name": "John Doe",
    "role": "user",
    "phone_number": "+1234567890",
    "avatar_url": null,
    "created_at": "2024-01-01T00:00:00Z"
  }
}
```

## Booking Endpoints

### GET /bookings

**Query Parameters:**
- `page` (optional, default: 1)
- `limit` (optional, default: 20)
- `user_id` (optional)
- `provider_id` (optional)
- `status` (optional: pending, confirmed, in_progress, completed, cancelled)

**Response (200 OK):**
```json
{
  "data": [
    {
      "id": "booking_123",
      "user_id": "user_123",
      "provider_id": "provider_456",
      "service_type": "Consultation",
      "scheduled_at": "2024-02-20T10:00:00Z",
      "status": "confirmed",
      "notes": "Please arrive 10 minutes early",
      "location": "123 Main St, City, State",
      "amount": 100.00,
      "created_at": "2024-02-19T08:00:00Z",
      "updated_at": "2024-02-19T09:00:00Z"
    },
    {
      "id": "booking_124",
      "user_id": "user_123",
      "provider_id": null,
      "service_type": "Repair Service",
      "scheduled_at": "2024-02-21T14:00:00Z",
      "status": "pending",
      "notes": null,
      "location": "456 Oak Ave, City, State",
      "amount": 250.00,
      "created_at": "2024-02-20T10:00:00Z",
      "updated_at": "2024-02-20T10:00:00Z"
    }
  ],
  "page": 1,
  "limit": 20,
  "total": 2
}
```

### GET /bookings/:id

**Response (200 OK):**
```json
{
  "id": "booking_123",
  "user_id": "user_123",
  "provider_id": "provider_456",
  "service_type": "Consultation",
  "scheduled_at": "2024-02-20T10:00:00Z",
  "status": "confirmed",
  "notes": "Please arrive 10 minutes early",
  "location": "123 Main St, City, State",
  "amount": 100.00,
  "created_at": "2024-02-19T08:00:00Z",
  "updated_at": "2024-02-19T09:00:00Z"
}
```

### POST /bookings

**Request:**
```json
{
  "service_type": "Home Cleaning",
  "scheduled_at": "2024-02-25T09:00:00Z",
  "notes": "Deep cleaning required",
  "location": "789 Pine St, City, State"
}
```

**Response (201 Created):**
```json
{
  "id": "booking_125",
  "user_id": "user_123",
  "provider_id": null,
  "service_type": "Home Cleaning",
  "scheduled_at": "2024-02-25T09:00:00Z",
  "status": "pending",
  "notes": "Deep cleaning required",
  "location": "789 Pine St, City, State",
  "amount": null,
  "created_at": "2024-02-20T12:00:00Z",
  "updated_at": "2024-02-20T12:00:00Z"
}
```

### PUT /bookings/:id/status

**Request:**
```json
{
  "status": "confirmed"
}
```

**Response (200 OK):**
```json
{
  "id": "booking_123",
  "user_id": "user_123",
  "provider_id": "provider_456",
  "service_type": "Consultation",
  "scheduled_at": "2024-02-20T10:00:00Z",
  "status": "confirmed",
  "notes": "Please arrive 10 minutes early",
  "location": "123 Main St, City, State",
  "amount": 100.00,
  "created_at": "2024-02-19T08:00:00Z",
  "updated_at": "2024-02-20T13:00:00Z"
}
```

### PUT /bookings/:id/assign

**Request:**
```json
{
  "provider_id": "provider_789"
}
```

**Response (200 OK):**
```json
{
  "id": "booking_125",
  "user_id": "user_123",
  "provider_id": "provider_789",
  "service_type": "Home Cleaning",
  "scheduled_at": "2024-02-25T09:00:00Z",
  "status": "pending",
  "notes": "Deep cleaning required",
  "location": "789 Pine St, City, State",
  "amount": null,
  "created_at": "2024-02-20T12:00:00Z",
  "updated_at": "2024-02-20T14:00:00Z"
}
```

### DELETE /bookings/:id

**Response (204 No Content)**

## Error Responses

### 400 Bad Request
```json
{
  "message": "Invalid request parameters",
  "errors": {
    "scheduled_at": "Scheduled time must be in the future"
  }
}
```

### 401 Unauthorized
```json
{
  "message": "Unauthorized. Please login again."
}
```

### 403 Forbidden
```json
{
  "message": "Access forbidden. Insufficient permissions."
}
```

### 404 Not Found
```json
{
  "message": "Resource not found"
}
```

### 500 Internal Server Error
```json
{
  "message": "Server error. Please try again later."
}
```

## WebSocket Events (Real-Time)

### Booking Status Update
```json
{
  "event": "booking.status.updated",
  "data": {
    "booking_id": "booking_123",
    "status": "confirmed",
    "message": "Booking confirmed by provider",
    "timestamp": "2024-02-20T13:00:00Z"
  }
}
```

### Provider Assigned
```json
{
  "event": "booking.provider.assigned",
  "data": {
    "booking_id": "booking_125",
    "provider_id": "provider_789",
    "provider_name": "Jane Provider",
    "timestamp": "2024-02-20T14:00:00Z"
  }
}
```
