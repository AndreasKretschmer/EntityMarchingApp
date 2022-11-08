codeunit 77001 "EM Blocking Management"
{
    procedure CreateBlockingBufferEntries(CompareDSEntryNo: Integer; TableNo: Integer; SourceRecordId: RecordId; BlockingKey: Text)
    var
        EMCompareDSBlockingBuff: Record "EM Compare DS Blocking Buff.";
    begin
        EMCompareDSBlockingBuff.Init();
        EMCompareDSBlockingBuff.Validate("Compare Dataset Entry No.", CompareDSEntryNo);
        EMCompareDSBlockingBuff.Validate("Dataset Table No.", TableNo);
        EMCompareDSBlockingBuff.Validate("DataSet Record Id", SourceRecordId);
        EMCompareDSBlockingBuff.Validate("Blocking Key", CopyStr(BlockingKey, 1, MaxStrLen(EMCompareDSBlockingBuff."Blocking Key")));
        EMCompareDSBlockingBuff.Insert(true);
    end;

    procedure CalculateBlockingKeys(BlockingMethod: Enum "EM Blocking Method"; SourceRecordref: RecordRef; var EMCompareDSFieldMapping: Record "EM Compare DS Field Mapping"; Dataset1: Boolean) BlockingKey: Text;
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
                exit(CalculateSLKBlockingKey(SourceRecordref));
        //TODO Canopy Clustering as additional Blocking Option
        end;

        exit(BlockingKey);
    end;

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

    local procedure CreateBlockingKeyForDataset(TableNo: Integer; EMCompareDatasets: Record "EM Compare Datasets"; var EMCompareDSFieldMapping: Record "EM Compare DS Field Mapping"; Dataset1: Boolean)
    var
        SourceRecordRef: RecordRef;
    begin
        SourceRecordRef.Open(TableNo);
        if SourceRecordRef.FindSet() then
            repeat
                //TODO Maybe the Blocking Key should be updated, if the SourceRecord was modified
                if not ExistsBlockingBufferEntryForRecordRef(SourceRecordRef, EMCompareDatasets."Entry No.") then begin
                    CreateBlockingBufferEntries(
                        EMCompareDatasets."Entry No.",
                        SourceRecordRef.Number,
                        SourceRecordRef.RecordId,
                        CalculateBlockingKeys(EMCompareDatasets."Blocking Method", SourceRecordRef, EMCompareDSFieldMapping, Dataset1)
                    );
                end;
            until SourceRecordRef.Next() = 0;
    end;

    procedure ExistsBlockingBufferEntryForRecordRef(SourceRecordRef: RecordRef; EntryNo: Integer): Boolean
    var
        EMCompareDSBlockingBuff: Record "EM Compare DS Blocking Buff.";
    begin
        EMCompareDSBlockingBuff.Reset();
        EMCompareDSBlockingBuff.SetRange("Compare Dataset Entry No.", EntryNo);
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
            c := CopyStr(TextValue, 1, 1);
            TextValue := CopyStr(TextValue, 2);
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

    local procedure CalculateSLKBlockingKey(SourceRecordref: RecordRef): Code[50]
    begin
        //TODO Implement SLK Blocking (Maybe additionl checks have to made previously, due to SLK Blocking only support person data)
    end;
}
