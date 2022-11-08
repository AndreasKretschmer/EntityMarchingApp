page 77003 "EM Compare DS Field Mappings"
{
    Caption = 'Compare DS Field Mappings';
    PageType = ListPart;
    SourceTable = "EM Compare DS Field Mapping";
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Dataset 1 Table No."; Rec."Dataset 1 Table No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Dataset 1 Table No. field.';
                }
                field("Dataset 1 Field No."; Rec."Dataset 1 Field No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Dataset 1 Field No. field.';
                }
                field("Dataset 1 Field Name"; Rec."Dataset 1 Field Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Dataset 1 Field Name field.';
                }
                field("Dataset 2 Table No."; Rec."Dataset 2 Table No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Dataset 2 Table No. field.';
                }
                field("Dataset 2 Field No."; Rec."Dataset 2 Field No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Dataset 2 Field No. field.';
                }
                field("DataSet 2 Field Name"; Rec."DataSet 2 Field Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the DataSet 2 Field Name field.';
                }
                field("Use for Blocking"; Rec."Use for Blocking")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Use for Blocking field.';
                }
            }
        }
    }
}
