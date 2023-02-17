table 77001 "EM Soundex Blocking Values"
{
    Caption = 'Soundex Blocking Values';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Character; Text[1])
        {
            Caption = 'Character';
            DataClassification = CustomerContent;
        }
        field(2; "Language Code"; Code[20])
        {
            Caption = 'Language Code';
            TableRelation = Language.Code;
            DataClassification = CustomerContent;
        }
        field(10; "Value"; Text[1])
        {
            Caption = 'Value';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; Character, "Language Code")
        {
            Clustered = true;
        }
    }
}
