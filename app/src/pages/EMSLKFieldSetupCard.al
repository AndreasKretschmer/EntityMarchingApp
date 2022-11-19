page 77005 "EM SLK Field Setup Card"
{
    Caption = 'SLK Field Setup Card';
    PageType = Card;

    layout
    {
        area(content)
        {
            group(General)
            {
                group("Dataset 1")
                {
                    field("Field No. Family Name DS 1"; FieldNoFamilyName1)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Field No. Date of Birth DS 1 field.';
                        Caption = 'Field No. Family Name DS 1';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            exit(OpenFieldLookupPage(Text, TableIdDS1));
                        end;

                        trigger OnValidate()
                        begin
                            CreateFamilyNameFieldSetup();
                        end;
                    }
                    field("Field No. First Name DS 1"; FieldNoFirstName1)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Field No. Family Name DS 1 field.';
                        Caption = 'Field No. First Name DS 1';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            exit(OpenFieldLookupPage(Text, TableIdDS1));
                        end;

                        trigger OnValidate()
                        begin
                            CreateFirstNameFieldSetup();
                        end;
                    }
                    field("Field No. Date of Birth DS 1"; FieldNoDoB1)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Field No. First Name DS 1 field.';
                        Caption = 'Field No. Date of Birth DS 1';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            exit(OpenFieldLookupPage(Text, TableIdDS1));
                        end;

                        trigger OnValidate()
                        begin
                            CreateDateOfBirthFieldSetup();
                        end;
                    }
                    field("Field No. Gender DS 1"; FieldNoGender1)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Field No. Gender DS 1 field.';
                        Caption = 'Field No. Gender DS 1';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            exit(OpenFieldLookupPage(Text, TableIdDS1));
                        end;

                        trigger OnValidate()
                        begin
                            CreateGenderFieldSetup();
                        end;
                    }
                }
                group("Dataset 2")
                {
                    field("Field No. Family Name DS 2"; FieldNoFamilyName2)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Field No. Date of Birth DS 2 field.';
                        Caption = 'Field No. Family Name DS 2';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            exit(OpenFieldLookupPage(Text, TableIdDS2));
                        end;

                        trigger OnValidate()
                        begin
                            CreateFamilyNameFieldSetup();
                        end;
                    }
                    field("Field No. First Name DS 2"; FieldNoFirstName2)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Field No. Family Name DS 2 field.';
                        Caption = 'Field No. First Name DS 2';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            exit(OpenFieldLookupPage(Text, TableIdDS2));
                        end;

                        trigger OnValidate()
                        begin
                            CreateFirstNameFieldSetup();
                        end;
                    }
                    field("Field No. Date of Birth DS 2"; FieldNoDoB2)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Field No. First Name DS 2 field.';
                        Caption = 'Field No. Date of Birth DS 2';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            exit(OpenFieldLookupPage(Text, TableIdDS2));
                        end;

                        trigger OnValidate()
                        begin
                            CreateDateOfBirthFieldSetup();
                        end;
                    }
                    field("Field No. Gender DS 2"; FieldNoGender2)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Field No. Gender DS 2 field.';
                        Caption = 'Field No. Gender DS 2';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            exit(OpenFieldLookupPage(Text, TableIdDS2));
                        end;

                        trigger OnValidate()
                        begin
                            CreateGenderFieldSetup();
                        end;
                    }
                }
            }
        }
    }


    procedure SetEntryNoAndTableId(EntryNo: Integer; TableIdDataset1: Integer; TableIdDataset2: Integer)
    begin
        CompareDSEntryNo := EntryNo;
        TableIdDS1 := TableIdDataset1;
        TableIdDS2 := TableIdDataset2;
    end;

    local procedure OpenFieldLookupPage(var Value: Text; TableNo: Integer): Boolean
    var
        TempField: Record Field temporary;
        FieldsLookup: Page "Fields Lookup";
    begin
        Value := '';
        TempField.Reset();
        TempField.SetRange(TableNo, TableNo);

        Clear(FieldsLookup);
        FieldsLookup.LookupMode(true);
        FieldsLookup.SetTableView(TempField);
        if FieldsLookup.RunModal() <> Action::LookupOK then
            exit(false);

        FieldsLookup.GetRecord(TempField);
        Value := Format(TempField."No.");
        exit(Value <> '');
    end;

    local procedure CreateFamilyNameFieldSetup()
    begin
        if (FieldNoFamilyName1 = 0) or (FieldNoFamilyName2 = 0) then
            exit;

        CreateEMCompareDSFieldMapping(FieldNoFamilyName1, FieldNoFamilyName2, Enum::"EM SLK Field Type"::"Family Name");
    end;

    local procedure CreateFirstNameFieldSetup()
    begin
        if (FieldNoFirstName1 = 0) or (FieldNoFirstName2 = 0) then
            exit;

        CreateEMCompareDSFieldMapping(FieldNoFirstName1, FieldNoFirstName2, Enum::"EM SLK Field Type"::"First Name");
    end;

    local procedure CreateDateOfBirthFieldSetup()
    begin
        if (FieldNoDoB1 = 0) or (FieldNoDoB2 = 0) then
            exit;

        CreateEMCompareDSFieldMapping(FieldNoDoB1, FieldNoDoB2, Enum::"EM SLK Field Type"::"Date of Birth");
    end;

    local procedure CreateGenderFieldSetup()
    begin
        if (FieldNoGender1 = 0) or (FieldNoGender2 = 0) then
            exit;

        CreateEMCompareDSFieldMapping(FieldNoGender1, FieldNoGender2, Enum::"EM SLK Field Type"::Gender);
    end;

    local procedure CreateEMCompareDSFieldMapping(DS1FieldNo: Integer; DS2FieldNo: Integer; SLKFieldType: Enum "EM SLK Field Type")
    var
        EMCompareDSFieldMapping: Record "EM Compare DS Field Mapping";
    begin
        EMCompareDSFieldMapping.Init();
        EMCompareDSFieldMapping.Validate("Compare Dataset Entry No.", CompareDSEntryNo);
        EMCompareDSFieldMapping.Validate("Dataset 1 Field No.", DS1FieldNo);
        EMCompareDSFieldMapping.Validate("Dataset 1 Field No.", DS2FieldNo);
        EMCompareDSFieldMapping.Validate("Dataset 1 Table No.", TableIdDS1);
        EMCompareDSFieldMapping.Validate("Dataset 1 Table No.", TableIdDS2);
        EMCompareDSFieldMapping.Validate("SLK Field Type", SLKFieldType);
        EMCompareDSFieldMapping.Validate("Use for Blocking", true);
        EMCompareDSFieldMapping.Insert(true);
    end;

    var
        CompareDSEntryNo: Integer;
        TableIdDS1: Integer;
        TableIdDS2: Integer;
        FieldNoDoB1: Integer;
        FieldNoDoB2: Integer;
        FieldNoGender1: Integer;
        FieldNoGender2: Integer;
        FieldNoFamilyName1: Integer;
        FieldNoFamilyName2: Integer;
        FieldNoFirstName1: Integer;
        FieldNoFirstName2: Integer;
}
