| Model              | Question it Answers  | Simple Scenario Example                          |
|--------------------|----------------------|--------------------------------------------------|
| Authentication     | Who are you?         | User logs in → JWT proves the user is Ravi       |
| Role-Based         | What role?           | Ravi is a Student → can access student page      |
| Permission-Based   | What can you do?     | Teacher can create a course but cannot delete it |
| Ownership-Based    | Is it yours?         | Ravi can edit his own profile, not others        |
| Attribute-Based    | Do attributes match? | Teacher can edit course only in same department  |
| Time-Based         | Is it allowed now?   | Token valid for 1 hour / assignment before 6 PM  |
| Context-Based      | From where?          | Admin login allowed only from office IP          |
| Scope-Based        | What API access?     | Token allows read:course but not write:course    |
