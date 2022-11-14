table 77004 "EM Compare DS Blocking Buff."
{
    Caption = 'Compare DS Blocking Buff.';
    DataClassification = ToBeClassified;
    DrillDownPageId = "EM Compare DS Blocking Buffer";
    LookupPageId = "EM Compare DS Blocking Buffer";

    fields
    {
        field(2; "Blocking Method"; Enum "EM Blocking Method")
        {
            Caption = 'Blocking Method';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(3; "Dataset Table No."; Integer)
        {
            Caption = 'Dataset Table No.';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(4; "DataSet Record Id"; RecordId)
        {
            Caption = 'DataSet Record Id';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(5; "Blocking Key"; Text[2042])
        {
            Caption = 'Blocking Key';
            DataClassification = SystemMetadata;
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Blocking Method", "Dataset Table No.", "DataSet Record Id")
        {
            Clustered = true;
        }
    }
}
