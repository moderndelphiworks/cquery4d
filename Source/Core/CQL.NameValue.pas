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

unit CQL.NameValue;

{$ifdef fpc}
  {$mode delphi}{$H+}
{$endif}

interface

uses
  SysUtils,
  Generics.Collections,
  CQL.Interfaces;

type
  TCQLNameValue  = class(TInterfacedObject, ICQLNameValue)
  strict private
    FName : String;
    FValue: String;
    function _GetName: String;
    function _GetValue: String;
    procedure _SetName(const Value: String);
    procedure _SetValue(const Value: String);
  public
    procedure Clear;
    function IsEmpty: Boolean;
    property Name: String read _GetName write _SetName;
    property Value: String read _GetValue write _SetValue;
  end;

  TCQLNameValuePairs = class(TInterfacedObject, ICQLNameValuePairs)
  strict private
    FList: TList<ICQLNameValue>;
    function _GetItem(AIdx: Integer): ICQLNameValue;
  public
    constructor Create;
    destructor Destroy; override;
    function Add: ICQLNameValue; overload;
    procedure Add(const ANameValue: ICQLNameValue); overload;
    procedure Clear;
    function Count: Integer;
    function IsEmpty: Boolean;
    property Item[AIdx: Integer]: ICQLNameValue read _GetItem; default;
  end;

implementation

uses
  CQL.Utils;

{ TCQLNameValue }

procedure TCQLNameValue.Clear;
begin
  FName := '';
  FValue := '';
end;

function TCQLNameValue._GetName: String;
begin
  Result := FName;
end;

function TCQLNameValue._GetValue: String;
begin
  Result := FValue;
end;

function TCQLNameValue.IsEmpty: Boolean;
begin
  Result := (FName <> '');
end;

procedure TCQLNameValue._SetName(const Value: String);
begin
  FName := Value;
end;

procedure TCQLNameValue._SetValue(const Value: String);
begin
  FValue := Value;
end;

{ TCQLNameValuePairs }

function TCQLNameValuePairs.Add: ICQLNameValue;
begin
  Result := TCQLNameValue.Create;
  Add(Result);
end;

procedure TCQLNameValuePairs.Add(const ANameValue: ICQLNameValue);
begin
  FList.Add(ANameValue);
end;

procedure TCQLNameValuePairs.Clear;
begin
  FList.Clear;
end;

function TCQLNameValuePairs.Count: Integer;
begin
  Result := FList.Count;
end;

constructor TCQLNameValuePairs.Create;
begin
  FList := TList<ICQLNameValue>.Create;
end;

destructor TCQLNameValuePairs.Destroy;
begin
  FList.Free;
  inherited;
end;

function TCQLNameValuePairs._GetItem(AIdx: Integer): ICQLNameValue;
begin
  Result := FList[AIdx];
end;

function TCQLNameValuePairs.IsEmpty: Boolean;
begin
  Result := (Count = 0);
end;

end.
