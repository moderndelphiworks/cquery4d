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

unit CQL;

{$ifdef fpc}
  {$mode delphi}{$H+}
{$endif}

interface

uses
  SysUtils,
  CQL.Operators,
  CQL.Functions,
  CQL.Interfaces,
  CQL.Cases,
  CQL.Select,
  CQL.Utils,
  CQL.Serialize,
  CQL.Qualifier,
  CQL.Ast,
  CQL.Expression,
  CQL.Register;

type
  TDBName = CQL.Interfaces.TDBName;
  CQLFun = CQL.Functions.TCQLFunctions;

  TCQL = class(TInterfacedObject, ICQL)
  strict private
    class var FDatabaseDafault: TDBName;
    type
      TSection = (secSelect = 0,
                  secDelete = 1,
                  secInsert = 2,
                  secUpdate = 3,
                  secJoin = 4,
                  secWhere= 5,
                  secGroupBy = 6,
                  secHaving = 7,
                  secOrderBy = 8);
      TSections = set of TSection;
  strict private
    FActiveSection: TSection;
    FActiveOperator: TOperator;
    FActiveExpr: ICQLCriteriaExpression;
    FActiveValues: ICQLNameValuePairs;
    FDatabase: TDBName;
    FOperator: ICQLOperators;
    FFunction: ICQLFunctions;
    FAST: ICQLAST;
    FRegister: TCQLRegister;
    procedure _AssertSection(ASections: TSections);
    procedure _AssertOperator(AOperators: TOperators);
    procedure _AssertHaveName;
    procedure _SetSection(ASection: TSection);
    procedure _DefineSectionSelect;
    procedure _DefineSectionDelete;
    procedure _DefineSectionInsert;
    procedure _DefineSectionUpdate;
    procedure _DefineSectionWhere;
    procedure _DefineSectionGroupBy;
    procedure _DefineSectionHaving;
    procedure _DefineSectionOrderBy;
    function _CreateJoin(AjoinType: TJoinType; const ATableName: String): ICQL;
    function _InternalSet(const AColumnName, AColumnValue: String): ICQL;
  public
    constructor Create(const ADatabase: TDBName);
    destructor Destroy; override;
    class procedure SetDatabaseDafault(const ADatabase: TDBName);
    function AndOpe(const AExpression: array of const): ICQL; overload;
    function AndOpe(const AExpression: String): ICQL; overload;
    function AndOpe(const AExpression: ICQLCriteriaExpression): ICQL; overload;
    function Alias(const AAlias: String): ICQL;
    function CaseExpr(const AExpression: String = ''): ICQLCriteriaCase; overload;
    function CaseExpr(const AExpression: array of const): ICQLCriteriaCase; overload;
    function CaseExpr(const AExpression: ICQLCriteriaExpression): ICQLCriteriaCase; overload;
    function Clear: ICQL;
    function ClearAll: ICQL;
    function All: ICQL;
    function Column(const AColumnName: String = ''): ICQL; overload;
    function Column(const ATableName: String; const AColumnName: String): ICQL; overload;
    function Column(const AColumnsName: array of const): ICQL; overload;
    function Column(const ACaseExpression: ICQLCriteriaCase): ICQL; overload;
    function Delete: ICQL;
    function Desc: ICQL;
    function Distinct: ICQL;
    function IsEmpty: Boolean;
    function Expression(const ATerm: String = ''): ICQLCriteriaExpression; overload;
    function Expression(const ATerm: array of const): ICQLCriteriaExpression; overload;
    function From(const AExpression: ICQLCriteriaExpression): ICQL; overload;
    function From(const AQuery: ICQL): ICQL; overload;
    function From(const ATableName: String): ICQL; overload;
    function From(const ATableName: String; const AAlias: String): ICQL; overload;
    function GroupBy(const AColumnName: String = ''): ICQL;
    function Having(const AExpression: String = ''): ICQL; overload;
    function Having(const AExpression: array of const): ICQL; overload;
    function Having(const AExpression: ICQLCriteriaExpression): ICQL; overload;
    function Insert: ICQL;
    function Into(const ATableName: String): ICQL;
    function FullJoin(const ATableName: String): ICQL; overload;
    function InnerJoin(const ATableName: String): ICQL; overload;
    function LeftJoin(const ATableName: String): ICQL; overload;
    function RightJoin(const ATableName: String): ICQL; overload;
    function FullJoin(const ATableName: String; const AAlias: String): ICQL; overload;
    function InnerJoin(const ATableName: String; const AAlias: String): ICQL; overload;
    function LeftJoin(const ATableName: String; const AAlias: String): ICQL; overload;
    function RightJoin(const ATableName: String; const AAlias: String): ICQL; overload;
    function OnCond(const AExpression: String): ICQL; overload;
    function OnCond(const AExpression: array of const): ICQL; overload;
    function OrOpe(const AExpression: array of const): ICQL; overload;
    function OrOpe(const AExpression: String): ICQL; overload;
    function OrOpe(const AExpression: ICQLCriteriaExpression): ICQL; overload;
    function OrderBy(const AColumnName: String = ''): ICQL; overload;
    function OrderBy(const ACaseExpression: ICQLCriteriaCase): ICQL; overload;
    function Select(const AColumnName: String = ''): ICQL; overload;
    function Select(const ACaseExpression: ICQLCriteriaCase): ICQL; overload;
    function SetValue(const AColumnName, AColumnValue: String): ICQL; overload;
    function SetValue(const AColumnName: String; AColumnValue: Integer): ICQL; overload;
    function SetValue(const AColumnName: String; AColumnValue: Extended; ADecimalPlaces: Integer): ICQL; overload;
    function SetValue(const AColumnName: String; AColumnValue: Double; ADecimalPlaces: Integer): ICQL; overload;
    function SetValue(const AColumnName: String; AColumnValue: Currency; ADecimalPlaces: Integer): ICQL; overload;
    function SetValue(const AColumnName: String; const AColumnValue: array of const): ICQL; overload;
    function SetValue(const AColumnName: String; const AColumnValue: TDate): ICQL; overload;
    function SetValue(const AColumnName: String; const AColumnValue: TDateTime): ICQL; overload;
    function SetValue(const AColumnName: String; const AColumnValue: TGUID): ICQL; overload;
    function Values(const AColumnName, AColumnValue: String): ICQL; overload;
    function Values(const AColumnName: String; const AColumnValue: array of const): ICQL; overload;
    function First(const AValue: Integer): ICQL;
    function Skip(const AValue: Integer): ICQL;
    function Limit(const AValue: Integer): ICQL;
    function Offset(const AValue: Integer): ICQL;
    function Update(const ATableName: String): ICQL;
    function Where(const AExpression: String = ''): ICQL; overload;
    function Where(const AExpression: array of const): ICQL; overload;
    function Where(const AExpression: ICQLCriteriaExpression): ICQL; overload;
    // Operators methods
    function Equal(const AValue: String = ''): ICQL; overload;
    function Equal(const AValue: Extended): ICQL overload;
    function Equal(const AValue: Integer): ICQL; overload;
    function Equal(const AValue: TDate): ICQL; overload;
    function Equal(const AValue: TDateTime): ICQL; overload;
    function Equal(const AValue: TGUID): ICQL; overload;
    function NotEqual(const AValue: String = ''): ICQL; overload;
    function NotEqual(const AValue: Extended): ICQL; overload;
    function NotEqual(const AValue: Integer): ICQL; overload;
    function NotEqual(const AValue: TDate): ICQL; overload;
    function NotEqual(const AValue: TDateTime): ICQL; overload;
    function NotEqual(const AValue: TGUID): ICQL; overload;
    function GreaterThan(const AValue: Extended): ICQL; overload;
    function GreaterThan(const AValue: Integer) : ICQL; overload;
    function GreaterThan(const AValue: TDate): ICQL; overload;
    function GreaterThan(const AValue: TDateTime) : ICQL; overload;
    function GreaterEqThan(const AValue: Extended): ICQL; overload;
    function GreaterEqThan(const AValue: Integer) : ICQL; overload;
    function GreaterEqThan(const AValue: TDate): ICQL; overload;
    function GreaterEqThan(const AValue: TDateTime) : ICQL; overload;
    function LessThan(const AValue: Extended): ICQL; overload;
    function LessThan(const AValue: Integer) : ICQL; overload;
    function LessThan(const AValue: TDate): ICQL; overload;
    function LessThan(const AValue: TDateTime) : ICQL; overload;
    function LessEqThan(const AValue: Extended): ICQL; overload;
    function LessEqThan(const AValue: Integer) : ICQL; overload;
    function LessEqThan(const AValue: TDate): ICQL; overload;
    function LessEqThan(const AValue: TDateTime) : ICQL; overload;
    function IsNull: ICQL;
    function IsNotNull: ICQL;
    function Like(const AValue: String): ICQL;
    function LikeFull(const AValue: String): ICQL;
    function LikeLeft(const AValue: String): ICQL;
    function LikeRight(const AValue: String): ICQL;
    function NotLike(const AValue: String): ICQL;
    function NotLikeFull(const AValue: String): ICQL;
    function NotLikeLeft(const AValue: String): ICQL;
    function NotLikeRight(const AValue: String): ICQL;
    function InValues(const AValue: TArray<Double>): ICQL; overload;
    function InValues(const AValue: TArray<String>): ICQL; overload;
    function InValues(const AValue: String): ICQL; overload;
    function NotIn(const AValue: TArray<Double>): ICQL; overload;
    function NotIn(const AValue: TArray<String>): ICQL; overload;
    function NotIn(const AValue: String): ICQL; overload;
    function Exists(const AValue: String): ICQL; overload;
    function NotExists(const AValue: String): ICQL; overload;
    // Functions methods
    function Count: ICQL;
    function Lower: ICQL;
    function Min: ICQL;
    function Max: ICQL;
    function Upper: ICQL;
    function SubString(const AStart: Integer; const ALength: Integer): ICQL;
    function Date(const AValue: String): ICQL;
    function Day(const AValue: String): ICQL;
    function Month(const AValue: String): ICQL;
    function Year(const AValue: String): ICQL;
    function Concat(const AValue: array of String): ICQL;
    // Result full command sql
    function AsFun: ICQLFunctions;
    function AsString: String;
  end;

implementation

{ TCQL }

function TCQL.Alias(const AAlias: String): ICQL;
begin
  _AssertSection([secSelect, secDelete, secJoin]);
  _AssertHaveName;
  FAST.ASTName.Alias := AAlias;
  Result := Self;
end;

function TCQL.AsFun: ICQLFunctions;
begin
  Result := FFunction;
end;

function TCQL.CaseExpr(const AExpression: String): ICQLCriteriaCase;
var
  LExpression: String;
begin
  LExpression := AExpression;
  if LExpression = '' then
    LExpression := FAST.ASTName.Name;
  Result := TCQLCriteriaCase.Create(Self, LExpression);
  if Assigned(FAST) then
    FAST.ASTName.CaseExpr := Result.CaseExpr;
end;

function TCQL.CaseExpr(const AExpression: array of const): ICQLCriteriaCase;
begin
  Result := CaseExpr(TUtils.SqlParamsToStr(AExpression));
end;

function TCQL.CaseExpr(const AExpression: ICQLCriteriaExpression): ICQLCriteriaCase;
begin
  Result := TCQLCriteriaCase.Create(Self, '');
  Result.AndOpe(AExpression);
end;

function TCQL.AndOpe(const AExpression: ICQLCriteriaExpression): ICQL;
begin
  FActiveOperator := opeAND;
  FActiveExpr.AndOpe(AExpression.Expression);
  Result := Self;
end;

function TCQL.AndOpe(const AExpression: String): ICQL;
begin
  FActiveOperator := opeAND;
  FActiveExpr.AndOpe(AExpression);
  Result := Self;
end;

function TCQL.AndOpe(const AExpression: array of const): ICQL;
begin
  Result := AndOpe(TUtils.SqlParamsToStr(AExpression));
end;

function TCQL.OrOpe(const AExpression: array of const): ICQL;
begin
  Result := OrOpe(TUtils.SqlParamsToStr(AExpression));
end;

function TCQL.OrOpe(const AExpression: String): ICQL;
begin
  FActiveOperator := opeOR;
  FActiveExpr.OrOpe(AExpression);
  Result := Self;
end;

function TCQL.OrOpe(const AExpression: ICQLCriteriaExpression): ICQL;
begin
  FActiveOperator := opeOR;
  FActiveExpr.OrOpe(AExpression.Expression);
  Result := Self;
end;

function TCQL.SetValue(const AColumnName: String; const AColumnValue: array of const): ICQL;
begin
  Result := _InternalSet(AColumnName, TUtils.SqlParamsToStr(AColumnValue));
end;

function TCQL.SetValue(const AColumnName, AColumnValue: String): ICQL;
begin
  Result := _InternalSet(AColumnName, QuotedStr(AColumnValue));
end;

function TCQL.OnCond(const AExpression: String): ICQL;
begin
  Result := AndOpe(AExpression);
end;

function TCQL.Offset(const AValue: Integer): ICQL;
begin
  Result := Skip(AValue);
end;

function TCQL.OnCond(const AExpression: array of const): ICQL;
begin
  Result := OnCond(TUtils.SqlParamsToStr(AExpression));
end;

function TCQL.InValues(const AValue: String): ICQL;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsIn(AValue));
  Result := Self;
end;

function TCQL.SetValue(const AColumnName: String; AColumnValue: Integer): ICQL;
begin
  Result := _InternalSet(AColumnName, IntToStr(AColumnValue));
end;

function TCQL.SetValue(const AColumnName: String; AColumnValue: Extended; ADecimalPlaces: Integer): ICQL;
var
  LFormat: TFormatSettings;
begin
  LFormat.DecimalSeparator := '.';
  Result := _InternalSet(AColumnName, Format('%.' + IntToStr(ADecimalPlaces) + 'f', [AColumnValue], LFormat));
end;

function TCQL.SetValue(const AColumnName: String; AColumnValue: Double; ADecimalPlaces: Integer): ICQL;
var
  LFormat: TFormatSettings;
begin
  LFormat.DecimalSeparator := '.';
  Result := _InternalSet(AColumnName, Format('%.' + IntToStr(ADecimalPlaces) + 'f', [AColumnValue], LFormat));
end;

function TCQL.SetValue(const AColumnName: String; AColumnValue: Currency; ADecimalPlaces: Integer): ICQL;
var
  LFormat: TFormatSettings;
begin
  LFormat.DecimalSeparator := '.';
  Result := _InternalSet(AColumnName, Format('%.' + IntToStr(ADecimalPlaces) + 'f', [AColumnValue], LFormat));
end;

function TCQL.SetValue(const AColumnName: String;
  const AColumnValue: TDate): ICQL;
begin
  Result := _InternalSet(AColumnName, QuotedStr(TUtils.DateToSQLFormat(FDatabase, AColumnValue)));
end;

function TCQL.SetValue(const AColumnName: String;
  const AColumnValue: TDateTime): ICQL;
begin
  Result := _InternalSet(AColumnName, QuotedStr(TUtils.DateTimeToSQLFormat(FDatabase, AColumnValue)));
end;

function TCQL.SetValue(const AColumnName: String;
  const AColumnValue: TGUID): ICQL;
begin
  Result := _InternalSet(AColumnName, TUtils.GuidStrToSQLFormat(FDatabase, AColumnValue));
end;

class procedure TCQL.SetDatabaseDafault(const ADatabase: TDBName);
begin
  FDatabaseDafault := ADatabase;
end;

function TCQL.All: ICQL;
begin
  if not (FDatabase in [dbnMongoDB]) then
    Result := Column('*')
  else
    Result := Self;
end;

procedure TCQL._AssertHaveName;
begin
  if not Assigned(FAST.ASTName) then
    raise Exception.Create('TCriteria: Current name is not set');
end;

procedure TCQL._AssertOperator(AOperators: TOperators);
begin
  if not (FActiveOperator in AOperators) then
    raise Exception.Create('TCQL: Not supported in this operator');
end;

procedure TCQL._AssertSection(ASections: TSections);
begin
  if not (FActiveSection in ASections) then
    raise Exception.Create('TCQL: Not supported in this section');
end;

function TCQL.AsString: String;
begin
  FActiveOperator := opeNone;
  Result := FRegister.Serialize(FDatabase).AsString(FAST);
end;

function TCQL.Column(const AColumnName: String): ICQL;
begin
  if Assigned(FAST) then
  begin
    FAST.ASTName := FAST.ASTColumns.Add;
    FAST.ASTName.Name := AColumnName;
  end
  else
    raise Exception.CreateFmt('Current section [%s] does not support COLUMN.', [FAST.ASTSection.Name]);
  Result := Self;
end;

function TCQL.Column(const ATableName: String; const AColumnName: String): ICQL;
begin
  Result := Column(ATableName + '.' + AColumnName);
end;

function TCQL.Clear: ICQL;
begin
  FAST.ASTSection.Clear;
  Result := Self;
end;

function TCQL.ClearAll: ICQL;
begin
  FAST.Clear;
  Result := Self;
end;

function TCQL.Column(const ACaseExpression: ICQLCriteriaCase): ICQL;
begin
  if Assigned(FAST.ASTColumns) then
  begin
    FAST.ASTName := FAST.ASTColumns.Add;
    FAST.ASTName.CaseExpr := ACaseExpression.CaseExpr;
  end
  else
    raise Exception.CreateFmt('Current section [%s] does not support COLUMN.', [FAST.ASTSection.Name]);
  Result := Self;
end;

function TCQL.Concat(const AValue: array of String): ICQL;
begin
  _AssertSection([secSelect, secJoin, secWhere]);
  _AssertHaveName;
  case FActiveSection of
    secSelect: FAST.ASTName.Name := FFunction.Concat(AValue);
    secWhere: FActiveExpr.Fun(FFunction.Concat(AValue));
  end;
  Result := Self;
end;

function TCQL.Count: ICQL;
begin
  _AssertSection([secSelect, secDelete, secJoin]);
  _AssertHaveName;
  FAST.ASTName.Name := FFunction.Count(FAST.ASTName.Name);
  Result := Self;
end;

function TCQL.Column(const AColumnsName: array of const): ICQL;
begin
  Result := Column(TUtils.SqlParamsToStr(AColumnsName));
end;

constructor TCQL.Create(const ADatabase: TDBName);
begin
  FDatabase := ADatabase;
  FRegister := TCQLRegister.Create;
  FOperator := TCQLOperators.Create(FDatabase);
  FFunction := TCQLFunctions.Create(FDatabase, FRegister);
  FAST := TCQLAST.Create(FDatabase, FRegister);
  FAST.Clear;
  FActiveOperator := opeNone;
end;

function TCQL._CreateJoin(AjoinType: TJoinType; const ATableName: String): ICQL;
var
  LJoin: ICQLJoin;
begin
  FActiveSection := secJoin;
  LJoin := FAST.Joins.Add;
  LJoin.JoinType := AjoinType;
  FAST.ASTName := LJoin.JoinedTable;
  FAST.ASTName.Name := ATableName;
  FAST.ASTSection := LJoin;
  FAST.ASTColumns := nil;
  FActiveExpr := TCQLCriteriaExpression.Create(LJoin.Condition);
  Result := Self;
end;

function TCQL.Date(const AValue: String): ICQL;
begin
  _AssertSection([secSelect, secJoin, secWhere]);
  _AssertHaveName;
  case FActiveSection of
    secSelect: FAST.ASTName.Name := FFunction.Date(AValue);
    secWhere: FActiveExpr.Fun(FFunction.Date(AValue));
  end;
  Result := Self;
end;

function TCQL.Day(const AValue: String): ICQL;
begin
  _AssertSection([secSelect, secJoin, secWhere]);
  _AssertHaveName;
  case FActiveSection of
    secSelect: FAST.ASTName.Name := FFunction.Day(AValue);
    secWhere: FActiveExpr.Fun(FFunction.Day(AValue));
  end;
  Result := Self;
end;

procedure TCQL._DefineSectionDelete;
begin
  ClearAll();
  FAST.ASTSection := FAST.Delete;
  FAST.ASTColumns := nil;
  FAST.ASTTableNames := FAST.Delete.TableNames;
  FActiveExpr := nil;
  FActiveValues := nil;
end;

procedure TCQL._DefineSectionGroupBy;
begin
  FAST.ASTSection := FAST.GroupBy;
  FAST.ASTColumns := FAST.GroupBy.Columns;
  FAST.ASTTableNames := nil;
  FActiveExpr := nil;
  FActiveValues := nil;
end;

procedure TCQL._DefineSectionHaving;
begin
  FAST.ASTSection := FAST.Having;
  FAST.ASTColumns   := nil;
  FActiveExpr := TCQLCriteriaExpression.Create(FAST.Having.Expression);
  FAST.ASTTableNames := nil;
  FActiveValues := nil;
end;

procedure TCQL._DefineSectionInsert;
begin
  ClearAll();
  FAST.ASTSection := FAST.Insert;
  FAST.ASTColumns := FAST.Insert.Columns;
  FAST.ASTTableNames := nil;
  FActiveExpr := nil;
  FActiveValues := FAST.Insert.Values;
end;

procedure TCQL._DefineSectionOrderBy;
begin
  FAST.ASTSection := FAST.OrderBy;
  FAST.ASTColumns := FAST.OrderBy.Columns;
  FAST.ASTTableNames := nil;
  FActiveExpr := nil;
  FActiveValues := nil;
end;

procedure TCQL._DefineSectionSelect;
begin
  ClearAll();
  FAST.ASTSection := FAST.Select;
  FAST.ASTColumns := FAST.Select.Columns;
  FAST.ASTTableNames := FAST.Select.TableNames;
  FActiveExpr := nil;
  FActiveValues := nil;
end;

procedure TCQL._DefineSectionUpdate;
begin
  ClearAll();
  FAST.ASTSection := FAST.Update;
  FAST.ASTColumns := nil;
  FAST.ASTTableNames := nil;
  FActiveExpr := nil;
  FActiveValues := FAST.Update.Values;
end;

procedure TCQL._DefineSectionWhere;
begin
  FAST.ASTSection := FAST.Where;
  FAST.ASTColumns := nil;
  FAST.ASTTableNames := nil;
  FActiveExpr := TCQLCriteriaExpression.Create(FAST.Where.Expression);
  FActiveValues := nil;
end;

function TCQL.Delete: ICQL;
begin
  _SetSection(secDelete);
  Result := Self;
end;

function TCQL.Desc: ICQL;
begin
  _AssertSection([secOrderBy]);
  Assert(FAST.ASTColumns.Count > 0, 'TCriteria.Desc: No columns set up yet');
  (FAST.OrderBy.Columns[FAST.OrderBy.Columns.Count -1] as ICQLOrderByColumn).Direction := dirDescending;
  Result := Self;
end;

destructor TCQL.Destroy;
begin
  FActiveExpr := nil;
  FActiveValues := nil;
  FOperator := nil;
  FFunction := nil;
  FAST := nil;
  inherited;
end;

function TCQL.Distinct: ICQL;
var
  LQualifier: ICQLSelectQualifier;
begin
  _AssertSection([secSelect]);
  LQualifier := FAST.Select.Qualifiers.Add;
  LQualifier.Qualifier := sqDistinct;
  // Esse m�todo tem que Add o Qualifier j� todo parametrizado.
  FAST.Select.Qualifiers.Add(LQualifier);
  Result := Self;
end;

function TCQL.Equal(const AValue: Integer): ICQL;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsEqual(AValue));
  Result := Self;
end;

function TCQL.Equal(const AValue: Extended): ICQL;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsEqual(AValue));
  Result := Self;
end;

function TCQL.Equal(const AValue: String): ICQL;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  if AValue = '' then
    FActiveExpr.Fun(FOperator.IsEqual(AValue))
  else
    FActiveExpr.Ope(FOperator.IsEqual(AValue));
  Result := Self;
end;

function TCQL.Exists(const AValue: String): ICQL;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsExists(AValue));
  Result := Self;
end;

function TCQL.Expression(const ATerm: array of const): ICQLCriteriaExpression;
begin
  Result := Expression(TUtils.SqlParamsToStr(ATerm));
end;

function TCQL.Expression(const ATerm: String): ICQLCriteriaExpression;
begin
  Result := TCQLCriteriaExpression.Create(ATerm);
end;

function TCQL.From(const AExpression: ICQLCriteriaExpression): ICQL;
begin
  Result := From('(' + AExpression.AsString + ')');
end;

function TCQL.From(const AQuery: ICQL): ICQL;
begin
  Result := From('(' + AQuery.AsString + ')');
end;

function TCQL.From(const ATableName: String): ICQL;
begin
  _AssertSection([secSelect, secDelete]);
  FAST.ASTName := FAST.ASTTableNames.Add;
  FAST.ASTName.Name := ATableName;
  Result := Self;
end;

function TCQL.FullJoin(const ATableName: String): ICQL;
begin
  Result := _CreateJoin(jtFULL, ATableName);
end;

function TCQL.GreaterEqThan(const AValue: Integer): ICQL;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsGreaterEqThan(AValue));
  Result := Self;
end;

function TCQL.GreaterEqThan(const AValue: Extended): ICQL;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsGreaterEqThan(AValue));
  Result := Self;
end;

function TCQL.GreaterThan(const AValue: Integer): ICQL;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsGreaterThan(AValue));
  Result := Self;
end;

function TCQL.GreaterThan(const AValue: Extended): ICQL;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsGreaterThan(AValue));
  Result := Self;
end;

function TCQL.GroupBy(const AColumnName: String): ICQL;
begin
  _SetSection(secGroupBy);
  if AColumnName = '' then
    Result := Self
  else
    Result := Column(AColumnName);
end;

function TCQL.Having(const AExpression: String): ICQL;
begin
  _SetSection(secHaving);
  if AExpression = '' then
    Result := Self
  else
    Result := AndOpe(AExpression);
end;

function TCQL.Having(const AExpression: array of const): ICQL;
begin
  Result := Having(TUtils.SqlParamsToStr(AExpression));
end;

function TCQL.Having(const AExpression: ICQLCriteriaExpression): ICQL;
begin
  _SetSection(secHaving);
  Result := AndOpe(AExpression);
end;

function TCQL.InnerJoin(const ATableName: String): ICQL;
begin
  Result := _CreateJoin(jtINNER, ATableName);
end;

function TCQL.InnerJoin(const ATableName, AAlias: String): ICQL;
begin
  InnerJoin(ATableName).Alias(AAlias);
  Result := Self;
end;

function TCQL.Insert: ICQL;
begin
  _SetSection(secInsert);
  Result := Self;
end;

function TCQL._InternalSet(const AColumnName, AColumnValue: String): ICQL;
var
  LPair: ICQLNameValue;
begin
  _AssertSection([secInsert, secUpdate]);
  LPair := FActiveValues.Add;
  LPair.Name := AColumnName;
  LPair.Value := AColumnValue;
  Result := Self;
end;

function TCQL.Into(const ATableName: String): ICQL;
begin
  _AssertSection([secInsert]);
  FAST.Insert.TableName := ATableName;
  Result := Self;
end;

function TCQL.IsEmpty: Boolean;
begin
  Result := FAST.ASTSection.IsEmpty;
end;

function TCQL.InValues(const AValue: TArray<String>): ICQL;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsIn(AValue));
  Result := Self;
end;

function TCQL.InValues(const AValue: TArray<Double>): ICQL;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsIn(AValue));
  Result := Self;
end;

function TCQL.IsNotNull: ICQL;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsNotNull);
  Result := Self;
end;

function TCQL.IsNull: ICQL;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsNull);
  Result := Self;
end;

function TCQL.LeftJoin(const ATableName: String): ICQL;
begin
  Result := _CreateJoin(jtLEFT, ATableName);
end;

function TCQL.LeftJoin(const ATableName, AAlias: String): ICQL;
begin
  LeftJoin(ATableName).Alias(AAlias);
  Result := Self;
end;

function TCQL.LessEqThan(const AValue: Integer): ICQL;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsLessEqThan(AValue));
  Result := Self;
end;

function TCQL.LessEqThan(const AValue: Extended): ICQL;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsLessEqThan(AValue));
  Result := Self;
end;

function TCQL.LessThan(const AValue: Integer): ICQL;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsLessThan(AValue));
  Result := Self;
end;

function TCQL.LessThan(const AValue: Extended): ICQL;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsLessThan(AValue));
  Result := Self;
end;

function TCQL.Like(const AValue: String): ICQL;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsLike(AValue));
  Result := Self;
end;

function TCQL.LikeFull(const AValue: String): ICQL;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsLikeFull(AValue));
  Result := Self;
end;

function TCQL.LikeLeft(const AValue: String): ICQL;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsLikeLeft(AValue));
  Result := Self;
end;

function TCQL.LikeRight(const AValue: String): ICQL;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsLikeRight(AValue));
  Result := Self;
end;

function TCQL.Limit(const AValue: Integer): ICQL;
begin
  Result := First(AValue);
end;

function TCQL.Lower: ICQL;
begin
  _AssertSection([secSelect, secDelete, secJoin]);
  _AssertHaveName;
  FAST.ASTName.Name := FFunction.Lower(FAST.ASTName.Name);
  Result := Self;
end;

function TCQL.Max: ICQL;
begin
  _AssertSection([secSelect, secDelete, secJoin]);
  _AssertHaveName;
  FAST.ASTName.Name := FFunction.Max(FAST.ASTName.Name);
  Result := Self;
end;

function TCQL.Min: ICQL;
begin
  _AssertSection([secSelect, secDelete, secJoin]);
  _AssertHaveName;
  FAST.ASTName.Name := FFunction.Min(FAST.ASTName.Name);
  Result := Self;
end;

function TCQL.Month(const AValue: String): ICQL;
begin
  _AssertSection([secSelect, secJoin, secWhere]);
  _AssertHaveName;
  case FActiveSection of
    secSelect: FAST.ASTName.Name := FFunction.Month(AValue);
    secWhere: FActiveExpr.Fun(FFunction.Month(AValue));
  end;
  Result := Self;
end;

function TCQL.NotEqual(const AValue: String): ICQL;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsNotEqual(AValue));
  Result := Self;
end;

function TCQL.NotEqual(const AValue: Extended): ICQL;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsNotEqual(AValue));
  Result := Self;
end;

function TCQL.NotEqual(const AValue: Integer): ICQL;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsNotEqual(AValue));
  Result := Self;
end;

function TCQL.NotExists(const AValue: String): ICQL;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsNotExists(AValue));
  Result := Self;
end;

function TCQL.NotIn(const AValue: TArray<String>): ICQL;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsNotIn(AValue));
  Result := Self;
end;

function TCQL.NotIn(const AValue: TArray<Double>): ICQL;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsNotIn(AValue));
  Result := Self;
end;

function TCQL.NotLike(const AValue: String): ICQL;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsNotLike(AValue));
  Result := Self;
end;

function TCQL.NotLikeFull(const AValue: String): ICQL;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsNotLikeFull(AValue));
  Result := Self;
end;

function TCQL.NotLikeLeft(const AValue: String): ICQL;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsNotLikeLeft(AValue));
  Result := Self;
end;

function TCQL.NotLikeRight(const AValue: String): ICQL;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsNotLikeRight(AValue));
  Result := Self;
end;

function TCQL.OrderBy(const ACaseExpression: ICQLCriteriaCase): ICQL;
begin
  _SetSection(secOrderBy);
  Result := Column(ACaseExpression);
end;

function TCQL.RightJoin(const ATableName, AAlias: String): ICQL;
begin
  RightJoin(ATableName).Alias(AAlias);
  Result := Self;
end;

function TCQL.RightJoin(const ATableName: String): ICQL;
begin
  Result := _CreateJoin(jtRIGHT, ATableName);
end;

function TCQL.OrderBy(const AColumnName: String): ICQL;
begin
  _SetSection(secOrderBy);
  if AColumnName = '' then
    Result := Self
  else
    Result := Column(AColumnName);
end;

function TCQL.Select(const AColumnName: String): ICQL;
begin
  _SetSection(secSelect);
  if AColumnName = '' then
    Result := Self
  else
    Result := Column(AColumnName);
end;

function TCQL.Select(const ACaseExpression: ICQLCriteriaCase): ICQL;
begin
  _SetSection(secSelect);
  Result := Column(ACaseExpression);
end;

procedure TCQL._SetSection(ASection: TSection);
begin
  case ASection of
    secSelect:  _DefineSectionSelect;
    secDelete:  _DefineSectionDelete;
    secInsert:  _DefineSectionInsert;
    secUpdate:  _DefineSectionUpdate;
    secWhere:   _DefineSectionWhere;
    secGroupBy: _DefineSectionGroupBy;
    secHaving:  _DefineSectionHaving;
    secOrderBy: _DefineSectionOrderBy;
  else
      raise Exception.Create('TCriteria.SetSection: Unknown section');
  end;
  FActiveSection := ASection;
end;

function TCQL.First(const AValue: Integer): ICQL;
var
  LQualifier: ICQLSelectQualifier;
begin
  _AssertSection([secSelect, secWhere, secOrderBy]);
  LQualifier := FAST.Select.Qualifiers.Add;
  LQualifier.Qualifier := sqFirst;
  LQualifier.Value := AValue;
  // Esse m�todo tem que Add o Qualifier j� todo parametrizado.
  FAST.Select.Qualifiers.Add(LQualifier);
  Result := Self;
end;

function TCQL.Skip(const AValue: Integer): ICQL;
var
  LQualifier: ICQLSelectQualifier;
begin
  _AssertSection([secSelect, secWhere, secOrderBy]);
  LQualifier := FAST.Select.Qualifiers.Add;
  LQualifier.Qualifier := sqSkip;
  LQualifier.Value := AValue;
  // Esse m�todo tem que Add o Qualifier j� todo parametrizado.
  FAST.Select.Qualifiers.Add(LQualifier);
  Result := Self;
end;

function TCQL.SubString(const AStart, ALength: Integer): ICQL;
begin
  _AssertSection([secSelect, secDelete, secJoin]);
  _AssertHaveName;
  FAST.ASTName.Name := FFunction.SubString(FAST.ASTName.Name, AStart, ALength);
  Result := Self;
end;

function TCQL.Update(const ATableName: String): ICQL;
begin
  _SetSection(secUpdate);
  FAST.Update.TableName := ATableName;
  Result := Self;
end;

function TCQL.Upper: ICQL;
begin
  _AssertSection([secSelect, secDelete, secJoin]);
  _AssertHaveName;
  FAST.ASTName.Name := FFunction.Upper(FAST.ASTName.Name);
  Result := Self;
end;

function TCQL.Values(const AColumnName: String; const AColumnValue: array of const): ICQL;
begin
  Result := _InternalSet(AColumnName, TUtils.SqlParamsToStr(AColumnValue));
end;

function TCQL.Values(const AColumnName, AColumnValue: String): ICQL;
begin
  Result := _InternalSet(AColumnName, QuotedStr(AColumnValue));
end;

function TCQL.Where(const AExpression: String): ICQL;
begin
  _SetSection(secWhere);
  FActiveOperator := opeWhere;
  if AExpression = '' then
    Result := Self
  else
    Result := AndOpe(AExpression);
end;

function TCQL.Where(const AExpression: array of const): ICQL;
begin
  Result := Where(TUtils.SqlParamsToStr(AExpression));
end;

function TCQL.Where(const AExpression: ICQLCriteriaExpression): ICQL;
begin
  _SetSection(secWhere);
  FActiveOperator := opeWhere;
  Result := AndOpe(AExpression);
end;

function TCQL.Year(const AValue: String): ICQL;
begin
  _AssertSection([secSelect, secJoin, secWhere]);
  _AssertHaveName;
  case FActiveSection of
    secSelect: FAST.ASTName.Name := FFunction.Year(AValue);
    secWhere: FActiveExpr.Fun(FFunction.Year(AValue));
  end;
  Result := Self;
end;

function TCQL.From(const ATableName, AAlias: String): ICQL;
begin
  From(ATableName).Alias(AAlias);
  Result := Self;
end;

function TCQL.FullJoin(const ATableName, AAlias: String): ICQL;
begin
  FullJoin(ATableName).Alias(AAlias);
  Result := Self;
end;

function TCQL.NotIn(const AValue: String): ICQL;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsNotIn(AValue));
  Result := Self;
end;

function TCQL.Equal(const AValue: TDateTime): ICQL;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsEqual(AValue));
  Result := Self;
end;

function TCQL.Equal(const AValue: TDate): ICQL;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsEqual(AValue));
  Result := Self;
end;

function TCQL.GreaterEqThan(const AValue: TDateTime): ICQL;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsGreaterEqThan(AValue));
  Result := Self;
end;

function TCQL.GreaterEqThan(const AValue: TDate): ICQL;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsGreaterEqThan(AValue));
  Result := Self;
end;

function TCQL.GreaterThan(const AValue: TDate): ICQL;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsGreaterThan(AValue));
  Result := Self;
end;

function TCQL.GreaterThan(const AValue: TDateTime): ICQL;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsGreaterThan(AValue));
  Result := Self;
end;

function TCQL.LessEqThan(const AValue: TDateTime): ICQL;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsLessEqThan(AValue));
  Result := Self;
end;

function TCQL.LessEqThan(const AValue: TDate): ICQL;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsLessEqThan(AValue));
  Result := Self;
end;

function TCQL.LessThan(const AValue: TDateTime): ICQL;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsLessThan(AValue));
  Result := Self;
end;

function TCQL.LessThan(const AValue: TDate): ICQL;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsLessThan(AValue));
  Result := Self;
end;

function TCQL.NotEqual(const AValue: TDate): ICQL;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsNotEqual(AValue));
  Result := Self;
end;

function TCQL.NotEqual(const AValue: TDateTime): ICQL;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsNotEqual(AValue));
  Result := Self;
end;

function TCQL.Equal(const AValue: TGUID): ICQL;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsEqual(AValue));
  Result := Self;
end;

function TCQL.NotEqual(const AValue: TGUID): ICQL;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsNotEqual(AValue));
  Result := Self;
end;

end.


