```mermaid
sequenceDiagram

    participant Клієнт

    participant Сервер_TravelMate

    Клієнт->>+Сервер_TravelMate: Дай опис готелю "Зірка"

    Сервер_TravelMate-->>-Клієнт: Ось фото і текст опису
```