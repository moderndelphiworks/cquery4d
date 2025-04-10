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

unit CQL.Insert;

{$ifdef fpc}
  {$mode delphi}{$H+}
{$endif}

interface

uses
  CQL.Section,
  CQL.Name,
  CQL.Namevalue,
  CQL.Interfaces;

type
  TCQLInsert = class(TCQLSection, ICQLInsert)
  strict private
    FColumns: ICQLNames;
    FTableName: String;
    FValues: ICQLNameValuePairs;
    function _SerializeNameValuePairsForInsert(const APairs: ICQLNameValuePairs): String;
    function _GetTableName: String;
    procedure _SetTableName(const Value: String);
  public
    constructor Create;
    procedure Clear; override;
    function Columns: ICQLNames;
    function IsEmpty: Boolean; override;
    function Values: ICQLNameValuePairs;
    function Serialize: String;
    property TableName: String read _GetTableName write _SetTableName;
  end;

implementation

uses
  CQL.Utils;

{ TCQLInsert }

procedure TCQLInsert.Clear;
begin
  FTableName := '';
  FColumns.Clear;
  FValues.Clear;
end;

function TCQLInsert.Columns: ICQLNames;
begin
  Result := FColumns;
end;

constructor TCQLInsert.Create;
begin
  inherited Create('Insert');
  FColumns := TCQLNames.Create;
  FValues := TCQLNameValuePairs.Create;
end;

function TCQLInsert._GetTableName: String;
begin
  Result := FTableName;
end;

function TCQLInsert.IsEmpty: Boolean;
begin
  Result := (TableName = '');
end;

function TCQLInsert.Serialize: String;
begin
  if IsEmpty then
    Result := ''
  else
  begin
    Result := TUtils.Concat(['INSERT INTO', FTableName]);
    if FColumns.Count > 0 then
      Result := TUtils.Concat([Result, '(', Columns.Serialize, ')'])
    else
      Result := TUtils.Concat([Result, _SerializeNameValuePairsForInsert(FValues)]);
  end;
end;

function TCQLInsert._SerializeNameValuePairsForInsert(const APairs: ICQLNameValuePairs): String;
var
  LFor: integer;
  LColumns: String;
  LValues: String;
begin
  Result := '';
  if APairs.Count = 0 then
    Exit;

  LColumns := '';
  LValues := '';
  for LFor := 0 to APairs.Count - 1 do
  begin
    LColumns := TUtils.Concat([LColumns, APairs[LFor].Name] , ', ');
    LValues  := TUtils.Concat([LValues , APairs[LFor].Value], ', ');
  end;
  Result := TUtils.Concat(['(', LColumns, ') VALUES (', LValues, ')'],'');
end;

procedure TCQLInsert._SetTableName(const Value: String);
begin
  FTableName := Value;
end;

function TCQLInsert.Values: ICQLNameValuePairs;
begin
  Result := FValues;
end;

end.

