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
        field(2; "Value"; Text[1])
        {
            Caption = 'Value';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; Character)
        {
            Clustered = true;
        }
    }
}
