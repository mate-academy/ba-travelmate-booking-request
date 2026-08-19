# file: subscription_service.py

# Зовнішній сервіс, який імітує відправку email
class EmailService:
    def send(self, email, message):
        print(f"Sending email to {email}: {message}")


# Базовий клас User
class User:
    def __init__(self, name, age, email):
        self.name = name
        self.age = age
        self.email = email


# Клас Admin наслідує User
class Admin(User):
    def __init__(self, name, age, email, permissions):
        super().__init__(name, age, email)
        self.permissions = permissions


# Функція для розрахунку знижки
def calculate_discount(plan_type, is_student):
    if is_student:
        return 0.2   # 20% знижка для студента
    elif plan_type == "yearly":
        return 0.1   # 10% знижка для річного плану
    else:
        return 0.0   # без знижки


# Основна бізнес-логіка
def calculate_subscription_total(user, base_price, plan_type, is_student, email_service):
    # 1. Перевірка бізнес-правила за віком
    if user.age < 18:
        return {
            "success": False,
            "error": "User must be at least 18 years old"
        }

    # 2. Розрахунок знижки
    discount_rate = calculate_discount(plan_type, is_student)

    # 3. Обчислення фінальної ціни
    discount_amount = base_price * discount_rate
    final_price = base_price - discount_amount

    # 4. Додаткове бізнес-правило для річного плану
    if plan_type == "yearly":
        final_price = final_price * 12

    # 5. Зовнішній виклик
    email_service.send(
        user.email,
        f"Hello {user.name}, your subscription total is {final_price}"
    )

    # 6. Повернення результату
    return {
        "success": True,
        "user": user.name,
        "plan_type": plan_type,
        "base_price": base_price,
        "discount_rate": discount_rate,
        "final_price": final_price
    }


# Приклад використання
if __name__ == "__main__":
    email_service = EmailService()
    user = User("Ivan", 25, "ivan@example.com")
    admin = Admin("Olena", 30, "olena@example.com", ["manage_users", "view_reports"])

    result = calculate_subscription_total(
        user=user,
        base_price=100,
        plan_type="monthly",
        is_student=True,
        email_service=email_service
    )

    print(result)
