unit FMSearchAndFocuse;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, UMSchedContFunc, UMSchedList, StrUtils, UReShape,
  Vcl.ExtCtrls;

type
  TSearchAndFocuse = class(TForm)
    EditSearch: TEdit;
    BitBtn3: TcxButton;
    BitBtn2: TcxButton;
    BitBtn1: TcxButton;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtnFindNextClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EditSearchKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    m_BinColId : CBinColId;
    m_SearchByColumn : boolean;
    procedure FindUserRequest;
    procedure FindNextUserRequest;
    procedure FindColumnData;
    procedure FindNextColumnData;

    { Private declarations }
  public
    constructor CreateSearchFocuse(AOwner: TWinControl);
    constructor CreateSearchColumnFocuse(AOwner: TWinControl; ValToSearch : string; BinColId : CBinColId);
    function    GetStringForSearch : string;
    { Public declarations }
  end;

  procedure CreateSearchAndFocus(AOwner : TWinControl);
  procedure CreateSearchColumnFocuse(AOwner: TWinControl; ValToSearch : string; Title : string; BinColId : CBinColId);

implementation

{$R *.dfm}

uses UMBinTbs, UMSchedCont, UMObjCont,gnugettext,FMbin;

var
  SearchAndFocuse : TSearchAndFocuse;

//----------------------------------------------------------------------------//

procedure CreateSearchAndFocus(AOwner : TWinControl);
begin
  if not Assigned(SearchAndFocuse) then
  begin
    SearchAndFocuse := TSearchAndFocuse.CreateSearchFocuse(AOwner);
    SearchAndFocuse.formStyle := fsStayOnTop;
  end;
  SearchAndFocuse.Show;
  SearchAndFocuse.EditSearch.Text := '';
  SearchAndFocuse.m_SearchByColumn := false;
  SearchAndFocuse.Caption := _('Position for selected cell on Bin');
end;

//----------------------------------------------------------------------------//

procedure CreateSearchColumnFocuse(AOwner: TWinControl; ValToSearch : string; Title : string; BinColId : CBinColId);
begin
  if not Assigned(SearchAndFocuse) then
  begin
    SearchAndFocuse := TSearchAndFocuse.CreateSearchColumnFocuse(AOwner,ValToSearch,BinColId);
    SearchAndFocuse.formStyle := fsStayOnTop;
  end;
  SearchAndFocuse.EditSearch.text := ValToSearch;
  SearchAndFocuse.m_BinColId := BinColId;
  SearchAndFocuse.m_SearchByColumn := true;
  SearchAndFocuse.Show;
  SearchAndFocuse.Caption := _('Position column on Bin for ' + Title);
  SearchAndFocuse.SetFocus;
end;

//----------------------------------------------------------------------------//

procedure TSearchAndFocuse.BitBtn1Click(Sender: TObject);
begin
  if not m_SearchByColumn  then
     FindUserRequest
  else FindColumnData
end;

//----------------------------------------------------------------------------//

procedure TSearchAndFocuse.BitBtn2Click(Sender: TObject);
begin
  Close;
end;

//----------------------------------------------------------------------------//

procedure TSearchAndFocuse.BitBtnFindNextClick(Sender: TObject);
begin
  if not m_SearchByColumn then
     FindNextUserRequest
  else
     FindNextColumnData;
end;

//----------------------------------------------------------------------------//

constructor TSearchAndFocuse.CreateSearchColumnFocuse(AOwner: TWinControl;
  ValToSearch: string; BinColId: CBinColId);
begin
  inherited Create(AOwner);
  ReShape(Self);
end;

//----------------------------------------------------------------------------//

constructor TSearchAndFocuse.CreateSearchFocuse(AOwner: TWinControl);
begin
  inherited Create(AOwner);
//  Caption := _('Position request on Bin');
 // ReShape(Self);
end;

procedure TSearchAndFocuse.EditSearchKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    BitBtn1Click(self);
  end;

end;

//----------------------------------------------------------------------------//

procedure TSearchAndFocuse.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SearchAndFocuse := nil;
end;

procedure TSearchAndFocuse.FormCreate(Sender: TObject);
begin
  BitBtn1.caption := _('Find first');
  BitBtn3.caption := _('Find next');

  ReShape(Self);
end;

//----------------------------------------------------------------------------//

procedure TSearchAndFocuse.FormShow(Sender: TObject);
begin
//  if not m_SearchByColumn then
//    EditSearch.SetFocus
//  else
//    BitBtn1.SetFocus;

  EditSearch.SetFocus;


end;

//----------------------------------------------------------------------------//

function TSearchAndFocuse.GetStringForSearch: string;
begin
  Result := EditSearch.Text;
end;

//----------------------------------------------------------------------------//

procedure TSearchAndFocuse.FindColumnData;
var
  StrSearch : string;
  tbs : TBinTabSheet;
  I : Integer;
  Id : TschedId;
  FieldVal : variant;
  dataType: CBinColValType;
  found : boolean;
  info:  TSQPlanInfo;
  StrMsg : string;
  L : Integer;
  TempStr : string;
begin
  found := false;
  ModalResult := mrnone;

  StrSearch := EditSearch.Text;
  tbs := TBinTabSheet(FBin.GetActiveView);
  if Assigned(tbs) then
  begin
    for i := 0 to tbs.m_BinPanel.m_objList.GetLinkCount - 1 do
    begin
      Id := tbs.m_BinPanel.m_objList.GetLink(i);
      p_sc.GetFldValue(Id, m_BinColId, FieldVal, dataType);

      p_sc.GetPlanInfo(Id, info);

      if (dataType = CBT_dur) or (dataType = CBT_float) or (dataType = CBT_date) then
         FieldVal := p_sc.GetFldDescr(Id, m_BinColId, false);

      if (UpperCase(StrSearch) = UpperCase(FieldVal)) then
      begin
        found := true;
        Fbin.FocusBinOnJobID(id, False);
        break
      end
      else
      begin
        //if (dataType = CBT_string) then
        //begin
          {L := Length(Trim(StrSearch));
          if L < 3 then exit;
          TempStr := copy(Trim(StrSearch),1,1);
          if TempStr <> '%' then continue;
          TempStr := copy(Trim(StrSearch),L,1);
          if TempStr <> '%' then continue;
          TempStr := copy(Trim(StrSearch),2,l-2);
          if AnsiContainsStr(FieldVal , TempStr) then
          begin
            found := true;
            Fbin.FocusBinOnJobID(id, False);
            break
          end; }
        L := Length(Trim(StrSearch));
        if L < 2 then exit;

        if (copy(Trim(StrSearch),1,1) <> '%') and (copy(Trim(StrSearch),L,1) <> '%') then
           continue;
        if (copy(Trim(StrSearch),1,1) = '%') and (copy(Trim(StrSearch),L,1) = '%') then
        begin
          if L < 3 then exit;
          TempStr := copy(Trim(StrSearch),2,l-2);
          if AnsiContainsStr(FieldVal , TempStr) then
          begin
            found := true;
            Fbin.FocusBinOnJobID(id, False);
            break
          end;
        end
        else if copy(Trim(StrSearch),1,1) = '%' then
        begin
          TempStr := copy(Trim(StrSearch),2,l-1);
          if AnsiEndsStr(TempStr, FieldVal) then
          begin
            found := true;
            Fbin.FocusBinOnJobID(id, False);
            break
          end;
        end
        else
        begin
          TempStr := copy(Trim(StrSearch),1,l-1);
          if AnsiStartsStr(TempStr, FieldVal) then  //AnsiEndsStr
          begin
            found := true;
            Fbin.FocusBinOnJobID(id, False);
            break
          end;
        end

        //end;
      end

    end;

    if not found then
    begin
      showmessage(_('Item can not be found'));
      ModalResult := mrNone;
    end
    else if not found then
    begin
      showmessage(_('Cant find any other ' + StrMsg));
      ModalResult := mrNone;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TSearchAndFocuse.FindNextColumnData;
var
  StrSearch : string;
  tbs : TBinTabSheet;
  I : Integer;
  Id, CurrSelectedRow : TschedId;
  FieldVal : variant;
  dataType: CBinColValType;
  found : boolean;
  info:  TSQPlanInfo;
  L : Integer;
  TempStr : string;
begin
  found := false;
  ModalResult := mrnone;
  StrSearch := EditSearch.Text;
  tbs := TBinTabSheet(FBin.GetActiveView);
  if tbs.m_BinPanel.GetFiltParms.P_MaterialSchedFilter then
    CurrSelectedRow := tbs.m_BinPanel.p_GridMat.Row
  else
    CurrSelectedRow := tbs.m_BinPanel.p_Grid.Row;
  if Assigned(tbs) then
  begin
    for i := 0 to tbs.m_BinPanel.m_objList.GetLinkCount - 1 do
    begin
      if I < CurrSelectedRow then continue;
      Id := tbs.m_BinPanel.m_objList.GetLink(i);
      //p_sc.GetPlanInfo(Id, info);

      p_sc.GetFldValue(Id, m_BinColId, FieldVal, dataType);

      if (dataType = CBT_dur) or (dataType = CBT_float) or (dataType = CBT_date) then
         FieldVal := p_sc.GetFldDescr(Id, m_BinColId, false);

      if (UpperCase(StrSearch) = UpperCase(FieldVal)) then
      begin
        found := true;
        Fbin.FocusBinOnJobID(id, False);
        break;
      end
      else
      begin
        //if (dataType = CBT_string) then
        //begin
          {L := Length(Trim(StrSearch));
          if L < 3 then exit;
          TempStr := copy(Trim(StrSearch),1,1);
          if TempStr <> '%' then continue;
          TempStr := copy(Trim(StrSearch),L,1);
          if TempStr <> '%' then continue;
          TempStr := copy(Trim(StrSearch),2,l-2);
          if AnsiContainsStr(FieldVal , TempStr) then
          begin
            found := true;
            Fbin.FocusBinOnJobID(id, False);
            break
          end; }
        L := Length(Trim(StrSearch));
        if L < 2 then exit;

        if (copy(Trim(StrSearch),1,1) <> '%') and (copy(Trim(StrSearch),L,1) <> '%') then
           continue;
        if (copy(Trim(StrSearch),1,1) = '%') and (copy(Trim(StrSearch),L,1) = '%') then
        begin
          if L < 3 then exit;
          TempStr := copy(Trim(StrSearch),2,l-2);
          if AnsiContainsStr(FieldVal , TempStr) then
          begin
            found := true;
            Fbin.FocusBinOnJobID(id, False);
            break
          end;
        end
        else if copy(Trim(StrSearch),1,1) = '%' then
        begin
          TempStr := copy(Trim(StrSearch),2,l-1);
          if AnsiEndsStr(TempStr, FieldVal) then
          begin
            found := true;
            Fbin.FocusBinOnJobID(id, False);
            break
          end;
        end
        else
        begin
          TempStr := copy(Trim(StrSearch),1,l-1);
          if AnsiStartsStr(TempStr, FieldVal) then
          begin
            found := true;
            Fbin.FocusBinOnJobID(id, False);
            break
          end;
        end
      end;
      //end
    end;
    if not found then
    begin
      showmessage(_('Cant find any other Items '));
      ModalResult := mrNone;
    end
    else if not found then
    begin
      showmessage(_('Cant find any other Items '));
      ModalResult := mrNone;
    end;
  end;

end;

//----------------------------------------------------------------------------//

procedure TSearchAndFocuse.FindNextUserRequest;
var
  StrSearch : string;
  tbs : TBinTabSheet;
  I : Integer;
  Id, CurrSelectedRow : TschedId;
  FieldVal : variant;
  dataType: CBinColValType;
  found : boolean;
  info:  TSQPlanInfo;
begin
  found := false;
  ModalResult := mrnone;
  StrSearch := EditSearch.Text;
  tbs := TBinTabSheet(FBin.GetActiveView);
  CurrSelectedRow := tbs.m_BinPanel.p_Grid.Row;
  if Assigned(tbs) then
  begin
    for i := 0 to tbs.m_BinPanel.m_objList.GetLinkCount - 1 do
    begin
      if I < CurrSelectedRow then continue;
      Id := tbs.m_BinPanel.m_objList.GetLink(i);
      p_sc.GetPlanInfo(Id, info);

      p_sc.GetFldValue(Id, CSC_ProdReq, FieldVal, dataType);
      if info.isGroup then
      begin
        if p_sc.CheckGroupValues(id, CSC_ProdReq, StrSearch, '') then
           FieldVal := StrSearch;
      end;

      if (UpperCase(StrSearch) = Uppercase(FieldVal)) then
      begin
        found := true;
        Fbin.FocusBinOnJobID(id, False);
        break;
      end;
    end;
    if not found then
    begin
      showmessage(_('Production request can not be found'));
      ModalResult := mrNone;
    end
    else if not found then
    begin
      showmessage(_('Cant find any other Production request '));
      ModalResult := mrNone;
    end;
  end;

end;

//----------------------------------------------------------------------------//

procedure TSearchAndFocuse.FindUserRequest;
var
  StrSearch : string;
  tbs : TBinTabSheet;
  I : Integer;
  Id : TschedId;
  FieldVal : variant;
  dataType: CBinColValType;
  found : boolean;
  info:  TSQPlanInfo;
begin
  found := false;
  ModalResult := mrnone;
  StrSearch := EditSearch.Text;
  tbs := TBinTabSheet(FBin.GetActiveView);
  if Assigned(tbs) then
  begin
    for i := 0 to tbs.m_BinPanel.m_objList.GetLinkCount - 1 do
    begin
      Id := tbs.m_BinPanel.m_objList.GetLink(i);
      p_sc.GetFldValue(Id, CSC_ProdReq, FieldVal, dataType);

      p_sc.GetPlanInfo(Id, info);

      if info.isGroup then
      begin
        if p_sc.CheckGroupValues(id, CSC_ProdReq, StrSearch, '') then
            FieldVal := StrSearch;
      end;

      if (StrSearch = FieldVal) then
      begin
        found := true;
        Fbin.FocusBinOnJobID(id, False);
        break;
      end;
    end;
    if not found then
    begin
      showmessage(_('Production request can not be found'));
      ModalResult := mrNone;
    end
    else if not found then
    begin
      showmessage(_('Cant find any other Production request '));
      ModalResult := mrNone;
    end;
  end;

end;

//----------------------------------------------------------------------------//

end.
