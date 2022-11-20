table 77010 "EM Example Dataset 1"
{
    Caption = 'Example Dataset 1';
    DataClassification = CustomerContent;
    LookupPageId = "EM Example Dataset 1";
    DrillDownPageId = "EM Example Dataset 1";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(2; "First Name"; Text[100])
        {
            Caption = 'First Name';
            DataClassification = CustomerContent;
        }
        field(3; "Middle Name"; Text[100])
        {
            Caption = 'Middle Name';
            DataClassification = CustomerContent;
        }
        field(4; "Last Name"; Text[100])
        {
            Caption = 'Last Name';
            DataClassification = CustomerContent;
        }
        field(5; Gender; Code[10])
        {
            Caption = 'Gender';
            DataClassification = CustomerContent;
        }
        field(6; Age; Integer)
        {
            Caption = 'Age';
            DataClassification = CustomerContent;
        }
        field(7; "Birth Date"; Text[20])
        {
            Caption = 'Birth Date';
            DataClassification = CustomerContent;
        }
        field(8; Address; Text[250])
        {
            Caption = 'Address';
            DataClassification = CustomerContent;
        }
        field(9; "Address 2"; Text[250])
        {
            Caption = 'Address 2';
            DataClassification = CustomerContent;
        }
        field(10; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            DataClassification = CustomerContent;
        }
        field(11; County; Text[50])
        {
            Caption = 'County';
            DataClassification = CustomerContent;
        }
        field(12; "Phone No."; Text[100])
        {
            Caption = 'Phone No.';
            DataClassification = CustomerContent;
        }
        field(13; "E-Mail"; Text[250])
        {
            Caption = 'E-Mail';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
