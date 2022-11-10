page 77005 "EM SLK Field Setup Card"
{
    Caption = 'SLK Field Setup Card';
    PageType = Card;
    SourceTable = "EM SLK Field Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                group("Dataset 1")
                {
                    field("Field No. Date of Birth DS 1"; Rec."Field No. Date of Birth DS 1")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Field No. Date of Birth DS 1 field.';
                    }
                    field("Field No. Family Name DS 1"; Rec."Field No. Family Name DS 1")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Field No. Family Name DS 1 field.';
                    }
                    field("Field No. First Name DS 1"; Rec."Field No. First Name DS 1")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Field No. First Name DS 1 field.';
                    }
                    field("Field No. Gender DS 1"; Rec."Field No. Gender DS 1")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Field No. Gender DS 1 field.';
                    }
                }
                group("Dataset 2")
                {
                    field("Field No. Date of Birth DS 2"; Rec."Field No. Date of Birth DS 2")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Field No. Date of Birth DS 2 field.';
                    }
                    field("Field No. Family Name DS 2"; Rec."Field No. Family Name DS 2")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Field No. Family Name DS 2 field.';
                    }
                    field("Field No. First Name DS 2"; Rec."Field No. First Name DS 2")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Field No. First Name DS 2 field.';
                    }
                    field("Field No. Gender DS 2"; Rec."Field No. Gender DS 2")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Field No. Gender DS 2 field.';
                    }
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec."Compare DS Entry No." := CompareDSEntryNo;
        Rec."Table No. DS 1" := TableIdDS1;
        Rec."Table No. DS 2" := TableIdDS2;
    end;

    procedure SetEntryNoAndTableId(EntryNo: Integer; TableIdDataset1: Integer; TableIdDataset2: Integer)
    begin
        CompareDSEntryNo := EntryNo;
        TableIdDS1 := TableIdDataset1;
        TableIdDS2 := TableIdDataset2;
    end;

    var
        CompareDSEntryNo: Integer;
        TableIdDS1: Integer;
        TableIdDS2: Integer;
}
