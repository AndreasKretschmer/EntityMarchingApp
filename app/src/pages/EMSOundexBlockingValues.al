page 77002 "EM Soundex Blocking Values"
{
    ApplicationArea = All;
    Caption = 'Soundex Blocking Values';
    PageType = List;
    SourceTable = "EM Soundex Blocking Values";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Character; Rec.Character)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Character field.';
                }
                field("Value"; Rec."Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Value field.';
                }
            }
        }
    }
}
