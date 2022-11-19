table 77002 "EM Compare Datasets"
{
    Caption = 'Compare Datasets';
    DataClassification = CustomerContent;
    LookupPageId = "EM Compare Datasets";
    DrillDownPageId = "EM Compare Datasets";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = SystemMetadata;
            AutoIncrement = true;
        }
        field(2; "Dataset 1 Table No."; Integer)
        {
            Caption = 'Dataset 1 Table No.';
            DataClassification = CustomerContent;
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Table));
        }
        field(3; "Dataset 2 Table No."; Integer)
        {
            Caption = 'Dataset 2 Table No.';
            DataClassification = CustomerContent;
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Table));
        }
        field(4; "DataSet 1 Table Name"; Text[100])
        {
            Caption = 'DataSet 1 Table Name';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(AllObjWithCaption."Object Name" where("Object Type" = const(Table), "Object ID" = field("Dataset 1 Table No.")));
        }
        field(5; "Dataset 2 Table Name"; Text[100])
        {
            Caption = 'Dataset 2 Table Name';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(AllObjWithCaption."Object Name" where("Object Type" = const(Table), "Object ID" = field("Dataset 2 Table No.")));
        }
        field(6; "Blocking Method"; Enum "EM Blocking Method")
        {
            Caption = 'Blocking Method';
            DataClassification = CustomerContent;
        }
        field(7; "Classification Method"; Enum "EM Classification Method")
        {
            Caption = 'Blocking Method';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    procedure FilterFieldMapping(var EMCompareDatasetsFieldMapp: Record "EM Compare DS Field Mapping")
    begin
        EMCompareDatasetsFieldMapp.Reset();
        EMCompareDatasetsFieldMapp.SetRange("Compare Dataset Entry No.", "Entry No.");
    end;

    procedure FilterFieldMappingBlocking(var EMCompareDatasetsFieldMapp: Record "EM Compare DS Field Mapping")
    begin
        FilterFieldMapping(EMCompareDatasetsFieldMapp);
        EMCompareDatasetsFieldMapp.SetRange("Use for Blocking", true);
    end;

    procedure FilterFieldMappingSimilarity(var EMCompareDatasetsFieldMapp: Record "EM Compare DS Field Mapping")
    begin
        FilterFieldMapping(EMCompareDatasetsFieldMapp);
        EMCompareDatasetsFieldMapp.SetFilter("Distance Method", '<>%1', EMCompareDatasetsFieldMapp."Distance Method"::" ");
    end;
}
