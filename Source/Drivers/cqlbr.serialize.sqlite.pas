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

unit cqlbr.serialize.sqlite;

{$ifdef fpc}
  {$mode delphi}{$H+}
{$endif}

interface

uses
  SysUtils,
  cqlbr.register,
  cqlbr.interfaces,
  cqlbr.serialize;

type
  TCQLSerializerSQLite = class(TCQLSerialize)
  public
    function AsString(const AAST: ICQLAST): String; override;
  end;

implementation

{ TCQLSerializer }

function TCQLSerializerSQLite.AsString(const AAST: ICQLAST): String;
begin
  Result := inherited AsString(AAST);
end;

initialization
  TCQLBrRegister.RegisterSerialize(dbnSQLite, TCQLSerializerSQLite.Create);

end.


