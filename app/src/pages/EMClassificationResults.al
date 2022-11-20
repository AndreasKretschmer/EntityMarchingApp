page 77008 "EM Classification Results"
{
    Caption = 'Classification Results';
    PageType = List;
    SourceTable = "EM Classification Result";
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field("RecordID Dataset 1"; Rec."RecordID Dataset 1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the RecordID Dataset 1 field.';
                }
                field("RecordID Dataset 2"; Rec."RecordID Dataset 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the RecordID Dataset 2 field.';
                }
                field(Match; Rec.Match)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Match field.';
                }
                field("Calculated Similarity"; Rec."Calculated Similarity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Calculated Similarity field.';
                }
                field("Classification Method"; Rec."Classification Method")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Calculated Similarity field.';
                }
                field(Threshold; Rec.Threshold)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Calculated Similarity field.';
                }
            }
        }
    }
}
