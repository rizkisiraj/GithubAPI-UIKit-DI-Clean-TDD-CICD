# 📱 GithubAPI-UIKit-DI-Clean-TDD-CICD

![New Jeans's Hanni Pham](https://i.pinimg.com/1200x/d9/0f/fe/d90ffe1d1abae640e29eebc18d281efa.jpg)

**My attempt at building a clean, testable, scalable iOS app using UIKit, GitHub API, DI, Clean Architecture, TDD, and CI/CD.**

An iOS Swift application that interacts with the **GitHub API** to fetch and display repository/user data — built using modern development principles like Dependency Injection, Clean Architecture, and automated CI/CD pipelines.

---

## 🚀 Features

* **GitHub API Integration** — Fetch data from GitHub REST endpoints
* **Clean Architecture** — Separation of concerns across layers for maintainability
* **Dependency Injection (DI)** — Decoupled modules with testable interfaces
* **CI/CD Pipeline** — Build + test automation via GitHub Actions / Jenkins

---

## 🧠 Architecture Overview

This project follows the **Clean Architecture** approach, separating code into distinct layers:

```
📦 Data Layer
  └── DTO
  └── Local Data Source
  └── Remote Data Source

📦 Domain Layer
  └── Repositories
  └── Usecases

📦 Presentation Layer
  └── View Controllers
  └── View

📦 Core
  └── DI Container
  └── Network Services
```

This structure enhances **testability**, **maintainability**, and **scalability** over time. ([GitHub][1])

---

## 📦 Technologies & Tools

| Category        | Tools / Frameworks       |
| --------------- | ------------------------ |
| Language        | Swift                    |
| UI Framework    | UIKit                    |
| API Networking  | URLSession / Codable     |
| Architecture    | Clean Architecture       |
| Testing         | XCTest (Unit Tests)      |
| Version Control | Git + GitHub             |
| CI/CD           | GitHub Actions           |

---

## 🛠 Requirements

Before running the app:

* Xcode 14+
* iOS 17.6+ deployment target
* Swift 5.5+
* Network connection for GitHub API

---

## 🧩 Setup & Installation

1. **Clone Repository**

```bash
git clone https://github.com/rizkisiraj/GithubAPI-UIKit-DI-Clean-TDD-CICD.git
cd GithubAPI-UIKit-DI-Clean-TDD-CICD
```

2. **Open in Xcode**

```bash
open GithubAPIWrapper.xcodeproj
```

3. **Build & Run**

Select the desired simulator/device and hit **Run**.

4. **Testing**

* To run unit tests: `⌘U`

---

## 🧪 Tests

This project embraces **Test-Driven Development (TDD)**:

* Unit tests for domain and data layers (only user repositories for now)
* UI tests for core flows
* Mocking of API responses for predictable outcomes

---

## 🔁 Continuous Integration (CI)

The `.github/workflows` folder contains automated workflows:

* **Build**
* **Run Tests**
* **Report test results**
