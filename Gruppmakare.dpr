program Gruppmakare;

uses
  Forms,
  grmain in 'grmain.pas' {Form1},
  grcrit in 'grcrit.pas' {FormCrit},
  grtable in 'grtable.pas' {FormTable};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFormCrit, FormCrit);
  Application.CreateForm(TFormTable, FormTable);
  Application.Run;
end.
