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

unit CQL.QualifierFirebird;

{$ifdef fpc}
  {$mode delphi}{$H+}
{$endif}

interface

uses
  SysUtils,
  CQL.Interfaces,
  CQL.Qualifier;

type
  TCQLSelectQualifiersFirebird = class(TCQLSelectQualifiers)
  public
    function SerializePagination: String; override;
 end;

implementation

uses
  CQL.Utils;

{ TCQLSelectQualifiersFirebird }

function TCQLSelectQualifiersFirebird.SerializePagination: String;
var
  LFor: Integer;
  LFirst: String;
  LSkip: String;
begin
  Result := '';
  for LFor := 0 to Count -1 do
  begin
    case FQualifiers[LFor].Qualifier of
      sqFirst: LFirst := TUtils.Concat(['FIRST', IntToStr(FQualifiers[LFor].Value)]);
      sqSkip:  LSkip  := TUtils.Concat(['SKIP' , IntToStr(FQualifiers[LFor].Value)]);
    else
      raise Exception.Create('TCQLSelectQualifiersFirebird.SerializeSelectQualifiers: Unknown qualifier');
    end;
  end;
  Result := TUtils.Concat([Result, LFirst, LSkip]);
end;

end.
