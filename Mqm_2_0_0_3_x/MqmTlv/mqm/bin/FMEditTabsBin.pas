unit FMEditTabsBin;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CheckLst, ExtCtrls, UMTabCfg, Buttons , comctrls, Grids;

type
  TEditTabsBin = class(TForm)
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    StringgrdOrdTabs: TStringGrid;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure CheckListBox2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    m_BinCnfg : TBinTabsCfg;
    m_PControl : TPageControl;
    m_ListTabsCode : TStringList;
//    procedure AddBinsTabToStringGrid;
//    procedure DeleteTab(TbCod : Integer);
 //   procedure ActiveTab(TbCod : Integer);
 //   procedure CloseTab(TbCod : Integer);
  //  procedure DeleteCloseTabs;
  public
    m_ListTabToOpen : TStringList;
    constructor CreateEditTabs(AOwner : Tcomponent ; BinCnfg : TBinTabsCfg ; pgcMain : TPageControl);
  end;

implementation

uses
  gnugettext,
  UMBinTbs,
  UGglobal;
{$R *.DFM}

{ TEditTabsBin }

//----------------------------------------------------------------------------//

//procedure TEditTabsBin.AddBinsTabToStringGrid;
//var
//  I : Integer;
//  Tbs : TBinTabSheet;
//begin
//  for I := 0 to m_BinCnfg.p_GetTabsCount - 1 do
///  begin
    //m_BinCnfg.
    //Tbs := TBinTabSheet(m_PControl.Pages[I]);
    //begin
    //  StringgrdOrdTabs.Cells[0, Tbs.GetCode]

      //Tbs.Destroy;
      //Exit;
    //end;
//  end;



//  for I := 0 to m_BinCnfg.p_GetTabsCount - 1 do
//  begin
//    StringgrdOrdTabs.Cells[0, m_BinCnfg.GetTabName(I)]
//    CheckListBox1.Items.add(m_BinCnfg.GetTabName(I));
//    m_ListTabsCode.Add(IntTostr(m_BinCnfg.GetTabCode(I)));
//    CheckListBox2.Items.add(m_BinCnfg.GetTabName(I));
  //  if m_BinCnfg.GetTabView(m_BinCnfg.GetTabCode(I)) then
  //    CheckListBox1.Checked[I] := true
  //  else
  //    CheckListBox1.Checked[I] := false;
//  end;
//end;

//----------------------------------------------------------------------------//

constructor TEditTabsBin.CreateEditTabs(AOwner: Tcomponent; BinCnfg : TBinTabsCfg ; pgcMain : TPageControl);
begin
  inherited Create(AOwner);
  m_BinCnfg := BinCnfg;
  m_PControl := pgcMain;
  StringgrdOrdTabs.RowCount := m_PControl.PageCount;
end;

//----------------------------------------------------------------------------//

procedure TEditTabsBin.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
//  m_BinCnfg := nil;
  m_PControl := nil;
end;

//----------------------------------------------------------------------------//

procedure TEditTabsBin.FormCreate(Sender: TObject);
begin
  ScaleFormSize(Self, Screen.PixelsPerInch);
  TranslateComponent (self);
  m_ListTabsCode := TStringList.Create;
//  AddBinsTabToList
end;

//----------------------------------------------------------------------------//

procedure TEditTabsBin.CheckListBox2Click(Sender: TObject);
begin
{  if (CheckListBox2.Checked[(Sender as TCheckListBox).ItemIndex] = True) then
    CheckListBox1.ItemEnabled[(Sender as TCheckListBox).ItemIndex] := false
  else
    CheckListBox1.ItemEnabled[(Sender as TCheckListBox).ItemIndex] := true; }
end;

//----------------------------------------------------------------------------//

procedure TEditTabsBin.BitBtn1Click(Sender: TObject);
begin
//  DeleteCloseTabs;
end;

//----------------------------------------------------------------------------//

{procedure TEditTabsBin.DeleteTab(TbCod : Integer);
var
  J : Integer;
  Tbs : TBinTabSheet;
begin
  for J := 0 to m_PControl.PageCount - 1 do
  begin
    Tbs := TBinTabSheet(m_PControl.Pages[J]);
// mario    if Tbs.m_TabCode = TbCod then
    begin
      Tbs.Destroy;
      Exit;
    end;
  end;
end;      }

//----------------------------------------------------------------------------//

//procedure TEditTabsBin.DeleteCloseTabs;
//var
//  I : Integer;
//begin
{  for I := 0 to CheckListBox2.Items.Count - 1 do
  begin
    if CheckListBox2.Checked[I] then
    begin
      DeleteTab(StrToInt(m_ListTabsCode.Strings[I]));
     // m_BinCnfg.DeleteTabByCode(StrToInt(m_ListTabsCode.Strings[I]));
    end;
    if CheckListBox1.ItemEnabled[I] then
    begin
      if (CheckListBox1.Checked[I]) then
        ActiveTab(StrToInt(m_ListTabsCode.Strings[I]))
      else
        CloseTab(StrToInt(m_ListTabsCode.Strings[I]));
    end;
  end; }
//end;

//----------------------------------------------------------------------------//

{procedure TEditTabsBin.CloseTab(TbCod : Integer);
//var
//  i:   integer;
//  tbs: TBinTabSheet;
begin
{  for i := 0 to m_PControl.PageCount - 1 do
  begin
//    tbs := TBinTabSheet(m_PControl.Pages[I]);
// mario    if tbs.m_TabCode = TbCod then
    begin
// mario      if m_BinCnfg.GetTabView(tbs.m_TabCode) then
      begin
    //    m_BinCnfg.SetTabView(TbCod, false);
    //    tbs.Close;
    //    Exit
      end
    end
  end;
 }
//end;

//----------------------------------------------------------------------------//

{procedure TEditTabsBin.ActiveTab(TbCod : Integer);
var
  i:   integer;
//  tbs: TBinTabSheet;
begin
  for I := 0 to m_PControl.PageCount - 1 do
  begin
//    tbs := TBinTabSheet(m_PControl.Pages[I]);
// mario    if tbs.m_TabCode = TbCod then
    begin
// mario      if not m_BinCnfg.GetTabView(tbs.m_TabCode) then
      begin
   //     m_BinCnfg.SetTabView(TbCod, true);
   //     tbs.OpenTbs
      end;
      exit
    end
  end
end;      }

//----------------------------------------------------------------------------//

procedure TEditTabsBin.FormDestroy(Sender: TObject);
begin
  m_ListTabsCode.free;
end;

//----------------------------------------------------------------------------//
end.
