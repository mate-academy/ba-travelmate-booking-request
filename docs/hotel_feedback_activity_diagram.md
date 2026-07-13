# UML Activity Diagram — Hotel Rating

**Use Case:** Hotel Rating  
**Feature:** Feedback and Star rating
**Primary Actor:** Customer (authorized, visited hotel, has not rated yet)
**Goal:** To rate and/or comment hotel after the visit

---

```mermaid
flowchart TD
    Start([🟢 Start]) --> A[Customer navigates\nto 'My Bookings']

    A --> B{Is customer\nauthenticated?}

    B -- No --> C[Show login prompt]
    C --> D{Customer\nlogs in?}
    D -- No --> End1([🔴 End])
    D -- Yes --> E

    B -- Yes --> E[System loads list of\ncompleted bookings]

    E --> F[Customer selects\na specific booking]

    F --> G{Does a review\nalready exist\nfor this booking?}

    G -- Yes --> H[Show message:\n'Review already submitted.\nYou can edit it.']
    H --> End2([🔴 End\nEdit Review UC])

    G -- No --> I[Show empty\nrating form]

    I --> J[Customer selects\nstar rating 1–5]

    J --> K{Does customer\nwant to add\na comment?}

    K -- Yes --> L[Customer writes comment]
    L --> M[Customer submits review]
    K -- No --> M

    M --> N{System validates input:\n– rating selected 1–5\n– comment ≤ 1000 chars\n– no prohibited content}

    N -- Invalid --> O[Show validation error\nwith field hints]
    O --> J

    N -- Valid --> P[Save review linked\nto booking ID in DB]

    P --> Q[Recalculate hotel\naverage rating]
    Q --> R[Send notification\nto hotel]
    R --> S[Show success message\nto customer]
    S --> End3([🔴 End])
```

---

## Use Case Reference

| Field | Value |
|---|---|
| **Use Case Name** | Hotel Rating |
| **Primary Actor** | Customer |
| **Goal** | Submit a new review for a specific completed booking |
| **Pre-conditions** | Customer is authenticated; at least one booking exists with status "completed" |
| **Post-conditions** | Review saved and linked to booking ID; hotel average rating updated; hotel notified |
| **Out of scope** | Editing an existing review → UC "Edit Review" |
| **Main Flow** | Auth → Select booking → Check duplicate → Rating form → Submit → Validate → Save |
| **Alternative Flow** | Not logged in → login prompt → continue or exit |
| **Exception Flows** | Review already exists for booking → redirect to Edit Review UC; Validation fails → retry |
