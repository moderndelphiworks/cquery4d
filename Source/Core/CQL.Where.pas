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

unit CQL.Where;

{$ifdef fpc}
  {$mode delphi}{$H+}
{$endif}

interface

uses
  CQL.Section,
  CQL.Expression,
  CQL.Interfaces;

type
  TCQLWhere = class(TCQLSection, ICQLWhere)
  private
    function _GetExpression: ICQLExpression;
    procedure _SetExpression(const Value: ICQLExpression);
  protected
    FExpression: ICQLExpression;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Clear; override;
    function Serialize: String; virtual;
    function IsEmpty: Boolean; override;
    property Expression: ICQLExpression read _GetExpression write _SetExpression;
  end;

implementation

uses
  CQL.Utils;

{ TCQLWhere }

procedure TCQLWhere.Clear;
begin
  Expression.Clear;
end;

constructor TCQLWhere.Create;
begin
  inherited Create('Where');
  FExpression := TCQLExpression.Create;
end;

destructor TCQLWhere.Destroy;
begin
  inherited;
end;

function TCQLWhere._GetExpression: ICQLExpression;
begin
  Result := FExpression;
end;

function TCQLWhere.IsEmpty: Boolean;
begin
  Result := FExpression.IsEmpty;
end;

function TCQLWhere.Serialize: String;
begin
  if IsEmpty then
    Result := ''
  else
    Result := TUtils.Concat(['WHERE', FExpression.Serialize]);
end;

procedure TCQLWhere._SetExpression(const Value: ICQLExpression);
begin
  FExpression := Value;
end;

end.
