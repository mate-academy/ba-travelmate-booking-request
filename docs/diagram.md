# Feature: Booking Flow

## Use Case: Book a Hotel Room

This diagram shows the main hotel booking process in TravelMate. The user searches for a hotel, selects a room, completes the payment, and receives a booking confirmation from the system.

```mermaid
sequenceDiagram
    participant User
    participant TravelMate_System

    User->>+TravelMate_System: Search for hotels
    TravelMate_System-->>-User: Display available hotels

    User->>+TravelMate_System: Select hotel and room
    TravelMate_System-->>-User: Show booking details

    User->>+TravelMate_System: Confirm booking
    TravelMate_System->>TravelMate_System: Process payment
    TravelMate_System-->>-User: Booking confirmed
```