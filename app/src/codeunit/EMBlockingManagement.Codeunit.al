codeunit 77001 "EM Blocking Management"
{
    procedure StartBlocking(EMCompareDatasets: Record "EM Compare Datasets")
    var
        EMCompareDSFieldMapping: Record "EM Compare DS Field Mapping";
    begin
        if (EMCompareDatasets."Dataset 1 Table No." = 0) or (EMCompareDatasets."Dataset 2 Table No." = 0) then
            exit;

        EMCompareDatasets.FilterFieldMappingBlocking(EMCompareDSFieldMapping);
        if EMCompareDSFieldMapping.IsEmpty() then
            exit;

        //CreateBlockingKeys for DataSet 1
        CreateBlockingKeyForDataset(EMCompareDatasets."Dataset 1 Table No.", EMCompareDatasets, EMCompareDSFieldMapping, true);
        //CreateBlockingKeys for DataSet 2
        CreateBlockingKeyForDataset(EMCompareDatasets."Dataset 2 Table No.", EMCompareDatasets, EMCompareDSFieldMapping, false);
    end;

    procedure StartBlocking(EMCompareDatasets: Record "EM Compare Datasets"; var BlockingDictDS1: Dictionary of [Text, List of [RecordId]]; var BlockingDictDS2: Dictionary of [Text, List of [RecordId]])
    var
        EMCompareDSFieldMapping: Record "EM Compare DS Field Mapping";
    begin
        if (EMCompareDatasets."Dataset 1 Table No." = 0) or (EMCompareDatasets."Dataset 2 Table No." = 0) then
            exit;

        EMCompareDatasets.FilterFieldMappingBlocking(EMCompareDSFieldMapping);
        if EMCompareDSFieldMapping.IsEmpty() then
            exit;

        //CreateBlockingKeys for DataSet 1
        CreateBlockingKeyForDataset(EMCompareDatasets."Dataset 1 Table No.", EMCompareDatasets, EMCompareDSFieldMapping, true);
        //CreateBlockingKeys for DataSet 2
        CreateBlockingKeyForDataset(EMCompareDatasets."Dataset 2 Table No.", EMCompareDatasets, EMCompareDSFieldMapping, false);
        BlockingDictDS1 := CreateBlockingDictionary(EMCompareDatasets."Dataset 1 Table No.", EMCompareDatasets."Blocking Method");
        BlockingDictDS2 := CreateBlockingDictionary(EMCompareDatasets."Dataset 2 Table No.", EMCompareDatasets."Blocking Method");
    end;

    local procedure CreateBlockingDictionary(TableNo: Integer; BlockingMethod: Enum "EM Blocking Method") BlockingDict: Dictionary of [Text, List of [RecordId]];
    var
        EMCompareDSBlockingBuff: Record "EM Compare DS Blocking Buff.";
        TempValueList: List of [RecordId];
    begin
        EMCompareDSBlockingBuff.Reset();
        EMCompareDSBlockingBuff.SetRange("Blocking Method", BlockingMethod);
        EMCompareDSBlockingBuff.SetRange("Dataset Table No.", TableNo);
        if EMCompareDSBlockingBuff.FindSet() then
            repeat
                if not BlockingDict.ContainsKey(EMCompareDSBlockingBuff."Blocking Key") then begin
                    Clear(TempValueList);
                    TempValueList.Add(EMCompareDSBlockingBuff."DataSet Record Id");
                    BlockingDict.Add(EMCompareDSBlockingBuff."Blocking Key", TempValueList);
                end else begin
                    BlockingDict.Get(EMCompareDSBlockingBuff."Blocking Key", TempValueList);
                    TempValueList.Add(EMCompareDSBlockingBuff."DataSet Record Id");
                    BlockingDict.Set(EMCompareDSBlockingBuff."Blocking Key", TempValueList)
                end;
            until EMCompareDSBlockingBuff.Next() = 0;
    end;

    local procedure CreateBlockingBufferEntries(TableNo: Integer; SourceRecordId: RecordId; BlockingKey: Text; BlockingMethod: Enum "EM Blocking Method")
    var
        EMCompareDSBlockingBuff: Record "EM Compare DS Blocking Buff.";
    begin
        EMCompareDSBlockingBuff.Init();
        EMCompareDSBlockingBuff.Validate("Dataset Table No.", TableNo);
        EMCompareDSBlockingBuff.Validate("DataSet Record Id", SourceRecordId);
        EMCompareDSBlockingBuff.Validate("Blocking Key", CopyStr(BlockingKey, 1, MaxStrLen(EMCompareDSBlockingBuff."Blocking Key")));
        EMCompareDSBlockingBuff.Validate("Blocking Method", BlockingMethod);
        EMCompareDSBlockingBuff.Insert(true);
    end;

    local procedure CalculateBlockingKey(BlockingMethod: Enum "EM Blocking Method"; SourceRecordref: RecordRef; var EMCompareDSFieldMapping: Record "EM Compare DS Field Mapping"; Dataset1: Boolean) BlockingKey: Text;
    var
        FieldRefFamilyName: FieldRef;
        FieldRefFirstName: FieldRef;
        FieldRefDoB: FieldRef;
        FieldRefGender: FieldRef;
    begin
        BlockingKey := '';
        case BlockingMethod of
            Enum::"EM Blocking Method"::"No Blocking":
                ;
            Enum::"EM Blocking Method"::Simple:
                if EMCompareDSFieldMapping.FindSet() then
                    repeat
                        if Dataset1 then
                            BlockingKey += CalculateSimpleBlockingKey(SourceRecordref.Field(EMCompareDSFieldMapping."Dataset 1 Field No."))
                        else
                            BlockingKey += CalculateSimpleBlockingKey(SourceRecordref.Field(EMCompareDSFieldMapping."Dataset 2 Field No."));
                    until EMCompareDSFieldMapping.Next() = 0;
            Enum::"EM Blocking Method"::Soundex:
                if EMCompareDSFieldMapping.FindSet() then
                    repeat
                        if Dataset1 then
                            BlockingKey += CalculateSoundexBlockingKey(SourceRecordref.Field(EMCompareDSFieldMapping."Dataset 1 Field No."))
                        else
                            BlockingKey += CalculateSoundexBlockingKey(SourceRecordref.Field(EMCompareDSFieldMapping."Dataset 2 Field No."));
                    until EMCompareDSFieldMapping.Next() = 0;
            Enum::"EM Blocking Method"::SLK:
                begin
                    if EMCompareDSFieldMapping.FindSet() then
                        repeat
                            if Dataset1 then
                                case EMCompareDSFieldMapping."SLK Field Type" of
                                    Enum::"EM SLK Field Type"::"Family Name":
                                        FieldRefFamilyName := SourceRecordref.Field(EMCompareDSFieldMapping."Dataset 1 Field No.");
                                    Enum::"EM SLK Field Type"::"First Name":
                                        FieldRefFirstName := SourceRecordref.Field(EMCompareDSFieldMapping."Dataset 1 Field No.");
                                    Enum::"EM SLK Field Type"::"Date of Birth":
                                        FieldRefDoB := SourceRecordref.Field(EMCompareDSFieldMapping."Dataset 1 Field No.");
                                    Enum::"EM SLK Field Type"::Gender:
                                        FieldRefGender := SourceRecordref.Field(EMCompareDSFieldMapping."Dataset 1 Field No.");
                                end
                            else
                                case EMCompareDSFieldMapping."SLK Field Type" of
                                    Enum::"EM SLK Field Type"::"Family Name":
                                        FieldRefFamilyName := SourceRecordref.Field(EMCompareDSFieldMapping."Dataset 2 Field No.");
                                    Enum::"EM SLK Field Type"::"First Name":
                                        FieldRefFirstName := SourceRecordref.Field(EMCompareDSFieldMapping."Dataset 2 Field No.");
                                    Enum::"EM SLK Field Type"::"Date of Birth":
                                        FieldRefDoB := SourceRecordref.Field(EMCompareDSFieldMapping."Dataset 2 Field No.");
                                    Enum::"EM SLK Field Type"::Gender:
                                        FieldRefGender := SourceRecordref.Field(EMCompareDSFieldMapping."Dataset 2 Field No.");
                                end
                        until EMCompareDSFieldMapping.Next() = 0;
                    BlockingKey := CalculateSLKBlockingKey(FieldRefFamilyName, FieldRefFirstName, FieldRefDoB, FieldRefGender);
                end;
        end;
        //TODO Canopy Clustering as additional Blocking Option
        exit(BlockingKey);
    end;

    local procedure CreateBlockingKeyForDataset(TableNo: Integer; EMCompareDatasets: Record "EM Compare Datasets"; var EMCompareDSFieldMapping: Record "EM Compare DS Field Mapping"; Dataset1: Boolean)
    var
        SourceRecordRef: RecordRef;
        BlockingKey: Text;
    begin
        SourceRecordRef.Open(TableNo);
        if SourceRecordRef.FindSet() then
            repeat
                HandleBlockingForRecord(EMCompareDatasets, SourceRecordRef, EMCompareDSFieldMapping, Dataset1);
            until SourceRecordRef.Next() = 0;
    end;

    local procedure ModifyBlockingBufferEntry(SourceRecordRef: RecordRef; BlockingMehtod: Enum "EM Blocking Method"; NewBlockingKey: Text)
    var
        EMCompareDSBlockingBuff: Record "EM Compare DS Blocking Buff.";
    begin
        if not EMCompareDSBlockingBuff.Get(BlockingMehtod, SourceRecordRef.Number, SourceRecordRef.RecordId) then
            exit;
        if NewBlockingKey = EMCompareDSBlockingBuff."Blocking Key" then
            exit;

        EMCompareDSBlockingBuff.Validate("Blocking Key", NewBlockingKey);
        EMCompareDSBlockingBuff.Modify(true);
    end;

    procedure ExistsBlockingBufferEntryForRecordRef(SourceRecordRef: RecordRef; BlockingMehtod: Enum "EM Blocking Method"): Boolean
    var
        EMCompareDSBlockingBuff: Record "EM Compare DS Blocking Buff.";
    begin
        EMCompareDSBlockingBuff.Reset();
        EMCompareDSBlockingBuff.SetRange("Blocking Method", BlockingMehtod);
        EMCompareDSBlockingBuff.SetRange("Dataset Table No.", SourceRecordRef.Number);
        EMCompareDSBlockingBuff.SetRange("DataSet Record Id", SourceRecordRef.RecordId);
        exit(not EMCompareDSBlockingBuff.IsEmpty);
    end;

    local procedure CalculateSimpleBlockingKey(SourceFieldref: FieldRef): Text
    begin
        exit(Format(SourceFieldref.Value));
    end;

    local procedure CalculateSoundexBlockingKey(SourceFieldref: FieldRef) BlockingKey: Text
    var
        EMSoundexBlockingValues: Record "EM Soundex Blocking Values";
        TextValue: Text;
        SoundexCoding: array[4] of Text[1];
        SoundexIndex: Integer;
        c: Text[1];
    begin
        TextValue := Format(SourceFieldref.Value);
        SoundexIndex := 1;

        repeat
            c := GetSingleCharacterOfStringFromLeftToRight(TextValue);
            if SoundexIndex = 1 then begin
                SoundexCoding[SoundexIndex] := c.ToUpper();
                SoundexIndex += 1;
            end else
                if EMSoundexBlockingValues.Get(c.ToLower()) then
                    if SoundexCoding[SoundexIndex - 1] <> EMSoundexBlockingValues.Value then begin
                        SoundexCoding[SoundexIndex] := EMSoundexBlockingValues.Value;
                        SoundexIndex += 1;
                    end;
        until (SoundexIndex > ArrayLen(SoundexCoding)) or (StrLen(TextValue) = 0);

        while SoundexIndex <= ArrayLen(SoundexCoding) do begin
            SoundexCoding[SoundexIndex] := '0';
            SoundexIndex += 1;
        end;

        for SoundexIndex := 1 to ArrayLen(SoundexCoding) do
            BlockingKey += SoundexCoding[SoundexIndex];

        exit(BlockingKey)
    end;

    local procedure GetSingleCharacterOfStringFromLeftToRight(var TextValue: Text) c: Text[1]
    begin
        c := CopyStr(TextValue, 1, 1);
        if c.ToUpper() = 'C' then
            if CopyStr(TextValue, 2, 1).ToUpper() = 'H' then begin
                c := '$';
                TextValue := CopyStr(TextValue, 3);
                exit;
            end;
        TextValue := CopyStr(TextValue, 2);
    end;

    local procedure CalculateSLKBlockingKey(SourceFieldrefFamilyName: FieldRef; SourceFieldrefFirstName: FieldRef; SourceFieldrefDateOfBirth: FieldRef; SourceFieldrefGender: FieldRef) SLKCoding: Text
    var
        NameCharIndexList: List of [Integer];
    begin
        //get Family Name SLKCoding - 2nd, 3rd and 5th character of the family name
        Clear(NameCharIndexList);
        NameCharIndexList.Add(2);
        NameCharIndexList.Add(3);
        NameCharIndexList.Add(5);
        SLKCoding += ConvertNameToSLK(Format(SourceFieldrefFamilyName.Value), NameCharIndexList);

        //get Family Name SLKCoding - 2nd, 3rd first name
        Clear(NameCharIndexList);
        NameCharIndexList.Add(2);
        NameCharIndexList.Add(3);
        SLKCoding += ConvertNameToSLK(Format(SourceFieldrefFirstName.Value), NameCharIndexList);

        SLKCoding += ConvertDateOfBirthToSLK(Format(SourceFieldrefDateOfBirth.Value));
        SLKCoding += ConvertGenderToSLK(Format(SourceFieldrefGender.Value));
    end;

    local procedure ConvertNameToSLK(Name: Text; IndexList: List of [Integer]) SLKCoding: Text
    var
        i: Integer;
        c: Text[1];
    begin
        if Name = '' then begin
            for i := 1 to IndexList.Count do
                SLKCoding += '9';
            exit(SLKCoding)
        end;

        i := 1;
        Name := DelChr(Name, '=', ' |-|?|!|#|+');
        repeat
            c := GetSingleCharacterOfStringFromLeftToRight(Name);
            if IndexList.Contains(i) then
                SLKCoding += c;
            i += 1;
        until (StrLen(Name) = 0) or (StrLen(SLKCoding) = IndexList.Count);

        while StrLen(SLKCoding) < IndexList.Count do
            SLKCoding += '2';

        exit(SLKCoding)
    end;

    local procedure ConvertGenderToSLK(gender: Text): Text
    begin
        if not (gender.ToLower() in ['male', 'female']) then
            exit('9');
        if gender.ToLower() = 'female' then
            exit('2')
        else
            exit('1');
    end;

    local procedure ConvertDateOfBirthToSLK(DateOfBirth: Text): Text
    begin
        if DateOfBirth = '' then
            exit('UUU');
        exit(Format(DateOfBirth, 0, '<Day,2><Month,2><Year,4>'))
    end;

    local procedure HandleBlockingForRecord(EMCompareDatasets: Record "EM Compare Datasets"; SourceRecordRef: RecordRef; var EMCompareDSFieldMapping: Record "EM Compare DS Field Mapping"; Dataset1: Boolean)
    var
        EMCompareDSBlockingBuff: Record "EM Compare DS Blocking Buff.";
        SourceRecRefModifiedAtDateTime: DateTime;
        BlockingKey: Text;
    begin
        if not EMCompareDSBlockingBuff.Get(EMCompareDatasets."Blocking Method", SourceRecordRef.Number, SourceRecordRef.RecordId) then
            CreateBlockingBufferEntries(
                SourceRecordRef.Number,
                SourceRecordRef.RecordId,
                CalculateBlockingKey(EMCompareDatasets."Blocking Method", SourceRecordRef, EMCompareDSFieldMapping, Dataset1),
                EMCompareDatasets."Blocking Method"
            )
        else begin
            Evaluate(SourceRecRefModifiedAtDateTime, SourceRecordRef.Field(SourceRecordRef.SystemModifiedAtNo).Value);
            if EMCompareDSBlockingBuff.SystemModifiedAt < SourceRecRefModifiedAtDateTime then
                ModifyBlockingBufferEntry(SourceRecordRef, EMCompareDatasets."Blocking Method", CalculateBlockingKey(EMCompareDatasets."Blocking Method", SourceRecordRef, EMCompareDSFieldMapping, Dataset1));
        end;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::GlobalTriggerManagement, 'OnAfterOnDatabaseModify', '', false, false)]
    local procedure OnAfterOnDatabaseModify(RecRef: RecordRef)
    var
        EMCompareDatasets: Record "EM Compare Datasets";
        EMCompareDSFieldMapping: Record "EM Compare DS Field Mapping";
        Dataset1: Boolean;
    begin
        Dataset1 := true;
        EMCompareDatasets.Reset();
        EMCompareDatasets.SetRange("Dataset 1 Table No.", RecRef.Number);
        if EMCompareDatasets.IsEmpty() then begin
            EMCompareDatasets.Reset();
            EMCompareDatasets.SetRange("Dataset 2 Table No.", RecRef.Number);
            Dataset1 := false;
        end;

        if not EMCompareDatasets.FindSet() then
            exit;

        repeat
            EMCompareDatasets.FilterFieldMappingBlocking(EMCompareDSFieldMapping);
            if not EMCompareDSFieldMapping.IsEmpty() then
                HandleBlockingForRecord(EMCompareDatasets, RecRef, EMCompareDSFieldMapping, Dataset1);
        until EMCompareDatasets.Next() = 0;
    end;


}


