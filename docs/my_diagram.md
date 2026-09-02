# Feature: Hotel search and filtering
## Use Case: Filtering


Primary Actor: User
Goal: To filter the hotels by variety of criteria
Pre-conditions: The user is on the search results page.
Trigger: The user clicks on the ‘Filters’ button




```mermaid
flowchart TD
    Start([Start: User on search results page])


    Start --> A1[User clicks 'Filters' button]
    A1 --> D1{Which filters to apply?}


    D1 -->|Budget| B1[User enters minimum budget value]
    B1 --> B2[User enters maximum budget value]
    B2 --> B3[User clicks 'Apply filters' button]
    B3 --> B4[System filters hotels by budget values]
    B4 --> B5[System displays filtered hotel list]
    B5 --> End([End])


    D1 -->|Other filters| O1[User selects necessary filters]
    O1 --> O2[User clicks 'Apply filters' button]
    O2 --> O3[System filters hotels by selected filters]
    O3 --> O4[System displays filtered hotel list]
    O4 --> End


