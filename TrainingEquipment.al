table 50300 "Training Equipment"
{
    fields
    {
        field(1; "Equipment No."; Code[20])
        {
            Caption = 'Equipment No.';
            ToolTip = 'Specifies the unique identifier for the training equipment.';
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            ToolTip = 'Specifies the description of the training equipment.';
        }
        field(3; "Purchase Date"; Date)
        {
            Caption = 'Purchase Date';
            ToolTip = 'Specifies the date when the training equipment was purchased.';
        }
        field(4; "Is Active"; Boolean)
        {
            Caption = 'Active';
            ToolTip = 'Specifies whether the training equipment is active.';
        }
    }
    keys
    {
        key(PK; "Equipment No.")
        {
            Clustered = true;
        }
    }
}