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

unit CQL.Expression;

{$ifdef fpc}
  {$mode delphi}{$H+}
{$endif}

interface

uses
  SysUtils,
  CQL.Interfaces;

type
  TCQLExpression = class(TInterfacedObject, ICQLExpression)
  strict private
    FOperation: TExpressionOperation;
    FLeft: ICQLExpression;
    FRight: ICQLExpression;
    FTerm: String;
    function _SerializeWhere(AAddParens: Boolean): String;
    function _SerializeAND: String;
    function _SerializeOR: String;
    function _SerializeOperator: String;
    function _SerializeFunction: String;
  protected
    function GetLeft: ICQLExpression;
    function GetOperation: TExpressionOperation;
    function GetRight: ICQLExpression;
    function GetTerm: String;
    procedure SetLeft(const AValue: ICQLExpression);
    procedure SetOperation(const AValue: TExpressionOperation);
    procedure SetRight(const AValue: ICQLExpression);
    procedure SetTerm(const AValue: String);
  public
    destructor Destroy; override;
    procedure Assign(const ANode: ICQLExpression);
    procedure Clear;
    function IsEmpty: Boolean;
    function Serialize(AAddParens: Boolean = False): String;
    property Term: String read GetTerm write SetTerm;
    property Operation: TExpressionOperation read GetOperation write SetOperation;
    property Left: ICQLExpression read GetLeft write SetLeft;
    property Right: ICQLExpression read GetRight write SetRight;
  end;

  TCQLCriteriaExpression = class(TInterfacedObject, ICQLCriteriaExpression)
  strict private
    FExpression: ICQLExpression;
    FLastAnd: ICQLExpression;
  protected
    function FindRightmostAnd(const AExpression: ICQLExpression): ICQLExpression;
  public
    constructor Create(const AExpression: String = ''); overload;
    constructor Create(const AExpression: ICQLExpression); overload;
    function AndOpe(const AExpression: array of const): ICQLCriteriaExpression; overload;
    function AndOpe(const AExpression: String): ICQLCriteriaExpression; overload;
    function AndOpe(const AExpression: ICQLExpression): ICQLCriteriaExpression; overload;
    function OrOpe(const AExpression: array of const): ICQLCriteriaExpression; overload;
    function OrOpe(const AExpression: String): ICQLCriteriaExpression; overload;
    function OrOpe(const AExpression: ICQLExpression): ICQLCriteriaExpression; overload;
    function Ope(const AExpression: array of const): ICQLCriteriaExpression; overload;
    function Ope(const AExpression: String): ICQLCriteriaExpression; overload;
    function Ope(const AExpression: ICQLExpression): ICQLCriteriaExpression; overload;
    function Fun(const AExpression: array of const): ICQLCriteriaExpression; overload;
    function Fun(const AExpression: String): ICQLCriteriaExpression; overload;
    function Fun(const AExpression: ICQLExpression): ICQLCriteriaExpression; overload;
    function AsString: String;
    function Expression: ICQLExpression;
  end;

implementation

uses
  CQL.Utils;

{ TCQLExpression }

procedure TCQLExpression.Assign(const ANode: ICQLExpression);
begin
  FLeft := ANode.Left;
  FRight := ANode.Right;
  FTerm := ANode.Term;
  FOperation := ANode.Operation;
end;

procedure TCQLExpression.Clear;
begin
  FOperation := opNone;
  FTerm := '';
  FLeft := nil;
  FRight := nil;
end;

destructor TCQLExpression.Destroy;
begin
  FLeft := nil;
  FRight := nil;
  inherited;
end;

function TCQLExpression.GetLeft: ICQLExpression;
begin
  Result := FLeft;
end;

function TCQLExpression.GetOperation: TExpressionOperation;
begin
  Result := FOperation;
end;

function TCQLExpression.GetRight: ICQLExpression;
begin
  Result := FRight;
end;

function TCQLExpression.GetTerm: String;
begin
  Result := FTerm;
end;

function TCQLExpression.IsEmpty: Boolean;
begin
  // Caso n�o exista a chamada do WHERE � considerado Empty.
  Result := (FOperation = opNone) and (FTerm = '');
end;

function TCQLExpression.Serialize(AAddParens: Boolean): String;
begin
  if IsEmpty then
    Result := ''
  else
    case FOperation of
      opNone:
        Result := _SerializeWhere(AAddParens);
      opAND:
        Result := _SerializeAND;
      opOR:
        Result := _SerializeOR;
      opOperation:
        Result := _SerializeOperator;
      opFunction:
        Result := _SerializeFunction;
      else
        raise Exception.Create('TCQLExpression.Serialize: Unknown operation');
    end;
end;

function TCQLExpression._SerializeAND: String;
begin
  Result := TUtils.Concat([FLeft.Serialize(True),
                           'AND',
                           FRight.Serialize(True)]);
end;

function TCQLExpression._SerializeFunction: String;
begin
  Result := TUtils.Concat([FLeft.Serialize(False),
                           FRight.Serialize(False)]);
end;

function TCQLExpression._SerializeOperator: String;
begin
  Result := '(' + TUtils.Concat([FLeft.Serialize(False),
                                 FRight.Serialize(False)]) + ')';
end;

function TCQLExpression._SerializeOR: String;
begin
  Result := '(' + TUtils.Concat([FLeft.Serialize(True),
                                 'OR',
                                 FRight.Serialize(True)]) + ')';
end;

function TCQLExpression._SerializeWhere(AAddParens: Boolean): String;
begin
  if AAddParens then
    Result := TUtils.concat(['(', FTerm, ')'], '')
  else
    Result := FTerm;
end;

procedure TCQLExpression.SetLeft(const AValue: ICQLExpression);
begin
  FLeft := AValue;
end;

procedure TCQLExpression.SetOperation(const AValue: TExpressionOperation);
begin
  FOperation := AValue;
end;

procedure TCQLExpression.SetRight(const AValue: ICQLExpression);
begin
  FRight := AValue;
end;

procedure TCQLExpression.SetTerm(const AValue: String);
begin
  FTerm := AValue;
end;

{ TCQLCriteriaExpression }

function TCQLCriteriaExpression.AndOpe(const AExpression: ICQLExpression): ICQLCriteriaExpression;
var
  LNode: ICQLExpression;
  LRoot: ICQLExpression;
begin
  LRoot := FExpression;
  if LRoot.IsEmpty then
  begin
    LRoot.Assign(AExpression);
    FLastAnd := LRoot;
  end
  else
  begin
    LNode := TCQLExpression.Create;
    LNode.Assign(LRoot);
    LRoot.Left := LNode;
    LRoot.Operation := opAND;
    LRoot.Right := AExpression;
    FLastAnd := LRoot.Right;
  end;
  Result := Self;
end;

function TCQLCriteriaExpression.AndOpe(const AExpression: String): ICQLCriteriaExpression;
var
  LNode: ICQLExpression;
begin
  LNode := TCQLExpression.Create;
  LNode.Term := AExpression;
  Result := AndOpe(LNode);
end;

function TCQLCriteriaExpression.AndOpe(const AExpression: array of const): ICQLCriteriaExpression;
begin
  Result := AndOpe(TUtils.SqlParamsToStr(AExpression));
end;

function TCQLCriteriaExpression.AsString: String;
begin
  Result := FExpression.Serialize;
end;

constructor TCQLCriteriaExpression.Create(const AExpression: ICQLExpression);
begin
  FExpression := AExpression;
  FLastAnd := FindRightmostAnd(AExpression);
end;

function TCQLCriteriaExpression.Expression: ICQLExpression;
begin
  Result := FExpression;
end;

constructor TCQLCriteriaExpression.Create(const AExpression: String);
begin
  FExpression := TCQLExpression.Create;
  if AExpression <> '' then
    AndOpe(AExpression);
end;

function TCQLCriteriaExpression.FindRightmostAnd(const AExpression: ICQLExpression): ICQLExpression;
begin
  if AExpression.Operation = opNone then
    Result := FExpression
  else
  if AExpression.Operation = opOR then
    Result := FExpression
  else
    Result := FindRightmostAnd(AExpression.Right);
end;

function TCQLCriteriaExpression.Fun(const AExpression: array of const): ICQLCriteriaExpression;
begin
  Result := Fun(TUtils.SqlParamsToStr(AExpression));
end;

function TCQLCriteriaExpression.Fun(const AExpression: String): ICQLCriteriaExpression;
var
  LNode: ICQLExpression;
begin
  LNode := TCQLExpression.Create;
  LNode.Term := AExpression;
  Result := Fun(LNode);
end;

function TCQLCriteriaExpression.Fun(const AExpression: ICQLExpression): ICQLCriteriaExpression;
var
  LNode: ICQLExpression;
begin
  LNode := TCQLExpression.Create;
  LNode.Assign(FLastAnd);
  FLastAnd.Left := LNode;
  FLastAnd.Operation := opFunction;
  FLastAnd.Right := AExpression;
  Result := Self;
end;

function TCQLCriteriaExpression.OrOpe(const AExpression: array of const): ICQLCriteriaExpression;
begin
  Result := OrOpe(TUtils.SqlParamsToStr(AExpression));
end;

function TCQLCriteriaExpression.OrOpe(const AExpression: String): ICQLCriteriaExpression;
var
  LNode: ICQLExpression;
begin
  LNode := TCQLExpression.Create;
  LNode.Term := AExpression;
  Result := OrOpe(LNode);
end;

function TCQLCriteriaExpression.Ope(const AExpression: array of const): ICQLCriteriaExpression;
begin
  Result := Ope(TUtils.SqlParamsToStr(AExpression));
end;

function TCQLCriteriaExpression.Ope(const AExpression: String): ICQLCriteriaExpression;
var
  LNode: ICQLExpression;
begin
  LNode := TCQLExpression.Create;
  LNode.Term := AExpression;
  Result := Ope(LNode);
end;

function TCQLCriteriaExpression.Ope(const AExpression: ICQLExpression): ICQLCriteriaExpression;
var
  LNode: ICQLExpression;
begin
  LNode := TCQLExpression.Create;
  LNode.Assign(FLastAnd);
  FLastAnd.Left := LNode;
  FLastAnd.Operation := opOperation;
  FLastAnd.Right := AExpression;
  Result := Self;
end;

function TCQLCriteriaExpression.OrOpe(const AExpression: ICQLExpression): ICQLCriteriaExpression;
var
  LNode: ICQLExpression;
  LRoot: ICQLExpression;
begin
  LRoot := FLastAnd;
  LNode := TCQLExpression.Create;
  LNode.Assign(LRoot);
  LRoot.Left := LNode;
  LRoot.Operation := opOR;
  LRoot.Right := AExpression;
  FLastAnd := LRoot.Right;
  Result := Self;
end;

end.

