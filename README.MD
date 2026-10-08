# Business Central & AL Learning Roadmap

A structured, hands-on learning path for Microsoft Dynamics 365 Business Central development using **AL**.

The goal is not simply to learn AL syntax or build isolated exercises. The goal is to understand **how Business Central is structured, how extensions work, how AL objects interact, and how to build real business functionality inside the platform**.

The learning approach is deliberately progressive:

> **Understand the platform → understand AL objects → learn business logic → build a real feature → integrate with BC → develop professionally**

---

# 0. Environment & Business Central Foundations

Before writing serious AL, it is important to understand the environment in which AL applications actually run.

## Why this matters

Business Central development is different from building a conventional standalone application.

When developing a Django, Laravel, Go, or Java application, you typically control the application runtime, database, HTTP server, deployment process, and application architecture directly.

Business Central works differently.

AL code runs **inside the Business Central platform**, and developers extend an existing ERP system rather than building the entire application from scratch.

Understanding this environment makes concepts such as:

- extensions
- tables
- pages
- records
- companies
- tenants
- permissions
- APIs
- events
- publishing
- symbols
- server instances

much easier to understand.

---

## Local Development Environment

Our development environment uses a local Business Central Docker container.

### Environment

| Component | Configuration |
|---|---|
| Operating System | Windows 11 |
| Container | `BCLocalDev` |
| Business Central | 28.5 |
| Server Instance | `BC` |
| Tenant | `default` |
| Authentication | `UserPassword` / `NavUserPassword` |
| Web Client | `http://BCLocalDev/BC/` |
| API / OData | Port `7048` |
| Developer Services | Port `7049` |

### Why Docker?

Docker gives us a disposable, reproducible Business Central development environment.

Instead of installing and configuring the entire Business Central server stack directly on Windows, the BC server runs inside a container.

Conceptually:

```text
Windows 11
    │
    └── Docker
          │
          └── BCLocalDev
                │
                ├── Business Central Server
                ├── Web Client
                ├── API / OData
                └── Developer Services
```

This is particularly useful for learning because the environment can be inspected, reset, and recreated without turning the host machine into a BC installation experiment.

---

## Understanding BC Services and Ports

The container exposes different Business Central services through different ports.

| Port | Service | Purpose |
|---:|---|---|
| `80` | HTTP / Web Client | Browser access to Business Central |
| `7048` | API / OData | REST APIs and OData |
| `7049` | Developer Services | AL development and VS Code |
| `7047` | SOAP | SOAP web services |

The important distinction for AL development is:

```text
7048 → API / OData
7049 → Developer Services
```

VS Code communicates with Business Central's Developer Services when working with AL:

```text
VS Code
   │
   │ AL Language Extension
   ▼
BCLocalDev:7049
   │
   ▼
Business Central
```

REST API clients such as Postman communicate through API Services:

```text
Postman
   │
   ▼
BCLocalDev:7048
   │
   ▼
Business Central API
```

---

## Business Central Server, Company, and Tenant

Another important distinction is the difference between the:

- Business Central server instance
- tenant
- company

Our development environment uses:

```text
Server Instance
    BC

Tenant
    default

Company
    CRONUS USA, Inc.
```

These are different concepts.

A **tenant** represents an isolated Business Central environment within the server infrastructure.

A **company** represents an organization/entity whose business data is stored within Business Central.

This distinction becomes particularly important when working with:

- APIs
- permissions
- data
- multi-tenant environments
- deployment
- administration

---

## API Authentication Troubleshooting

During setup we encountered:

```text
Authentication_InvalidCredentials
```

even though the `ADMIN` credentials worked in the Web Client.

The cause was the multi-tenant API request not specifying the tenant.

The working request became:

```text
http://BCLocalDev:7048/BC/api/v2.0/companies?tenant=default
```

This was a useful infrastructure lesson, but it is **not part of the core AL progression**.

The important takeaway is simply:

> Business Central's infrastructure model matters when developing against the platform, but infrastructure troubleshooting should not replace learning AL itself.

---

# Phase 1 — AL + Business Central Foundations

## Goal

Understand the Business Central development model and the core AL object model.

Before writing complicated business logic, we need to understand the objects that make up a Business Central application.

---

## 1. What Business Central Is

Understand:

- What Business Central is
- What problems an ERP solves
- How Business Central is structured
- Companies and business data
- Standard application functionality
- Extensions
- Customization versus modification
- How AL fits into the platform

### Key mental model

We are not building an ERP from scratch.

We are extending an existing ERP platform.

```text
Business Central
       │
       ├── Standard Application
       │
       └── Our Extension
              │
              ├── Tables
              ├── Pages
              ├── Codeunits
              ├── Reports
              ├── Queries
              └── Other AL objects
```

---

## 2. How Extensions Work

Understand:

- What an extension is
- Installing an extension
- Publishing an extension
- Compiling an extension
- Dependencies
- Symbols
- Extension IDs
- App versions
- How custom functionality interacts with standard BC functionality

---

## 3. AL Project Structure

Learn the basic AL project structure.

Important files and concepts:

```text
AL Project
├── app.json
├── *.al
└── .vscode/
```

Understand:

- `app.json`
- Application ID
- Publisher
- Version
- Runtime
- Dependencies
- Target
- AL source files

---

## 4. Tables

Learn how Business Central represents business data.

Topics:

- Creating tables
- Table IDs
- Fields
- Field properties
- Data types
- Primary keys
- Secondary keys
- Relationships
- Table metadata

Example conceptual model:

```text
Equipment
├── No.
├── Description
├── Category
├── Status
└── Purchase Date
```

---

## 5. Fields and Data Types

Understand common AL data types:

- `Code`
- `Text`
- `Integer`
- `Decimal`
- `Boolean`
- `Date`
- `DateTime`
- `Enum`
- `Option` where relevant
- `Record`
- `Guid`

Learn when to use each type and how Business Central's data model differs from a conventional relational application.

---

## 6. Keys

Understand:

- Primary keys
- Secondary keys
- Key fields
- Indexing
- Why keys matter for data access and performance

---

## 7. Pages

Pages are the primary UI objects in Business Central.

Learn:

- Page types
- Page structure
- Layout
- Fields
- Actions
- Properties
- Source tables

---

## 8. List vs Card Pages

Understand the distinction between:

### List

Used to browse multiple records.

```text
Equipment List

No.     Description       Status
-----------------------------------
EQ001   Laptop            Available
EQ002   Projector         Assigned
EQ003   Camera            Maintenance
```

### Card

Used to view and edit an individual record.

```text
Equipment Card

No.           EQ001
Description   Laptop
Status        Available
Category      Computer
```

Understand when each page type is appropriate.

---

## 9. Page Layout and Properties

Learn:

- `area`
- `group`
- `repeater`
- fields
- actions
- page properties
- captions
- visibility
- editable state
- application areas where relevant

---

## 10. `Rec` and Records

This is one of the most important AL concepts.

Understand:

- What a `Record` is
- What `Rec` represents
- Current record context
- Filtering
- Finding records
- Reading records
- Modifying records
- Inserting records
- Deleting records

This is where the Business Central data model begins to feel very different from conventional ORM-based development.

---

## 11. Table Extensions

Learn how to extend an existing Business Central table without modifying the base application.

For example:

```text
Standard BC Table
        │
        └── Table Extension
                │
                ├── Custom Field
                └── Custom Field
```

---

## 12. Page Extensions

Learn how to extend existing Business Central pages.

Examples:

- Add fields
- Add actions
- Add groups
- Modify page presentation
- Expose custom table-extension fields

---

### Phase 1 Status

We've already covered a significant portion of this phase.

The goal now is not to rush ahead because we've seen the syntax.

We want to make sure the **underlying BC object model is genuinely understood** before moving heavily into business logic.

---

# Phase 2 — Business Logic

Once the object model is comfortable, we move from defining **data and UI** into defining **behavior**.

This is where AL starts feeling much more like application development.

---

## 1. Codeunits

Learn:

- What codeunits are
- Why business logic belongs in codeunits
- Creating codeunits
- Calling procedures
- Organizing business logic

---

## 2. Procedures and Functions

Learn:

- Procedures
- Parameters
- Return values
- Local versus global scope
- Reusable logic
- Calling procedures across objects

---

## 3. Variables and Data Manipulation

Work with:

- Variables
- Records
- Lists
- Arrays where appropriate
- Enums
- Text manipulation
- Dates
- Numbers
- Record filtering

---

## 4. Validation

Understand Business Central's validation model.

Topics:

- Field validation
- `Validate`
- `OnValidate`
- Data integrity
- Validation versus business logic

---

## 5. Triggers

Learn the major trigger concepts and when they execute.

Examples include:

- `OnInsert`
- `OnModify`
- `OnDelete`
- `OnValidate`
- Page triggers
- Codeunit triggers where applicable

The important goal is understanding **when and why code executes**, rather than memorizing trigger names.

---

## 6. Business Rules

Begin implementing realistic rules.

For example:

```text
Equipment
    │
    ├── Available
    │      └── Can be assigned
    │
    ├── Assigned
    │      └── Cannot be assigned again
    │
    └── Maintenance
           └── Cannot be assigned
```

---

## 7. Events and Subscribers

Learn the Business Central event model.

Topics:

- Events
- Event publishers
- Event subscribers
- Subscribing to standard BC behavior
- Decoupling custom logic
- Extending behavior without modifying standard objects

---

# Phase 3 — Build a Proper Mini-ERP Feature

Instead of continuously creating disconnected exercises, we will evolve one feature into a small but coherent Business Central application.

## Training Equipment Management

The feature will progressively grow into something resembling a real ERP module.

```text
Equipment
│
├── Equipment master data
│
├── Status
│
├── Assignment
│
├── Validation
│
├── Business rules
│
├── Related records
│
└── Useful pages/actions
```

---

## Initial Feature

Start with:

```text
Equipment
├── No.
├── Description
├── Category
├── Status
└── Purchase Date
```

Then progressively introduce:

### Master Data

- Equipment records
- Categories
- Status
- Descriptions
- Metadata

### Assignment

```text
Equipment
       │
       ▼
Assignment
       │
       ├── Employee
       ├── Assignment Date
       └── Return Date
```

### Validation

Examples:

- Equipment must exist
- Equipment cannot be assigned twice
- Equipment under maintenance cannot be assigned
- Returned equipment becomes available

### Business Rules

Move from simple CRUD into actual domain behavior.

### Related Records

Introduce relationships between:

- Equipment
- Employees
- Assignments
- Categories
- Maintenance records

### Pages and Actions

Build useful workflows rather than merely displaying records.

---

## Later Feature Concepts

As the module matures, introduce:

- More realistic relationships
- Business logic
- Actions
- Permissions
- Reports
- Queries
- Filtering
- Role-based access

The goal is to make the feature feel like a small piece of an actual ERP system.

---

# Phase 4 — Integration

Only after the internal BC development model is comfortable do we focus heavily on APIs.

This is where the external application world meets Business Central.

---

## 1. Standard BC APIs

Learn:

- Standard APIs
- API endpoints
- Companies
- Entities
- API versions
- Filtering
- Pagination
- API metadata

Example:

```text
GET
http://BCLocalDev:7048/BC/api/v2.0/companies?tenant=default
```

---

## 2. Custom API Pages

Learn how Business Central exposes custom application data through APIs.

This is the area we have currently reached.

Understand:

- API pages
- Entity names
- Entity sets
- Publisher
- Group
- Version
- Fields
- Relationships
- API URLs

---

## 3. HTTP Methods

Learn the standard CRUD operations:

```text
GET     → Read
POST    → Create
PATCH   → Update
DELETE  → Delete
```

---

## 4. Postman

Use Postman to interact with Business Central independently of the BC UI.

Practice:

- GET requests
- POST requests
- PATCH requests
- DELETE requests
- Headers
- Authentication
- Query parameters
- JSON bodies
- Response inspection

---

## 5. API Authentication

Understand:

- User/password authentication
- Web Service Access Keys
- Authentication headers
- Authorization
- Permissions
- Tenant selection

The recent `Authentication_InvalidCredentials` issue belongs here as practical infrastructure/integration knowledge.

---

## 6. JSON

Understand how BC data is represented externally.

Example conceptual response:

```json
{
    "id": "...",
    "number": "EQ001",
    "description": "Laptop",
    "status": "Available"
}
```

Understand the relationship between:

```text
AL objects
      ↓
Business Central data
      ↓
API representation
      ↓
JSON
      ↓
External application
```

---

## 7. External Application Integration

Eventually connect Business Central to an external application.

For example:

```text
External Application
       │
       │ REST API
       ▼
Business Central
       │
       ├── Customers
       ├── Vendors
       ├── Items
       └── Custom Equipment
```

This is where the AL knowledge becomes useful beyond the BC client itself.

---

# Phase 5 — Extensions and Professional Business Central Development

Once the fundamentals and application-building skills are solid, move toward professional BC development practices.

---

## Extensions

Deepen knowledge of:

- Table extensions
- Page extensions
- Enum extensions
- Permission extensions
- Other extension mechanisms

---

## Events

Develop deeper understanding of:

- Events
- Event publishers
- Event subscribers
- Integration events
- Business events
- Extensibility patterns

---

## Permissions

Learn:

- Permission sets
- Object permissions
- Permission design
- Least privilege
- User access
- Role-based access

---

## Reports

Learn:

- Report objects
- DataItems
- Request pages
- RDLC layouts
- Word layouts
- Report datasets

---

## Queries

Learn:

- Query objects
- DataItems
- Columns
- Filters
- Query relationships
- When to use queries instead of other data-access approaches

---

## Configuration Patterns

Learn how professional Business Central applications handle:

- Setup tables
- Configuration records
- Number series
- Feature switches
- Defaults
- Application configuration

---

## Integration Patterns

Move beyond simple API calls into:

- Integration architecture
- External systems
- APIs
- Webhooks/events where applicable
- Error handling
- Retry patterns
- Authentication
- Data synchronization
- Integration tables

---

## Deployment and Versioning

Understand the lifecycle of an AL extension:

```text
Develop
   ↓
Compile
   ↓
Test
   ↓
Publish
   ↓
Install
   ↓
Upgrade
   ↓
Deploy
```

Learn:

- App versions
- Dependencies
- Upgrade code
- Publishing
- Installation
- Deployment
- Version compatibility
- Environment management

---

# Learning Philosophy

This curriculum is intentionally **linear**.

We will not jump into advanced APIs, events, or enterprise patterns simply because we can technically make them work.

The progression is:

```text
Business Central
       ↓
AL project
       ↓
Objects
       ↓
Data
       ↓
UI
       ↓
Records
       ↓
Business logic
       ↓
Events
       ↓
Real feature
       ↓
APIs
       ↓
Integrations
       ↓
Professional extension development
```

The objective is not to memorize AL syntax.

The objective is to develop a mental model of **how Business Central applications actually work**.

---

# Current Position

We have already touched several areas of Phase 1 and have reached the beginning of Phase 4 through our API work.

However, API troubleshooting should not be interpreted as skipping the preceding foundations.

The learning path remains:

```text
Phase 1
AL + BC Foundations
        ↓
Phase 2
Business Logic
        ↓
Phase 3
Mini-ERP Feature
        ↓
Phase 4
Integration
        ↓
Phase 5
Professional Development
```

The immediate priority is therefore to **finish understanding the AL/BC foundations properly**, then build progressively toward the larger feature.

---

# End Goal

By the end of this curriculum, the goal is to be able to look at a Business Central requirement and reason about it systematically:

```text
Business Requirement
        ↓
Business Data
        ↓
Tables
        ↓
Relationships
        ↓
Pages
        ↓
Records
        ↓
Business Logic
        ↓
Events
        ↓
Permissions
        ↓
Reports / Queries
        ↓
APIs / Integrations
        ↓
Extension
```

At that point, AL should no longer feel like a collection of strange Business Central-specific syntax.

It should feel like what it actually is:

> **A programming language and application-development model designed around extending an ERP platform.**
