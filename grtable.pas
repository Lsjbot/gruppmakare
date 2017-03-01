unit grtable;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls,grmain;

type
  TFormTable = class(TForm)
    StringGrid1: TStringGrid;
    Button1: TButton;
    procedure Init;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormTable: TFormTable;

implementation

{$R *.DFM}

procedure TFormTable.Init;
var i,j,k:integer;
begin
  with StringGrid1 do
    begin
      RowCount := nstud+ngroup+1;
      Cells[0,0] := 'Namn';
      Cells[1,0] := 'Pnr';
      Cells[2,0] := 'Grupp';
      Cells[3,0] := 'Kön';
      Cells[4,0] := 'Ort';
      Cells[5,0] := 'Ingång';
      Cells[6,0] := 'Faktor 1';
      Cells[7,0] := 'Faktor 2';
      Cells[8,0] := 'Faktor 3';

      k := 1;
      for i := 1 to ngroup do
       begin
        for j := 1 to group[i].nmem do
          with stud[group[i].mem[j]] do
            begin
              Cells[0,k] := name;
              Cells[1,k] := pnr;
              Cells[2,k] := inttostr(i);
              Cells[3,k] := sex;
              Cells[4,k] := town;
              Cells[5,k] := entry;
              Cells[6,k] := f1;
              Cells[7,k] := f2;
              Cells[8,k] := f3;
              k := k+1;
            end;
          Cells[0,k] := '';
          Cells[1,k] := '';
          Cells[2,k] := '';
          Cells[3,k] := '';
          Cells[4,k] := '';
          Cells[5,k] := '';
          Cells[6,k] := '';
          Cells[7,k] := '';
          Cells[8,k] := '';
          k:= k+1
       end;
    end;
end;

procedure TFormTable.Button1Click(Sender: TObject);
begin
  Close;
end;

end.
