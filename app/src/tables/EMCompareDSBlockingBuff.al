table 77004 "EM Compare DS Blocking Buff."
{
    Caption = 'Compare DS Blocking Buff.';
    DataClassification = ToBeClassified;
    DrillDownPageId = "EM Compare DS Blocking Buffer";
    LookupPageId = "EM Compare DS Blocking Buffer";

    fields
    {
        field(1; "Compare Dataset Entry No."; Integer)
        {
            Caption = 'Compare Dataset Entry No.';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(2; "Dataset Table No."; Integer)
        {
            Caption = 'Dataset Table No.';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(3; "DataSet Record Id"; RecordId)
        {
            Caption = 'DataSet Record Id';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(4; "Blocking Key"; Text[2042])
        {
            Caption = 'Blocking Key';
            DataClassification = SystemMetadata;
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Compare Dataset Entry No.", "Dataset Table No.", "DataSet Record Id")
        {
            Clustered = true;
        }
    }
}
