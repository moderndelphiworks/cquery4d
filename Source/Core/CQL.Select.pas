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

unit CQL.Select;

{$ifdef fpc}
  {$mode delphi}{$H+}
{$endif}

interface

uses
  CQL.Interfaces,
  CQL.Qualifier,
  CQL.Section,
  CQL.Name;

type
  TCQLSelect = class(TCQLSection, ICQLSelect)
  protected
    FColumns: ICQLNames;
    FTableNames: ICQLNames;
    FQualifiers: ICQLSelectQualifiers;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    function Columns: ICQLNames;
    function TableNames: ICQLNames;
    function Qualifiers: ICQLSelectQualifiers;
    function Serialize: String; virtual;
  end;

implementation

uses
  CQL.Utils,
  CQL.QualifierFirebird;

{ TSelect }

procedure TCQLSelect.Clear;
begin
  FColumns.Clear;
  FTableNames.Clear;
  if Assigned(FQualifiers) then
    FQualifiers.Clear;
end;

function TCQLSelect.Columns: ICQLNames;
begin
  Result := FColumns;
end;

constructor TCQLSelect.Create;
begin
  inherited Create('Select');
  FColumns := TCQLNames.Create;
  FTableNames := TCQLNames.Create;
end;

destructor TCQLSelect.Destroy;
begin
  FColumns := nil;
  FTableNames := nil;
  FQualifiers := nil;
  inherited;
end;

function TCQLSelect.IsEmpty: Boolean;
begin
  Result := (FColumns.IsEmpty and FTableNames.IsEmpty);
end;

function TCQLSelect.Qualifiers: ICQLSelectQualifiers;
begin
  Result := FQualifiers;
end;

function TCQLSelect.Serialize: String;
begin
  if IsEmpty then
    Result := ''
  else
    Result := TUtils.Concat(['SELECT',
                             FQualifiers.SerializeDistinct,
                             FQualifiers.SerializePagination,
                             FColumns.Serialize,
                             'FROM',
                             FTableNames.Serialize]);
end;

function TCQLSelect.TableNames: ICQLNames;
begin
  Result := FTableNames;
end;

end.

