{
               CQuery4D: Fluent SQL Framework for Delphi

                          Apache License
                      Version 2.0, January 2004
                   http://www.apache.org/licenses/

       Licensed under the Apache License, Version 2.0 (the "License");
       you may not use this file except in compliance with the License.
       You may obtain a copy of the License at

             http://www.apache.org/licenses/LICENSE-2.0

       Unless required by applicable law or agreed to in writing, software
       distributed under the License is distributed on an "AS IS" BASIS,
       WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
       See the License for the specific language governing permissions and
       limitations under the License.
}

{
  @abstract(CQuery4D: Fluent SQL Framework for Delphi)
  @description(A modern and extensible query framework supporting multiple databases)
  @created(03 Apr 2025)
  @author(Isaque Pinheiro)
  @contact(isaquepsp@gmail.com)
  @discord(https://discord.gg/T2zJC8zX)
}

unit CQuery.Name;

{$ifdef fpc}
  {$mode delphi}{$H+}
{$endif}

interface

uses
  SysUtils,
  Generics.Collections,
  CQuery.Interfaces;

type
  TCQueryName = class(TInterfacedObject, ICQueryName)
  strict private
    FAlias: String;
    FCase: ICQueryCase;
    FName: String;
    function _GetAlias: String;
    function _GetCase: ICQueryCase;
    function _GetName: String;
    procedure _SetAlias(const Value: String);
    procedure _SetCase(const Value: ICQueryCase);
    procedure _SetName(const Value: String);
  public
    destructor Destroy; override;
    procedure Clear;
    function IsEmpty: Boolean;
    function Serialize: String;
    property Name: String read _GetName write _SetName;
    property Alias: String read _GetAlias write _SetAlias;
    property CaseExpr: ICQueryCase read _GetCase write _SetCase;
  end;

  TCQueryNames = class(TInterfacedObject, ICQueryNames)
  private
    FColumns: TList<ICQueryName>;
    function SerializeName(const AName: ICQueryName): String;
    function SerializeDirection(ADirection: TOrderByDirection): String;
  protected
    function GetColumns(AIdx: Integer): ICQueryName;
  public
    constructor Create;
    destructor Destroy; override;
    function Add: ICQueryName; overload; virtual;
    procedure Add(const Value: ICQueryName); overload; virtual;
    procedure Clear;
    function Count: Integer;
    function IsEmpty: Boolean;
    function Serialize: String;
    property Columns[AIdx: Integer]: ICQueryName read GetColumns; default;
  end;

implementation

uses
  CQuery.Utils;

{ TCQueryName }

procedure TCQueryName.Clear;
begin
  FName := '';
  FAlias := '';
end;

function TCQueryName._GetAlias: String;
begin
  Result := FAlias;
end;

function TCQueryName._GetCase: ICQueryCase;
begin
  Result := FCase;
end;

function TCQueryName._GetName: String;
begin
  Result := FName;
end;

destructor TCQueryName.Destroy;
begin
  FCase := nil;
  inherited;
end;

function TCQueryName.IsEmpty: Boolean;
begin
  Result := (FName = '') and (FAlias = '');
end;

function TCQueryName.Serialize: String;
begin
  if Assigned(FCase) then
    Result := '(' + FCase.Serialize + ')'
  else
    Result := FName;
  if FAlias <> '' then
    Result := TUtils.Concat([Result, 'AS', FAlias]);
end;

procedure TCQueryName._SetAlias(const Value: String);
begin
  FAlias := Value;
end;

procedure TCQueryName._SetCase(const Value: ICQueryCase);
begin
  FCase := Value;
end;

procedure TCQueryName._SetName(const Value: String);
begin
  FName := Value;
end;

{ TCQueryNames }

function TCQueryNames.Add: ICQueryName;
begin
  Result := TCQueryName.Create;
  Add(Result);
end;

procedure TCQueryNames.Add(const Value: ICQueryName);
begin
  FColumns.Add(Value);
end;

procedure TCQueryNames.Clear;
begin
  FColumns.Clear;
end;

function TCQueryNames.Count: Integer;
begin
  Result := FColumns.Count;
end;

constructor TCQueryNames.Create;
begin
  FColumns := TList<ICQueryName>.Create;
end;

destructor TCQueryNames.Destroy;
begin
  FColumns.Free;
  inherited;
end;

function TCQueryNames.GetColumns(AIdx: Integer): ICQueryName;
begin
  Result := FColumns[AIdx];
end;

function TCQueryNames.IsEmpty: Boolean;
begin
  Result := (Count = 0);
end;

function TCQueryNames.Serialize: String;
var
  LFor: Integer;
  LOrderByCol: ICQueryOrderByColumn;
begin
  Result := '';
  for LFor := 0 to FColumns.Count -1 do
  begin
    Result := TUtils.Concat([Result, SerializeName(FColumns[LFor])], ', ');
    if Supports(FColumns[LFor], ICQueryOrderByColumn, LOrderByCol) then
      Result := TUtils.Concat([Result, SerializeDirection(LOrderByCol.Direction)]);
  end;
end;

function TCQueryNames.SerializeDirection(ADirection: TOrderByDirection): String;
begin
  case ADirection of
    dirAscending:  Result := 'ASC';
    dirDescending: Result := 'DESC';
  else
    raise Exception.Create('TCQueryNames.SerializeDirection: Unknown direction');
  end;
end;

function TCQueryNames.SerializeName(const AName: ICQueryName): String;
begin
  Result := AName.Serialize;
end;

end.

