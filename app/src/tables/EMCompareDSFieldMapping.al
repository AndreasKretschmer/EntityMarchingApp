table 77003 "EM Compare DS Field Mapping"
{
    Caption = 'Compare Datasets Field Mapping';
    DataClassification = CustomerContent;
    LookupPageId = "EM Compare DS Field Mappings";
    DrillDownPageId = "EM Compare DS Field Mappings";

    fields
    {
        field(1; "Compare Dataset Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = SystemMetadata;
            AutoIncrement = true;
            Editable = false;
        }
        field(3; "Dataset 1 Field No."; Integer)
        {
            Caption = 'Dataset 1 Field No.';
            DataClassification = CustomerContent;
            TableRelation = Field."No." where(TableNo = field("Dataset 1 Table No."));
        }
        field(4; "Dataset 2 Field No."; Integer)
        {
            Caption = 'Dataset 2 Field No.';
            DataClassification = CustomerContent;
            TableRelation = Field."No." where(TableNo = field("Dataset 2 Table No."));
        }
        field(5; "Dataset 1 Field Name"; Text[100])
        {
            Caption = 'Dataset 1 Field Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Field.FieldName where(TableNo = field("Dataset 1 Field No."), "No." = field("Dataset 1 Field No.")));
            Editable = false;
        }
        field(6; "DataSet 2 Field Name"; Text[100])
        {
            Caption = 'DataSet 2 Field Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Field.FieldName where(TableNo = field("Dataset 2 Field No."), "No." = field("Dataset 2 Field No.")));
            Editable = false;
        }
        field(7; "Use for Blocking"; Boolean)
        {
            Caption = 'Use for Blocking';
            DataClassification = CustomerContent;
            InitValue = true;
        }
        field(8; "Dataset 1 Table No."; Integer)
        {
            Caption = 'Dataset 1 Table No.';
            DataClassification = CustomerContent;
            // Editable = false;
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Table));
        }
        field(9; "Dataset 2 Table No."; Integer)
        {
            Caption = 'Dataset 2 Table No.';
            DataClassification = CustomerContent;
            // Editable = false;
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Table));
        }
        field(10; "SLK Field Type"; Enum "EM SLK Field Type")
        {
            Caption = 'SLK Field Type';
            DataClassification = CustomerContent;
        }
        field(11; "Distance Method"; Enum "EM Distance Methods")
        {
            Caption = 'Distance Method';
            DataClassification = CustomerContent;
        }
        field(12; "Weighted Similarity"; Decimal)
        {
            Caption = 'Weighted Similarity';
            DataClassification = CustomerContent;
            DecimalPlaces = 5 : 5;
        }
    }
    keys
    {
        key(PK; "Compare Dataset Entry No.", "Line No.")
        {
            Clustered = true;
        }
    }
}
