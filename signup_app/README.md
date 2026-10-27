# Sign Up Form
Janiya Green
Undergraduate Track
Github Repo Link: https://github.com/xxklusivenana/signup_app/tree/main/signup_app

## Concept Questions
1. Name the exact information your request sends and one piece of information it deliberately does not send. Why?
- The request sends two fields in JSON format: "task": "signup_tip" and "topic": "password_help".
- It deliberately doesn't send the user's name, email address, password, or any identifying information. This protects the user's privacy as the AI only needs to know enough to provide password advice. It should never need to know any of the user's personal information.
2. Why must the app keep form validation local even when it can ask an AI for a tip? Give one example of a bad decision if AI were allowed to approve signup.
- The app must keep form validation local because validation needs to be consistent, predictable, and independent of the AI service or internet connection. The AI coach is only meant to provide advice and shouldn't decide whether an account can be created. 
- One example: if AI were allowed to approve signup, it might approve two passwords that don't match, allowing the user to continue with incorrect information.

## AI Response
| # | Successful Response | Failure/Offline State |
| - | ------------------- | --------------------- |
| **input** | ![Successful Signup Input](media/evidence/success_input.png) | X |
| **after** | ![Successful Signup Tip](media/evidence/success_advice.png) | If the request times out, the server returns a non-200 status, the JSON is invalid, or the tip is empty, the app displays a friendly error message and a Retry option. If no instructor-provided HTTPS proxy URL is configured, the app displays deterministic mock advice labeled Mock signup advice — no live model called. |

## Request Flow and Privacy Choice
``` mermaid
flowchart TD
    A[User taps Get A Signup Tip] --> B[Display loading indicator]
    B --> C{Instructor HTTPS proxy configured?}

    C -- Yes --> D[Send HTTPS POST request]
    D --> E["JSON: task = signup_tip<br/>topic = password_help"]
    E --> F{Valid HTTP 200 response<br/>with non-empty tip?}

    F -- Yes --> G[Display AI-generated advice<br/>as plain text, max 240 characters]
    F -- No --> H[Display friendly error]
    H --> I[Offer Retry option]
    I --> B

    C -- No --> J[Return deterministic mock tip]
    J --> K[Label as mock advice<br/>No live model called]
```

**Privacy choice:** The request never includes the user's name, email address, password, or confirm-password value. No provider API keys or real credentials are stored in the app. The AI coach only provides optional advice and does not change form values, approve signup, or replace local validation.

## Exit Quiz
![Exit Quiz](media/evidence/exit_quiz.png)
