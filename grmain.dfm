�
 TFORM1 0b  TPF0TForm1Form1Left� Top9Width-Height�CaptionGruppmakare
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style PixelsPerInch`
TextHeight TLabelLabel2Left�TopWidth� HeightCaptionFilen ska se ut s� h�r:
Font.ColorclBlackFont.Height�	Font.NameMS Sans Serif
Font.StylefsBoldfsUnderline 
ParentFont  TLabelLabel3Left�Top Width� HeightCaption:Namn;   Pnr;    Ort;  Ing�ng;   Faktor 1;  Faktor 2; .....  TLabelLabel4Left�Top0WidthJHeightCaption@Andersson Anna; 810101-0101; TRANEMO;  TISA; Blond; Bl��gd; ....  TLabelLabel5Left�Top@Width� HeightCaption+Bengtsson Beda; 820202-0202;  GNOSJ�; .....  TLabelLabel6Left�TopPWidth*HeightCaption.... etc ...  TLabelLabel7Left�TophWidthgHeightCaption?Be Excel spara som "semikolonavgr�nsad text", s� blir det r�tt!
Font.ColorclBlackFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont  TLabelLabel1LeftTop� Width:HeightCaptionSteg 3:
Font.ColorclBlackFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TLabelLabel8LeftpTop� Width� HeightCaptionSt�ll in antal grupper:
Font.ColorclBlackFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TLabelLabel9Left� Top� Width$HeightCaptioneller
Font.ColorclBlackFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TLabelLabel10LeftpTopWidth� HeightCaptionSt�ll in gruppstorlek
Font.ColorclBlackFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TLabelLabel11LeftpTop0Width� HeightCaption"Till�ten variation i gruppstorlek:  TLabelLabel12Left0Top0WidthHeightCaptionIngen  TLabelLabel13Left�Top0WidthHeightCaptionFri  TButton
OpenButtonLeftTopWidthiHeightQCaption%Steg 1: �ppna filen med studentlistan
Font.ColorclBlackFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontTabOrder OnClickOpenButtonClick  TButton	RunButtonLeftTopPWidth�HeightICaption$Steg 3: Skapa grupper (tar en stund)Enabled
Font.ColorclBlackFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontTabOrderOnClickRunButtonClick  TButton
CritButtonLeftTop� Width�HeightICaption2Steg 2: St�ll in kriterier f�r gruppsammans�ttningEnabled
Font.ColorclBlackFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontTabOrderOnClickCritButtonClick  TButton
SaveButtonLeftTop�Width�HeightICaptionSteg 4:  SparaEnabled
Font.ColorclBlackFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontTabOrderOnClickSaveButtonClick  TButtonButton1LeftTop Width�HeightICaptionSteg 5: Avsluta
Font.ColorclBlackFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontTabOrderOnClickButton1Click  TMemoMemo1LeftTop� Width� HeightY
ScrollBars
ssVerticalTabOrder  TEditedAntalLeft(Top� WidthyHeightTabOrderText(antal)OnChangeedAntalChange  TEdit	edStorlekLeft(TopWidthyHeightTabOrderText	(storlek)OnChangeedStorlekChange  TButtonTableButtonLeftTop Width� HeightICaptionTitta p� resultatetEnabled
Font.ColorclBlackFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontTabOrderOnClickTableButtonClick  
TScrollBar
sbVargroupLeftPTop0WidthyHeightMaxTabOrder	  TOpenDialogOpenDialog1
DefaultExtskvFileEditStylefsEditFilterSemikolon-avgr�nsad text|*.skv
InitialDir	c:\delphiLeft�Top  TSaveDialogSaveDialog1FileEditStylefsEditLeft�Top�   