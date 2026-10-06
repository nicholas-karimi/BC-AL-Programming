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
