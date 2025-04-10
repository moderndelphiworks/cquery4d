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

unit CQL.Update;

{$ifdef fpc}
  {$mode delphi}{$H+}
{$endif}

interface

uses
  CQL.Section,
  CQL.Namevalue,
  CQL.Interfaces;

type
  TCQLUpdate = class(TCQLSection, ICQLUpdate)
  strict private
    FTableName: String;
    FValues: ICQLNameValuePairs;
    function _SerializeNameValuePairsForUpdate(const APairs: ICQLNameValuePairs): String;
    function  _GetTableName: String;
    procedure _SetTableName(const value: String);
  public
    constructor Create;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    function Values: ICQLNameValuePairs;
    function Serialize: String;
    property TableName: String read _GetTableName write _SetTableName;
  end;

implementation

uses
  CQL.Utils;

{ TCQLUpdate }

procedure TCQLUpdate.Clear;
begin
  FTableName := '';
  FValues.Clear;
end;

constructor TCQLUpdate.Create;
begin
  inherited Create('Update');
  FValues := TCQLNameValuePairs.Create;
end;

function TCQLUpdate._GetTableName: String;
begin
  Result := FTableName;
end;

function TCQLUpdate.IsEmpty: Boolean;
begin
  Result := (TableName = '');
end;

function TCQLUpdate.Serialize: String;
begin
  if IsEmpty then
    Result := ''
  else
    Result := TUtils.Concat(['UPDATE', FTableName, 'SET',
      _SerializeNameValuePairsForUpdate(FValues)]);
end;

function TCQLUpdate._SerializeNameValuePairsForUpdate(const APairs: ICQLNameValuePairs): String;
var
  LFor: Integer;
begin
  Result := '';
  for LFor := 0 to APairs.Count -1 do
    Result := TUtils.Concat([Result, TUtils.Concat([APairs[LFor].Name, '=', APairs[LFor].Value])], ', ');
end;

procedure TCQLUpdate._SetTableName(const value: String);
begin
  FTableName := Value;
end;

function TCQLUpdate.Values: ICQLNameValuePairs;
begin
  Result := FValues;
end;

end.
