page 50301 "Training Equipment Card"
{
    PageType = Card;
    SourceTable = "Training Equipment";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Equipment No."; Rec."Equipment No.")
                {
                    Caption = 'Equipment No.';
                }

                field(Description; Rec.Description)
                {
                    Caption = 'Description';
                }

                field("Purchase Date"; Rec."Purchase Date")
                {
                    Caption = 'Purchase Date';
                }

                field("Is Active"; Rec."Is Active")
                {
                    Caption = 'Active';
                }
            }
        }
    }
}