table 77005 "EM Classification Result"
{
    Caption = 'Classification Result';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Compare Dataset Entry No."; Integer)
        {
            Caption = 'Compare Dataset Entry No.';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(2; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = SystemMetadata;
            Editable = false;
            AutoIncrement = true;
        }
        field(3; "RecordID Dataset 1"; RecordId)
        {
            Caption = 'RecordID Dataset 1';
            DataClassification = CustomerContent;
        }
        field(4; "RecordID Dataset 2"; RecordId)
        {
            Caption = 'RecordID Dataset 2';
            DataClassification = CustomerContent;
        }
        field(5; Match; Boolean)
        {
            Caption = 'Match';
            DataClassification = CustomerContent;
        }
        field(6; "Calculated Similarity"; Decimal)
        {
            Caption = 'Calculated Similarity';
            DataClassification = CustomerContent;
        }
        field(7; Threshold; Decimal)
        {
            Caption = 'Threshold';
            DataClassification = CustomerContent;
        }
        field(8; "Classification Method"; Enum "EM Classification Method")
        {
            Caption = 'Classification Method';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Compare Dataset Entry No.", "Entry No.")
        {
            Clustered = true;
        }
    }
}
