page 77004 "EM Compare DS Blocking Buffer"
{
    Caption = 'Compare DS Blocking Buffer';
    PageType = List;
    SourceTable = "EM Compare DS Blocking Buff.";
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Dataset Table No."; Rec."Dataset Table No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Dataset Table No. field.';
                }
                field("DataSet Record Id"; Rec."DataSet Record Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the DataSet Record Id field.';
                }
                field("Blocking Key"; Rec."Blocking Key")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Blocking Key field.';
                }
            }
        }
    }
}
