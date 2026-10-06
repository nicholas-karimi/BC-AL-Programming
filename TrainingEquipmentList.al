page 50300 "Training Equipment List"
{
    PageType = List;
    SourceTable = "Training Equipment";
    UsageCategory = Lists;
    CardPageId = "Training Equipment Card";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Equipment No."; Rec."Equipment No.")
                {
                    ApplicationArea = All;
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }

                field("Purchase Date"; Rec."Purchase Date")
                {
                    ApplicationArea = All;
                }

                field("Is Active"; Rec."Is Active")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}