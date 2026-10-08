### Architetcure
How Vs Code communicate wth server
VS Code is your development tool. Docker is running Business Central itself. AL extension is the bridge between them.
                    YOUR WINDOWS PC
┌──────────────────────────────────────────────────────────┐
│                                                          │
│   VS Code                                                │
│   ┌─────────────────────┐                                │
│   │ Training AL project │                                │
│   │                     │                                │
│   │ TrainingEquipment   │                                │
│   │ app.json            │                                │
│   └──────────┬──────────┘                                │
│              │                                           │
│              │ AL Extension                               │
│              │ communicates over HTTP                     │
│              ▼                                           │
│   ┌──────────────────────────────────────────────────┐   │
│   │ Docker                                           │   │
│   │                                                  │   │
│   │   BCLocalDev                                    │   │
│   │   ┌──────────────────────────────────────────┐   │   │
│   │   │ Business Central 28                      │   │   │
│   │   │                                          │   │   │
│   │   │ Web Client                               │   │   │
│   │   │ Service Tier                             │   │   │
│   │   │ Database                                │   │   │
│   │   │ AL development endpoint                  │   │   │
│   │   └──────────────────────────────────────────┘   │   │
│   └──────────────────────────────────────────────────┘   │
│                                                          │
└──────────────────────────────────────────────────────────┘

Why Docker
Because Business Central is the thing we're actually developing against. the container gives you a self-contained BC environment.

How Vs talks to docker
VS Code
   │
   │ AL Language extension
   │
   ▼
Business Central development endpoint
   │
   ▼
BCLocalDev container
   │
   ▼
Business Central

Installing Symbols
Ctrl+P 
AL: Download Symbols
AL: Go
Developer: ReloadWindow -  refresh cache

BC responded with symbol packages describing things such as:
Customer
Vendor
Item
Sales Header
Sales Line
Page 21
Table 18
Codeunit 80
...


AL abstracts the database layer away.
ou define the Business Central table object, and BC handles the underlying database representation.

## When you Publish
TrainingEquipment.al
        │
        ▼
      compile
        │
        ▼
   Training.app
        │
        │ publish
        ▼
 ┌─────────────────┐
 │   BCLocalDev    │
 │                 │
 │ Business Central│
 └─────────────────┘
development cycle becomes:
 WRITE
  ↓
COMPILE
  ↓
PUBLISH
  ↓
BUSINESS CENTRAL
  ↓
TEST
  ↓
CHANGE CODE
  ↓
PUBLISH AGAIN

## Env
Dev. Server:
http://BCLocalDev

Dev. ServerInstance:
BC

Dev. Server Tenant:
default

## mental model going forward
For every feature, ask:
1. What data does the feature need?
`→ table`
2. How does the user interact with the data?
`→ page`
3. What business rules/processes does it need?
`→ codeunit / triggers / events`
4. Does it modify existing BC functionality?
`→ tableextension, pageextension, events, etc.`
5. Does it need output?
`→ report`

### Notes
## AL object
You create Business Central objects.
The simplest useful one to start with is a `table.`
A table defines persistent business data.

table 50100 "Training Equipment"
      ↑       ↑
      │       └── Object name
      └────────── Object ID

field(1; "Equipment No."; Code[20])
      ↑        ↑             ↑
      │        │             └── Data type
      │        └──────────────── Field name
      └───────────────────────── Field ID

field(2; Description; Text[100]) - means Create field #2, called Description, capable of storing text up to 100 characters.


## Page
A Page is a Business Central object that provides a user interface for viewing, entering, and modifying data.
There are different page types. eg List, Card etc
A List page displays multiple records, something like:
Training Equipment

┌──────────────┬──────────────────────┬──────────────┬───────────┐
│ Equipment No │ Description          │ Purchase Date│ Is Active │
├──────────────┼──────────────────────┼──────────────┼───────────┤
│ LAP-001      │ Dell Latitude        │ 01/10/2026   │ Yes       │
│ LAP-002      │ HP ProBook           │ 15/09/2026   │ Yes       │
│ MON-001      │ Dell Monitor         │ 20/08/2026   │ No        │
└──────────────┴──────────────────────┴──────────────┴───────────┘
TrainingEquipmentList.al
```AL
page 50100 "Training Equipment List"
{
    PageType = List;
    SourceTable = "Training Equipment";

    layout
    {
        ...

```

The data this page works with comes from the Training Equipment table.
`PageType` tells BC kindof UI we want - a list of records
`SourceTable`-establishes the page's underlying data source.
                 PAGE
                   │
                   │ SourceTable
                   ▼
             Training Equipment
                   │
                   ▼
                Records

`Rec` - is a built-in AL variable representing the current record of the page's source table.
Rec
 │
 ├── Equipment No. → LAP-001
 ├── Description   → Dell Latitude
 ├── Purchase Date → ...
 └── Is Active     → ...
 therefore
 Rec.Description means "The Description field belonging to the current Training Equipment record."


 ## Publish
 Publishing sends your extension from VS Code to your Business Central environment.
 `Ctrl + F5`
 This publishes the extension and opens/refreshes Business Central.
 VS Code
   │
   │ F5
   ▼
BCLocalDev
   │
   ▼
Business Central Web Client

### BC is object-based
Always think - What Business Central objects represent this business capability?
eg
Training Equipment
│
├── Table
│     └── stores the data
│
├── List Page
│     └── displays multiple equipment records
│
├── Card Page
│     └── displays/edits one equipment record
│
└── Codeunit
      └── business logic


The PageType provides standard interaction
List page
   │
   ├── View records
   ├── Create record
   ├── Edit record
   ├── Delete record
   └── Filter/sort records


## page vs pageextension

| You want to... | Use |
|---|---|
| Create a completely new page | `page` |
| Modify an existing BC page | `pageextension` |
| Add fields to an existing page | `pageextension` |
| Add actions to an existing page | `pageextension` |
| Change the layout of your own new page | `page` |
| Replace/create your own separate UI | `page` |


## UsageCategory
UsageCategory = List;
tells Business Central that this page belongs to the Lists category of pages that can be exposed through the client/search experience.

## Cards
A Card page represents one record rather than a list of records.


## CardPageID
Links the list of items to a particular card9detail page on an item

## AL Extension Identity
Business Central doesn't identify an extension by its folder name.
It primarily identifies it using the id in app.json.
If your new project accidentally retained the same id as another project, BC sees them as the same extension.
An AL extension can be in various states such as
Your .al files
      ↓
   Compile
      ↓
   .app package
      ↓
 Published to BC
      ↓
 Installed in tenant
      ↓
 Available in BC client

## ApplicationArea
Business Central uses Application Areas to control which functionality is visible to users.
ApplicationArea = All; - means Make this UI element available regardless of the user's configured application area.

### layout
defines how the fields and controls are arranged on the page.
page
├── layout   → what the user sees
└── actions  → what the user can do

```AL
layout
{
    area(Content)
    {
        group(General)
        {
            field(...)
            field(...)
        }
    }
}
```
### area(Content)
A page has differtent UI areas
Content is the main body of the page — where your actual record information goes.

### Group
A group organizes related fields together visually.
group(General)
{
    field("Equipment No."; Rec."Equipment No.")
    field(Description; Rec.Description)
    field("Purchase Date"; Rec."Purchase Date")
    field("Is Active"; Rec."Is Active")
}
think of group as html fieldsets

### field
field(Description; Rec.Description)
field connects UI control to the record

### Keys
A table's key defines how Business Central identifies and accesses records.

### Code vs Integer
Code is an AL data type designed for codes/identifiers.
Code[20] - A Code value with a maximum length of 20 characters.
in BC- business identifiers ofter use code values
eg
EQ-001
EQ-002
EQ-003
LAPTOP-001
PROJ-2026-001
which are business codes rather than conventional apps using integers eg id=1, 2 etc

| Data | Appropriate type |
|---|---|
| Equipment No. `EQ-001` | `Code[20]` |
| Employee No. `EMP-0042` | `Code[20]` |
| Customer No. `CUST-1001` | `Code[20]` |
| Quantity `25` | `Integer` |
| Number of items `100` | `Integer` |
| Price `125000.50` | `Decimal` |
| Is Active `Yes/No` | `Boolean` |
| Purchase Date | `Date` |
| Description | `Text[100]` |

### No.Series
for automatically generating next business number based on numbering rules, different series, dates, companies etc


### Caption
A Caption is the human-readable label that BC displays to the user.
field(2; Description; Text[100])
```AL
{
    Caption = 'Equipment Description';
}
```


# Custom APIs in AL

## API Page
An API page is for software to interact with BC
`Postman / External App → REST API → API Page → Table`
Training Equipment
        ↓
Training Equipment API
        ↓
http://BCLocalDev:7048/BC/api/...

### Create an API Page
```AL
page 50302 "Training Equipment API"
{
    PageType = API; ## This isn't a normal Web Client page. Expose this page as an API endpoint.
    SourceTable = "Training Equipment"; #means the API operates on the records in our existing table.
}
### API identity
```AL
APIVersion = 'v1.0';
APIPublisher = 'training';
APIGroup = 'equipment';
EntityName = 'trainingEquipment';
EntitySetName = 'trainingEquipment';
```

page 50302 "Training Equipment API"
{
    PageType = API;

    APIVersion = 'v1.0';
    APIPublisher = 'training';
    APIGroup = 'equipment';
    EntityName = 'trainingEquipment';
    EntitySetName = 'trainingEquipment';

    SourceTable = "Training Equipment";
    DelayedInsert=true
}
`DelayedInsert` waits until the record is actually ready to be committed before inserting it.
| Property | Meaning |
|---|---|
| `APIVersion` | Version of our API |
| `APIPublisher` | Namespace/owner of the API |
| `APIGroup` | Groups related APIs |
| `EntityName` | Name of one individual resource |
| `EntitySetName` | Name used for the collection |

used to construct the api endpoint
`/api/training/equipment/v1.0/trainingEquipment`

### API's fields - API Page — Exposing Fields
exposing our table fields through the api.

### API Layout
API page, we use the layout section to define the fields exposed by the API.
```json
layout
{
    area(Content)
    {
        field(id; Rec."Equipment No.")
        {
        }

        field(description; Rec.Description)
        {
        }

        field(purchaseDate; Rec."Purchase Date")
        {
        }

        field(isActive; Rec."Is Active")
        {
        }
    }
}
```
field(description; Rec.Description)
      ↑                 ↑
 API field name        BC table field
API pages use API-friendly names, rather than necessarily exposing your internal BC field names verbatim.

Ouput
```{
    "id": "EQ001",
    "description": "Laptop",
    ...
}```

### Calling our custom API
Publisher = training
Group     = equipment
Version   = v1.0
Entity    = trainingEquipment

endpoint
http://BCLocalDev:7048/BC/api/training/equipment/v1.0/trainingEquipment?tenant=default&company=CRONUS%20USA%2C%20Inc.

Pass the tenant and company as postman params to keep url clean
| Key | Value |
|---|---|
| `tenant` | `default` |
| `company` | `CRONUS USA, Inc.` |
http://BCLocalDev:7048/BC/api/training/equipment/v1.0/trainingEquipment

http://BCLocalDev:7048
        │
        └── BC server/API service

/BC
 │
 └── Server instance

/api
 │
 └── Business Central API route

/training
 │
 └── APIPublisher

/equipment
 │
 └── APIGroup

/v1.0
 │
 └── APIVersion

/trainingEquipment
 │
 └── EntitySetName

> conceptually
SERVER
  ↓
SERVER INSTANCE
  ↓
API
  ↓
PUBLISHER
  ↓
GROUP
  ↓
VERSION
  ↓
ENTITY
  ↓
TENANT + COMPANY


## OData
Business Central's APIs are built around OData (Open Data Protocol).
OData is the protocol/query model Business Central uses to expose and interact with data over HTTP.
```json
{
    "@odata.context": "http://bclocaldev:7048/BC/api/training/equipment/v1.0/$metadata#trainingEquipment",
    "value": [
        {
            "@odata.etag": "W/\"JzE5Ozk5OTMxMzU5NzUyNTY4Nzc3NTUxOzAwOyc=\"",
            "id": "EQ-001",
            "description": "Laptop",
            "purchaseDate": "2027-02-02",
            "isActive": true
        },
}
```
`"@odata.context": ".../$metadata#trainingEquipment"`
and
`"@odata.etag": "W/..."`

the content and etag helps us use OData capabilities for things like filtering and selecting data.
`...?company=CRONUS USA, Inc.&$filter=isActive eq true`




# POST: Creating a BC Record


# PATCH

## SystemID
Every BC record has a system-generated GUID called `SystemId`.
Equipment No. → business identifier
SystemId      → system identifier

The business number can have meaning to users. SystemId is designed to uniquely identify the record at the system/API level.
## OData ETag
`http://BCLocalDev:7048/BC/api/training/equipment/v1.0/trainingEquipment('EQ-005')?tenant=default&company=CRONUS%20USA%2C%20Inc.`

`"@odata.etag": "W/\"JzIwOz...\""`
An ETag is essentially BC saying:
"This is the current version of this record."
You GET EQ-003
        ↓
You see the current record
        ↓
Someone else changes EQ-003
        ↓
You PATCH using an old version

BC needs a way to know whether you're updating the version you actually read.

Headers
| Key | Value |
|---|---|
| `Content-Type` | `application/json` |
| `If-Match` | `*` |

`If-Match *` tells BC - Update this record regardless of its current ETag.
```json
{
    "@odata.context": "http://bclocaldev:7048/BC/api/training/equipment/v1.0/$metadata#trainingEquipment/$entity",
    "@odata.etag": "W/\"JzIwOzE3ODMwODAxODc1MzU2MTQwODAzMTswMDsn\"",
    "id": "EQ-005",
    "description": "External Monitor",
    "purchaseDate": "2026-12-08",
    "isActive": true
}
```

### Optimistic Concurrency
The If-Match: * - says I don't care which version of the record currently exists; update it.
but in production API we want Update a record only if it is still the version I originally read
therefore `optimistic concurrency` used to enforce this
GET EQ-003
   ↓
Receive ETag A
   ↓
Someone changes EQ-003
   ↓
EQ-003 now has ETag B
   ↓
PATCH using ETag A
   ↓
BC rejects the update

preventing an application from accidentally overwriting somebody else's newer change.

The relationship
ETag
  ↓
represents the current version of the record

If-Match
  ↓
tells the server which version you expect to update

Instead of `If-Match : *` use `If-Match : W/\"JzI...` i.e the ETag returned by GET

## API keys and SystemId
the different ideas
Equipment No.       → business identifier
SystemId             → BC system identifier
our table has `field(1; "Equipment No."; Code[20])` with `key(PK; "Equipment No.")`


```field(id; Rec.SystemId)
{
}```

instead of
```json
{
            "@odata.etag": "W/\"JzE5OzU5MjA0MDkwMjA3OTYyODk4MDUxOzAwOyc=\"",
            "id": "EQ-005",
            "description": "Monitor",
            "purchaseDate": "2026-12-08",
            "isActive": true
        }
        ```
using system id you get 
``json
 {
            "@odata.etag": "W/\"JzE5OzgyNjg2MjAxODQ4NTkzNTM4OTUxOzAwOyc=\"",
            "equipmentNo": "EQ-005",
            "id": "ba80a5e0-4ac3-f111-9f3f-f4aed838a579",
            "description": "External Monitor",
            "purchaseDate": "2026-12-08",
            "isActive": true
        }

```
EQ-005 is meaningful to the business.
SystemId is stable and designed for system-to-system identification.