table 77005 "EM SLK Field Setup"
{
    Caption = 'SLK Field Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Compare DS Entry No."; Integer)
        {
            Caption = 'Compare DS Entry No.';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(2; "Field No. Family Name DS 1"; Integer)
        {
            Caption = 'Field No. Family Name DS 1';
            DataClassification = CustomerContent;
        }
        field(3; "Field No. Family Name DS 2"; Integer)
        {
            Caption = 'Field No. Family Name DS 2';
            DataClassification = CustomerContent;
        }
        field(4; "Field No. First Name DS 1"; Integer)
        {
            Caption = 'Field No. First Name DS 1';
            DataClassification = CustomerContent;
        }
        field(5; "Field No. First Name DS 2"; Integer)
        {
            Caption = 'Field No. First Name DS 2';
            DataClassification = CustomerContent;
        }
        field(6; "Field No. Date of Birth DS 1"; Integer)
        {
            Caption = 'Field No. Date of Birth DS 1';
            DataClassification = CustomerContent;
        }
        field(7; "Field No. Date of Birth DS 2"; Integer)
        {
            Caption = 'Field No. Date of Birth DS 2';
            DataClassification = CustomerContent;
        }
        field(8; "Field No. Gender DS 1"; Integer)
        {
            Caption = 'Field No. Gender DS 1';
            DataClassification = CustomerContent;
        }
        field(9; "Field No. Gender DS 2"; Integer)
        {
            Caption = 'Field No. Gender DS 2';
            DataClassification = CustomerContent;
        }
        field(10; "Table No. DS 1"; Integer)
        {
            Caption = 'Table No. DS 1';
            DataClassification = SystemMetadata;
        }
        field(11; "Table No. DS 2"; Integer)
        {
            Caption = 'Table No. DS 1';
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(PK; "Compare DS Entry No.")
        {
            Clustered = true;
        }
    }

    procedure GetSetupAndCheckFields(EntryNo: Integer)
    begin
        Rec.Get(EntryNo);
        Rec.TestField("Field No. Date of Birth DS 1");
        Rec.TestField("Field No. Date of Birth DS 2");
        Rec.TestField("Field No. Family Name DS 1");
        Rec.TestField("Field No. Family Name DS 2");
        Rec.TestField("Field No. First Name DS 1");
        Rec.TestField("Field No. First Name DS 2");
        Rec.TestField("Field No. Gender DS 1");
        Rec.TestField("Field No. Gender DS 2");
    end;
}
