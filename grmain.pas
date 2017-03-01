unit grmain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

const
  maxmem = 150;
  maxgrp = 200;
  maxstud = 600;

type
  TCrit = record
            name:string;
            weight : integer;
            same : boolean;
            alone : boolean;
            num:boolean;
            range : integer;
  end;

  PTree = ^Ttree;
  Ttree = record
            name:string;
            catnum : integer;
            next,prev: Ptree;
          end;

  TStud = record
            name  :string;
            sex   :char;
            pnr : string;
            town  :string;
            year  :integer;
            age   :integer;
            entry :string;
            f1,f2,f3 :string;
            cat:array[1..7] of integer;
            group : integer;
  end;

  PStud = ^TStud;

  TGroup = record
             nmem : integer;
             mem : array[1..maxmem] of integer;
             chi2 : integer;
  end;

  TForm1 = class(TForm)
    OpenButton: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    OpenDialog1: TOpenDialog;
    RunButton: TButton;
    CritButton: TButton;
    SaveButton: TButton;
    Button1: TButton;
    Memo1: TMemo;
    Label1: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    edAntal: TEdit;
    edStorlek: TEdit;
    SaveDialog1: TSaveDialog;
    TableButton: TButton;
    Label11: TLabel;
    sbVargroup: TScrollBar;
    Label12: TLabel;
    Label13: TLabel;
    procedure OpenButtonClick(Sender: TObject);
    procedure Msg(line:string);
    procedure CritButtonClick(Sender: TObject);
    procedure edStorlekChange(Sender: TObject);
    procedure edAntalChange(Sender: TObject);
    procedure Unblank(var s:string);
    procedure Button1Click(Sender: TObject);
    procedure RunButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure TableButtonClick(Sender: TObject);
    procedure MoveMember(gf,gt,mf:integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;



var
  Form1: TForm1;
  Fin,Fout: textfile;
  line,s1,s2:string;
    crit : array[1..10] of TCrit;
    stud : array[1..maxstud] of TStud;
    group,bestgroup : array[1..maxgrp] of TGroup;
    nstud : integer;
    ngstud,ngroup : integer;
    fmax : integer;
    saved,vargroup : boolean;
    ncrit : integer;
    root:array[1..10] of Ttree;
    ncat : array[1..10] of integer;


implementation

uses grcrit, grtable;

{$R *.DFM}

procedure addtotree(s:string;var t:Ttree;var nc:integer);
begin
  (*Form1.Msg(s+', '+t.name);*)
  if ( s < t.name ) then
    begin
      if t.prev = nil then
        begin
          new(t.prev);
          nc := nc+1;
          with t.prev^ do
            begin
              name := s;
              next := nil;
              prev := nil;
              catnum := nc;
            end
        end
      else
        addtotree(s,t.prev^,nc);
    end
  else if ( s > t.name ) then
    begin
      if t.next = nil then
        begin
          new(t.next);
          nc := nc+1;
          with t.next^ do
            begin
              name := s;
              next := nil;
              prev := nil;
              catnum := nc;
            end
        end
      else
        addtotree(s,t.next^,nc);
    end
  else
    nc := -t.catnum;
end; (* addtotree *)

procedure chicalc(var g:TGroup);
var i,j,k,mj,mk,delta: integer;
    unique:boolean;
begin
  with g do
    begin
      chi2 := 0;
      for i := 1 to ncrit do
        with crit[i] do
          if weight > 0 then
            begin
              for j := 1 to nmem-1 do
                begin
                  mj := mem[j];
                  unique := true;
                  for k := j+1 to nmem do
                    begin
                      mk := mem[k];
                      if stud[mj].cat[i] = stud[mk].cat[i] then
                        begin
                          unique := false;
                          if not same then
                            chi2 := chi2 + weight;
                        end
                      else if num then
                        begin
                          delta := stud[mj].cat[i]-stud[mk].cat[i];
                          if same then
                            chi2 := chi2 + delta*delta*weight div range
                          else
                            chi2 := chi2 + (delta-range)*(delta-range)*weight div range;
                        end
                      else if same then
                        chi2 := chi2 + weight;
                    end;
                  if alone and unique then
                    chi2 := chi2+5000;
                end;
            end;
    end;
end; (* chicalc *)

procedure TForm1.Unblank(var s:string);
begin
  while (length(s) > 0 ) and ( s[1] = ' ') do
    delete(s,1,1);
  while (length(s) > 0 ) and ( s[length(s)] = ' ') do
    delete(s,length(s),1);
end; (* Unblank *)

procedure TForm1.Msg(line:string);
begin
  Memo1.Lines.Add(line);
end;

procedure TForm1.OpenButtonClick(Sender: TObject);
var i,j,k,kstud,age : integer;
    y,m,d : word;
    ss: array[1..10] of string;
    s1,s2 : string;
    c:char;
    ok : boolean;
begin
  if OpenDialog1.Execute then
    begin
      {$I-}
      Assignfile(Fin,Opendialog1.Filename);
      Msg('Fil : '+Opendialog1.Filename);
      FileMode := 0;  { Set file access to read only }
      Reset(Fin);
      {$I+}
      readln(Fin,line);
      Msg(line);
      FormCrit.Init(line);
      CritButton.Enabled := true;
      DecodeDate(Date,y,m,d);
      Msg('Year = '+inttostr(y));
      for i := 1 to 10 do
        begin
          ncat[i] := 0;
          root[i].name := 'M';
          root[i].catnum := 0;
          root[i].prev := nil;
          root[i].next := nil;
        end;
      for i := 1 to maxstud do
        begin
          stud[i].name := '(vakant)';
          stud[i].town := '';
          stud[i].entry := '';
          stud[i].sex := ' ';
          stud[i].f1 := '';
          stud[i].f2 := '';
          stud[i].f3 := '';
          stud[i].year := -1;
        end;
      fmax := 0;
      kstud := 1;
      nstud := 0;
      while not eof(Fin) do
        begin
          readln(Fin,line);
          for i := 1 to 10 do
            ss[i] := 'xxx';
          ok := true;
          k := 0;
          repeat
            begin
              j := pos(';',line);
              if ( j = 0 ) then
                j := length(line)+1;
              k := k+1;
              ss[k] := Copy(line,1,j-1);
              Unblank(ss[k]);
              Delete(line,1,j);
            end;
          until ( length(line) = 0 ) or ( k >= 10 );
          if ( k-1 > fmax ) then
            fmax := k-1;
          if ss[1] = 'xxx' then
            ok := false
          else
            begin
              stud[kstud].name := ss[1];
              stud[kstud].pnr := ss[2];
              stud[kstud].town := ss[3];
              stud[kstud].entry:= ss[4];
              stud[kstud].f1 := ss[5];
              stud[kstud].f2 := ss[6];
              stud[kstud].f3 := ss[7];
              for i := 3 to 7 do
                begin
                  k := ncat[i];
                  addtotree(ss[i],root[i],k);
                  if ( k > 0 ) then
                    ncat[i] := k;
                  (*Msg('Cat = '+inttostr(k));*)
                  stud[kstud].cat[i] := abs(k);
                end;
              if ( length(ss[2]) < 10 ) then
                ok := false
              else
                begin
                  s1 := copy(ss[2],1,2);
                  stud[kstud].year := StrToInt(s1);
                  if ( stud[kstud].year > 20 ) then
                    stud[kstud].year := stud[kstud].year+1900
                  else
                    stud[kstud].year := stud[kstud].year+2000;
                  stud[kstud].age := y - stud[kstud].year;
                  if ( stud[kstud].age < 22 ) then
                    stud[kstud].cat[1] := 1
                  else if ( stud[kstud].age < 30 ) then
                    stud[kstud].cat[1] := 2
                  else
                    stud[kstud].cat[1] := 3;
                  c := ss[2][length(ss[2])-1];
                  if ( c in ['1','3','5','7','9'] ) then
                    begin
                      stud[kstud].sex := 'M';
                      stud[kstud].cat[2] := 0;
                    end
                  else if ( c in ['2','4','6','8','0'] ) then
                    begin
                      stud[kstud].sex := 'F';
                      stud[kstud].cat[2] := 1;
                    end
                  else
                    ok := false;
                  s1 := stud[kstud].name;
                  while ( length(s1) < 22 ) do
                    s1 := s1 + ' ';
                  s1 := s1+', cat: ';
                  for i := 1 to 7 do
                    s1 := s1+inttostr(stud[kstud].cat[i]);
                  Msg(s1);
                end;
            end;
          if ok then
            kstud := kstud + 1;
        end;
      nstud := kstud-1;
      Msg('nstud  = '+inttostr(nstud));
      Closefile(Fin);
    end;
  saved := true;
end; (* OpenButtonClick *)

procedure TForm1.CritButtonClick(Sender: TObject);
begin
  FormCrit.Show;
  edAntal.Enabled := true;
  edStorlek.Enabled := true;
end;

procedure TForm1.edStorlekChange(Sender: TObject);
begin
  if ( length(edStorlek.text) > 0 ) then
    if ( edStorlek.text[1] in ['0'..'9'] ) then
      begin
        edAntal.text := '(antal)';
        ngstud := StrToInt(edStorlek.text);
        ngroup := nstud div ngstud;
        if ( nstud > ngstud*ngroup ) then
          ngstud := ngstud+1;
        RunButton.Enabled := true;
        Msg('ngstud = '+inttostr(ngstud));
        Msg('nstud  = '+inttostr(nstud));
        Msg('ngroup = '+inttostr(ngroup));
      end;
end;

procedure TForm1.edAntalChange(Sender: TObject);
begin
  if ( length(edAntal.text) > 0 ) then
    if ( edAntal.text[1] in ['0'..'9'] ) then
      begin
        edStorlek.text := '(storlek)';
        ngroup := StrToInt(edAntal.text);
        ngstud := nstud div ngroup;
        if ( nstud > ngstud*ngroup ) then
          ngstud := ngstud+1;
        RunButton.Enabled := true;
        Msg('ngstud = '+inttostr(ngstud));
        Msg('nstud  = '+inttostr(nstud));
        Msg('ngroup = '+inttostr(ngroup));
      end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if saved or (MessageDlg('Du har inte sparat resultatet.  Vill du verkligen avsluta?',
    mtError, [mbYes, mbNo], 0) = mrYes) then
      Close;
end;

procedure TForm1.RunButtonClick(Sender: TObject);
var i,j,k,kk,ksame,iloop : integer;
     ig,igg,rg,igs,g1,g2,m1,m2,s1,s2,c1,c2,nm1,nm2 : integer;
     chitot,chiold,maxchi,minchi,nchi,vgrange : integer;
begin
Cursor := crHourglass;
minchi := -1;
vargroup := ( sbVarGroup.Position > 0 );
if vargroup then
  begin
    vgrange := sbVarGroup.Position;
    if ( vgrange = sbVarGroup.Max ) then
      vgrange := 999;
  end;
iloop := 0;
while iloop < 10 do
 begin
  i := 1;
  for ig := 1 to ngroup do
    group[ig].nmem := 0;
  for igs := 1 to ngstud do
    begin
      rg := Random(ngroup);
      for igg := 1 to ngroup do
        begin
          ig := igg+rg;
          if ( ig > ngroup ) then
            ig := ig-ngroup;
          group[ig].mem[igs] := i;
          i := i+1;
          if ( i <= nstud ) then
            group[ig].nmem := group[ig].nmem+1;
        end;
    end;
  chitot := 0;
  maxchi := 0;
  for ig := 1 to ngroup do
    begin
      chicalc(group[ig]);
      chitot := chitot + group[ig].chi2;
      (*Msg(inttostr(ig)+': chi2 = '+inttostr(group[ig].chi2));*)
    end;
  Msg('chi2 = '+inttostr(chitot));
  if minchi < 0 then
    minchi := chitot;
  Randomize;
  kk := 0;
  ksame := 0;
  repeat
    chiold := chitot;
    maxchi := 0;
    for ig := 1 to ngroup do
      if group[ig].chi2 > maxchi then
        begin
          nchi := ig;
          maxchi := group[ig].chi2;
        end;
    g2 := nchi;
    for m2 := 1 to group[nchi].nmem do
      for g1 := 1 to ngroup do
        if ( g1 <> g2 ) then
          begin
            m1 := Random(group[g1].nmem)+1;
            kk := kk+1;
            s1 := group[g1].mem[m1];
            s2 := group[g2].mem[m2];
            c1 := group[g1].chi2;
            c2 := group[g2].chi2;
            group[g1].mem[m1] := s2;
            group[g2].mem[m2] := s1;
            chicalc(group[g1]);
            chicalc(group[g2]);
            if ( group[g1].chi2 + group[g2].chi2 ) <= (c1+c2) then
              begin
                chitot := chitot -c1 - c2 + group[g1].chi2 + group[g2].chi2;
                if ( kk < 0 ) then
                  Msg('chinew,chiold = '+inttostr(group[g1].chi2 + group[g2].chi2)+inttostr(c1+c2)+'; better');
              end
            else
              begin
                group[g1].mem[m1] := s1;
                group[g2].mem[m2] := s2;
                group[g1].chi2 := c1;
                group[g2].chi2 := c2;
                if ( kk < 0 ) then
                  Msg('chinew,chiold = '+inttostr(group[g1].chi2 + group[g2].chi2)+inttostr(c1+c2)+'; worse');
              end;
          end;
    for i := 1 to nstud*nstud do
      begin
        g1 := Random(ngroup)+1;
        g2 := Random(ngroup)+1;
        m1 := Random(group[g1].nmem)+1;
        m2 := Random(group[g2].nmem)+1;
        if ( g1 <> g2 ) then
          begin
            kk := kk+1;
            s1 := group[g1].mem[m1];
            s2 := group[g2].mem[m2];
            c1 := group[g1].chi2;
            c2 := group[g2].chi2;
            group[g1].mem[m1] := s2;
            group[g2].mem[m2] := s1;
            chicalc(group[g1]);
            chicalc(group[g2]);
            if ( group[g1].chi2 + group[g2].chi2 ) <= (c1+c2) then
              begin
                chitot := chitot -c1 - c2 + group[g1].chi2 + group[g2].chi2;
                if ( kk < 0 ) then
                  Msg('chinew,chiold = '+inttostr(group[g1].chi2 + group[g2].chi2)+inttostr(c1+c2)+'; better');
              end
            else
              begin
                group[g1].mem[m1] := s1;
                group[g2].mem[m2] := s2;
                group[g1].chi2 := c1;
                group[g2].chi2 := c2;
                if ( kk < 0 ) then
                  Msg('chinew,chiold = '+inttostr(group[g1].chi2 + group[g2].chi2)+inttostr(c1+c2)+'; worse');
              end;
          end;
      end;
    if vargroup then
      begin
        for g1 := 1 to ngroup do
          if ( group[g1].nmem < ngstud+vgrange-1 ) then
            begin (* Consider adding a member *)
              nm1 := group[g1].nmem;
              for g2 := 1 to ngroup do
                if ( g1 <> g2 ) then
                 if ( group[g1].nmem = nm1 ) then
                  if ( group[g2].nmem > ngstud-vgrange-1 ) then
                    for m2 := 1 to group[g2].nmem do
                      begin
                        c1 := group[g1].chi2;
                        c2 := group[g2].chi2;
                        MoveMember(g2,g1,m2);
                        ChiCalc(group[g1]);
                        ChiCalc(group[g2]);
                        if ( group[g1].chi2 + group[g2].chi2 ) <= (c1+c2) then
                          begin
                            chitot := chitot -c1 - c2 + group[g1].chi2 + group[g2].chi2;
                            if ( kk < 0 ) then
                              Msg('chinew,chiold = '+inttostr(group[g1].chi2 + group[g2].chi2)+inttostr(c1+c2)+'; better');
                            break;
                          end
                        else
                          begin
                            j := group[g1].nmem;
                            MoveMember(g1,g2,j);
                            group[g1].chi2 := c1;
                            group[g2].chi2 := c2;
                          end;
                      end;
            end;
      end;
    Msg('chi2 = '+inttostr(chitot));
    if ( chiold = chitot ) then
      ksame := ksame+1
    else
      ksame := 0;
  until ksame > 2;

  iloop := iloop+1;
  Msg('Omlottning '+inttostr(iloop));

  if chitot < minchi then
    begin
      bestgroup := group;
      minchi := chitot;
      iloop := 0;
    end;
 end;

group := bestgroup;

Msg('Finished!');
Msg('Final chi2 = '+inttostr(minchi));
Cursor := crDefault;
SaveButton.Enabled := true;
TableButton.Enabled := true;
FormTable.Init;
FormTable.Show;

saved := false;

end; (* RunButtonclick *)

procedure TForm1.MoveMember(gf,gt,mf:integer);
var i,j:integer;
begin
  group[gt].nmem := group[gt].nmem+1;
  group[gt].mem[group[gt].nmem] := group[gf].mem[mf];

  if ( group[gf].nmem > mf ) then
    for i := mf+1 to group[gf].nmem do
      group[gf].mem[i-1] := group[gf].mem[i];
  group[gf].nmem := group[gf].nmem - 1;
end;

procedure TForm1.SaveButtonClick(Sender: TObject);
var i,j,k:integer;
    s:string;
begin
  s := OpenDialog1.Filename;
  Insert('_grp',s,length(S)-3);
  Savedialog1.Filename := s;
  if SaveDialog1.Execute then
    begin
      {$I-}
      Assignfile(Fout,Savedialog1.Filename);
      Msg('Fil : '+Savedialog1.Filename);
      Rewrite(Fout);
      {$I+}
      writeln(Fout,'Namn;Pnr;Grp;Kön;Ort;Ingång;...');
      for i := 1 to ngroup do
        for j := 1 to group[i].nmem do
          with stud[group[i].mem[j]] do
            writeln(Fout,name,';',pnr,';',i,';',sex,';',town,';',entry,';',f1,';',f2,';',f3);
      Closefile(Fout);
      saved := true;
    end;
end;

procedure TForm1.TableButtonClick(Sender: TObject);
begin
  FormTable.Show;
end;

end.
