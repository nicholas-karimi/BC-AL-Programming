page 50302 "Training Equipment API"

{
    PageType = API;

    // API identity
    APIVersion = 'v1.0';
    APIPublisher = 'training';
    APIGroup = 'equipment';
    EntityName = 'trainingEquipment';
    EntitySetName = 'trainingEquipment';
    
    SourceTable = "Training Equipment"; 
    DelayedInsert = true;


    layout 
    {
        area(Content)
        {
            // field(id; Rec."Equipment No.")
            // {
            //     ApplicationArea = All;
            // }
            field(id; Rec.SystemId)
            {
                ApplicationArea = All;
            }
            field(description; Rec.Description)
            {
                ApplicationArea = All;
            }
            field(purchaseDate; Rec."Purchase Date")
            {
                ApplicationArea = All;
            }
            field(isActive; Rec."Is Active")
            {
                ApplicationArea = All;
            }
        }
    }
}