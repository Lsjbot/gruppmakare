unit grcrit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,grmain;

type
  TFormCrit = class(TForm)
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    sbAge: TScrollBar;
    cbAgeAlone: TCheckBox;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    sbSex: TScrollBar;
    cbSexAlone: TCheckBox;
    Label8: TLabel;
    Label12: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    cbAgeSame: TCheckBox;
    cbSexSame: TCheckBox;
    Label18: TLabel;
    sbTown: TScrollBar;
    cbTownAlone: TCheckBox;
    cbTownSame: TCheckBox;
    Label19: TLabel;
    sbIn: TScrollBar;
    cbInAlone: TCheckBox;
    cbInSame: TCheckBox;
    lb1: TLabel;
    sb1: TScrollBar;
    cb1Alone: TCheckBox;
    cb1Same: TCheckBox;
    lb2: TLabel;
    sb2: TScrollBar;
    cb2Alone: TCheckBox;
    cb2Same: TCheckBox;
    lb3: TLabel;
    sb3: TScrollBar;
    cb3Alone: TCheckBox;
    cb3Same: TCheckBox;
    Label1: TLabel;
    OKButton: TButton;
    cbAgeNum: TCheckBox;
    Label2: TLabel;
    Label3: TLabel;
    cbTownNum: TCheckBox;
    cbInnum: TCheckBox;
    cb1Num: TCheckBox;
    cb2Num: TCheckBox;
    cb3Num: TCheckBox;
    procedure Init(var line:string);
    procedure OKButtonClick(Sender: TObject);
    procedure cbAgeNumClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormCrit: TFormCrit;
  header: array[1..10] of string;

implementation

{$R *.DFM}

procedure Unblank(var s:string);
begin
  while (length(s) > 0 ) and ( s[1] = ' ') do
    delete(s,1,1);
  while (length(s) > 0 ) and ( s[length(s)] = ' ') do
    delete(s,length(s),1);
end; (* Unblank *)


procedure TFormCrit.Init(var line:string);
var i,j,k : integer;
begin
      for i := 1 to 10 do
        header[i] := 'xxx';
      k := 0;
      repeat
        begin
          j := pos(';',line);
          if ( j = 0 ) then
            j := length(line)+1;
          k := k+1;
          header[k] := Copy(line,1,j-1);
          Unblank(header[k]);
          Delete(line,1,j);
        end;
      until ( length(line) = 0 ) or ( k >= 10 );
      if Header[5] = 'xxx' then
        begin
          lb1.Visible := false;
          sb1.Visible := false;
          cb1Same.Visible := false;
          cb1Alone.Visible := false;
        end
      else
        lb1.Caption := Header[5];
      if Header[6] = 'xxx' then
        begin
          lb2.Visible := false;
          sb2.Visible := false;
          cb2Same.Visible := false;
          cb2Alone.Visible := false;
        end
      else
        lb2.Caption := Header[6];
      if Header[7] = 'xxx' then
        begin
          lb3.Visible := false;
          sb3.Visible := false;
          cb3Same.Visible := false;
          cb3Alone.Visible := false;
        end
      else
        lb3.Caption := Header[7];
end;

procedure TFormCrit.OKButtonClick(Sender: TObject);
var i,j,cmax,cmin:integer;
begin
  ncrit := 0;
  with crit[1] do
    begin
      name := 'Ålder';
      weight := sbAge.Position;
      if weight = 100 then
        weight := 1000;
      if weight > 0 then
        ncrit := 1;
      same := cbAgeSame.Checked;
      alone := cbAgeAlone.Checked;
      num := cbAgeNum.Checked;
    end;
  with crit[2] do
    begin
      name := 'Kön';
      weight := sbSex.Position;
      if weight = 100 then
        weight := 1000;
      if weight > 0 then
        ncrit := 2;
      same := cbSexSame.Checked;
      alone := cbSexAlone.Checked;
      num := false;
    end;
  with crit[3] do
    begin
      name := 'Ort';
      weight := sbTown.Position;
      if weight = 100 then
        weight := 1000;
      if weight > 0 then
        ncrit := 3;
      same := cbTownSame.Checked;
      alone := cbTownAlone.Checked;
      num := cbTownNum.Checked;
    end;
  with crit[4] do
    begin
      name := 'Ingång';
      weight := sbIn.Position;
      if weight = 100 then
        weight := 1000;
      if weight > 0 then
        ncrit := 4;
      same := cbInSame.Checked;
      alone := cbInAlone.Checked;
      num := cbInNum.Checked;
    end;
  with crit[5] do
    begin
      name := lb1.Caption;
      weight := sb1.Position;
      if weight = 100 then
        weight := 1000;
      if weight > 0 then
        ncrit := 5;
      same := cb1Same.Checked;
      alone := cb1Alone.Checked;
      num := cb1Num.Checked;
    end;
  with crit[6] do
    begin
      name := lb2.Caption;
      weight := sb2.Position;
      if weight = 100 then
        weight := 1000;
      if weight > 0 then
        ncrit := 6;
      same := cb2Same.Checked;
      alone := cb2Alone.Checked;
      num := cb2Num.Checked;
    end;
  with crit[7] do
    begin
      name := lb3.Caption;
      weight := sb3.Position;
      if weight = 100 then
        weight := 1000;
      if weight > 0 then
        ncrit := 7;
      same := cb3Same.Checked;
      alone := cb3Alone.Checked;
      num := cb3Num.Checked;
    end;

  for j := 1 to ncrit do
    with crit[j] do
      if num then
        begin
          cmax := -999999;
          cmin := 999999;
          for i := 1 to nstud do
            if stud[i].cat[j] < cmin then
              cmin := stud[i].cat[j]
            else if stud[i].cat[j] > cmax then
              cmax := stud[i].cat[j];
          range := cmax-cmin;
        end;

  Close;

end;

procedure TFormCrit.cbAgeNumClick(Sender: TObject);
var kstud:integer;
begin
  if cbAgeNum.Checked then
    for kstud := 1 to nstud do
      Stud[kstud].cat[1] := stud[kstud].age
  else
    if ( stud[kstud].age < 22 ) then
      stud[kstud].cat[1] := 1
    else if ( stud[kstud].age < 30 ) then
      stud[kstud].cat[1] := 2
    else
      stud[kstud].cat[1] := 3;

end;

end.
