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

unit CQL.SelectDB2;

{$ifdef fpc}
  {$mode delphi}{$H+}
{$endif}

interface

uses
  SysUtils,
  CQL.Select;

type
  TCQLSelectDB2 = class(TCQLSelect)
  public
    constructor Create; override;
    function Serialize: String; override;
  end;

implementation

uses
  CQL.Utils,
  CQL.Interfaces,
  CQL.Register,
  CQL.QualifierOracle;

{ TCQLSelectDB2 }

constructor TCQLSelectDB2.Create;
begin
  inherited;
  FQualifiers := TCQLSelectQualifiersOracle.Create;
end;

function TCQLSelectDB2.Serialize: String;
begin
  if IsEmpty then
    Result := ''
  else
    Result := TUtils.Concat(['SELECT',
                             FColumns.Serialize,
                             FQualifiers.SerializeDistinct,
                             'FROM',
                             FTableNames.Serialize]);
end;

end.
