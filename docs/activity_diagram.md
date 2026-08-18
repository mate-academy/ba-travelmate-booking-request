# Feature: [User account]
## Use Case: [Change booking dates]

[The main actors involved in the process are the **User**, the **TravelMate_Server**, and the **Manager**. Throughout the workflow, the server checks the availability of the new dates and calculates any price adjustments, involves the manager for manual approval if necessary, and updates the booking while sending a confirmation to the user.]

```mermaid
stateDiagram-v2
    %% Define Swimlanes (Actors)
    state User {
        [*] --> RequestChange: Selects & submits new dates
        RequestChange --> SelectNewDates: Error received (Try again)
        SelectNewDates --> RequestChange
        MakePayment --> AwaitConfirmation: Payment processed
    }

    state TravelMate_Server {
        state is_available <<choice>>
        state needs_approval <<choice>>

        RequestChange --> CheckAvailability: Validates requested dates
        CheckAvailability --> is_available
        
        is_available --> ShowError: No (Unavailable)
        is_available --> CalculatePrice: Yes (Available)
        
        CalculatePrice --> ProcessPayment: Price difference / Fee required
        CalculatePrice --> CheckPolicy: Free change / Refund
        
        CheckPolicy --> needs_approval
        needs_approval --> NotifyManager: Requires manual review
        needs_approval --> UpdateBooking: Auto-approved

        ProcessPayment --> MakePayment
        
        UpdateBooking --> SendConfirmation: Updates database
        SendConfirmation --> [*]: Sends email notification
    }

    state Manager {
        NotifyManager --> ReviewRequest: Reviews date change
        
        state is_approved <<choice>>
        ReviewRequest --> is_approved
        
        is_approved --> UpdateBooking: Approved
        is_approved --> ShowError: Rejected
    }
```
