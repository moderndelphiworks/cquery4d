{
         CQL Brasil - Criteria Query Language for Delphi/Lazarus


                   Copyright (c) 2019, Isaque Pinheiro
                          All rights reserved.

                    GNU Lesser General Public License
                      Vers�o 3, 29 de junho de 2007

       Copyright (C) 2007 Free Software Foundation, Inc. <http://fsf.org/>
       A todos � permitido copiar e distribuir c�pias deste documento de
       licen�a, mas mud�-lo n�o � permitido.

       Esta vers�o da GNU Lesser General Public License incorpora
       os termos e condi��es da vers�o 3 da GNU General Public License
       Licen�a, complementado pelas permiss�es adicionais listadas no
       arquivo LICENSE na pasta principal.
}

{
  @abstract(CQLBr Framework)
  @created(18 Jul 2019)
  @source(Inspired by and based on "GpSQLBuilder" project - https://github.com/gabr42/GpSQLBuilder)
  @source(Author of CQLBr Framework: Isaque Pinheiro <isaquesp@gmail.com>)
  @source(Author's Website: https://www.isaquepinheiro.com.br)
}

unit CQL.Name;

{$ifdef fpc}
  {$mode delphi}{$H+}
{$endif}

interface

uses
  SysUtils,
  Generics.Collections,
  CQL.Interfaces;

type
  TCQLName = class(TInterfacedObject, ICQLName)
  strict private
    FAlias: String;
    FCase: ICQLCase;
    FName: String;
    function _GetAlias: String;
    function _GetCase: ICQLCase;
    function _GetName: String;
    procedure _SetAlias(const Value: String);
    procedure _SetCase(const Value: ICQLCase);
    procedure _SetName(const Value: String);
  public
    destructor Destroy; override;
    procedure Clear;
    function IsEmpty: Boolean;
    function Serialize: String;
    property Name: String read _GetName write _SetName;
    property Alias: String read _GetAlias write _SetAlias;
    property CaseExpr: ICQLCase read _GetCase write _SetCase;
  end;

  TCQLNames = class(TInterfacedObject, ICQLNames)
  private
    FColumns: TList<ICQLName>;
    function SerializeName(const AName: ICQLName): String;
    function SerializeDirection(ADirection: TOrderByDirection): String;
  protected
    function GetColumns(AIdx: Integer): ICQLName;
  public
    constructor Create;
    destructor Destroy; override;
    function Add: ICQLName; overload; virtual;
    procedure Add(const Value: ICQLName); overload; virtual;
    procedure Clear;
    function Count: Integer;
    function IsEmpty: Boolean;
    function Serialize: String;
    property Columns[AIdx: Integer]: ICQLName read GetColumns; default;
  end;

implementation

uses
  CQL.Utils;

{ TCQLName }

procedure TCQLName.Clear;
begin
  FName := '';
  FAlias := '';
end;

function TCQLName._GetAlias: String;
begin
  Result := FAlias;
end;

function TCQLName._GetCase: ICQLCase;
begin
  Result := FCase;
end;

function TCQLName._GetName: String;
begin
  Result := FName;
end;

destructor TCQLName.Destroy;
begin
  FCase := nil;
  inherited;
end;

function TCQLName.IsEmpty: Boolean;
begin
  Result := (FName = '') and (FAlias = '');
end;

function TCQLName.Serialize: String;
begin
  if Assigned(FCase) then
    Result := '(' + FCase.Serialize + ')'
  else
    Result := FName;
  if FAlias <> '' then
    Result := TUtils.Concat([Result, 'AS', FAlias]);
end;

procedure TCQLName._SetAlias(const Value: String);
begin
  FAlias := Value;
end;

procedure TCQLName._SetCase(const Value: ICQLCase);
begin
  FCase := Value;
end;

procedure TCQLName._SetName(const Value: String);
begin
  FName := Value;
end;

{ TCQLNames }

function TCQLNames.Add: ICQLName;
begin
  Result := TCQLName.Create;
  Add(Result);
end;

procedure TCQLNames.Add(const Value: ICQLName);
begin
  FColumns.Add(Value);
end;

procedure TCQLNames.Clear;
begin
  FColumns.Clear;
end;

function TCQLNames.Count: Integer;
begin
  Result := FColumns.Count;
end;

constructor TCQLNames.Create;
begin
  FColumns := TList<ICQLName>.Create;
end;

destructor TCQLNames.Destroy;
begin
  FColumns.Free;
  inherited;
end;

function TCQLNames.GetColumns(AIdx: Integer): ICQLName;
begin
  Result := FColumns[AIdx];
end;

function TCQLNames.IsEmpty: Boolean;
begin
  Result := (Count = 0);
end;

function TCQLNames.Serialize: String;
var
  LFor: Integer;
  LOrderByCol: ICQLOrderByColumn;
begin
  Result := '';
  for LFor := 0 to FColumns.Count -1 do
  begin
    Result := TUtils.Concat([Result, SerializeName(FColumns[LFor])], ', ');
    if Supports(FColumns[LFor], ICQLOrderByColumn, LOrderByCol) then
      Result := TUtils.Concat([Result, SerializeDirection(LOrderByCol.Direction)]);
  end;
end;

function TCQLNames.SerializeDirection(ADirection: TOrderByDirection): String;
begin
  case ADirection of
    dirAscending:  Result := '';
    dirDescending: Result := 'DESC';
  else
    raise Exception.Create('TCQLNames.SerializeDirection: Unknown direction');
  end;
end;

function TCQLNames.SerializeName(const AName: ICQLName): String;
begin
  Result := AName.Serialize;
end;

end.
