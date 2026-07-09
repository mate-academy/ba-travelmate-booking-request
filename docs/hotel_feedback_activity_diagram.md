# UML Activity Diagram — Hotel Rating

**Use Case:** Hotel Rating  
**Feature:** Feedback and Star rating
**Primary Actor:** Customer (authorized, visited hotel, has not rated yet)
**Goal:** To rate and/or comment hotel after the visit

---

```mermaid
flowchart TD
    Start([🟢 Start]) --> A[Customer opens hotel page]

    A --> B{Is customer\nauthenticated?}

    B -- No --> C[Show login prompt]
    C --> D{Customer\nlogs in?}
    D -- No --> End1([🔴 End])
    D -- Yes --> E

    B -- Yes --> E{Has customer\ncompleted a booking\nat this hotel?}

    E -- No --> F[Show error:\n'No confirmed booking']
    F --> End2([🔴 End])

    E -- Yes --> G{Has customer\nalready rated\nthis hotel?}

    G -- Yes --> H[Load existing rating\nand comment]
    H --> I[Show pre-filled\nrating form]

    G -- No --> I2[Show empty\nrating form]

    I --> J
    I2 --> J

    J[Customer selects\nstar rating 1–5] --> K{Does customer\nwant to add\na comment?}

    K -- Yes --> L[Customer writes comment]
    L --> M[Submit review]

    K -- No --> M

    M --> N{System validates\ninput}

    N -- Invalid --> O[Show validation error\nHighlight fields]
    O --> J

    N -- Valid --> P{Is this an\nupdate?}

    P -- Yes --> Q[Update existing\nrating in DB]
    P -- No --> R[Save new\nrating in DB]

    Q --> S[Recalculate hotel\naverage rating]
    R --> S

    S --> T[Send notification\nto hotel]
    T --> U[Show success message\nto customer]
    U --> End3([🔴 End])
```

---

## Use Case Reference

| Field                 | Value                                                               |
| --------------------- | ------------------------------------------------------------------- |
| **Use Case Name**     | Hotel Rating                                                        |
| **Primary Actor**     | Customer                                                            |
| **Goal**              | Rate a visited hotel                                                |
| **Pre-conditions**    | Authorized; completed booking; not rated yet                        |
| **Post-conditions**   | Rating saved; hotel average updated; hotel notified                 |
| **Main Flow**         | Auth check → Booking check → Duplicate check → Form → Submit → Save |
| **Alternative Flows** | Not logged in → login prompt; Already rated → pre-fill form         |
| **Exception Flows**   | No booking → access denied; Validation fail → retry                 |