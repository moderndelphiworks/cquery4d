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

unit CQL.Interfaces;


{$ifdef fpc}
  {$mode delphi}{$H+}
{$endif}

interface

type
  TExpressionOperation = (opNone, opAND, opOR, opOperation, opFunction);
  TOperator = (opeNone, opeWhere, opeAND, opeOR);
  TOperators = set of TOperator;
  TDBName = (dbnMSSQL, dbnMySQL, dbnFirebird, dbnSQLite, dbnInterbase, dbnDB2,
             dbnOracle, dbnInformix, dbnPostgreSQL, dbnADS, dbnASA,
             dbnAbsoluteDB, dbnMongoDB, dbnElevateDB, dbnNexusDB);

  ICQL = interface;
  ICQLAST = interface;
  ICQLFunctions = interface;

  ICQLExpression = interface
    ['{D1DA5991-9755-485A-A031-9C25BC42A2AA}']
    function GetLeft: ICQLExpression;
    function GetOperation: TExpressionOperation;
    function GetRight: ICQLExpression;
    function GetTerm: String;
    procedure SetLeft(const value: ICQLExpression);
    procedure SetOperation(const value: TExpressionOperation);
    procedure SetRight(const value: ICQLExpression);
    procedure SetTerm(const value: String);
    procedure Assign(const ANode: ICQLExpression);
    procedure Clear;
    function IsEmpty: Boolean;
    function Serialize(AAddParens: Boolean = False): String;
    property Term: String read GetTerm write SetTerm;
    property Operation: TExpressionOperation read GetOperation write SetOperation;
    property Left: ICQLExpression read GetLeft write SetLeft;
    property Right: ICQLExpression read GetRight write SetRight;
  end;

  ICQLCriteriaExpression = interface
    ['{E55E5EAC-BA0A-49C7-89AF-C2BAF51E5561}']
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

  ICQLCaseWhenThen = interface
    ['{C08E0BA8-87EA-4DA7-A4F2-DD718DB2E972}']
    function GetThenExpression: ICQLExpression;
    function GetWhenExpression: ICQLExpression;
    procedure SetThenExpression(const AValue: ICQLExpression);
    procedure SetWhenExpression(const AValue: ICQLExpression);
    //
    property WhenExpression: ICQLExpression read GetWhenExpression write SetWhenExpression;
    property ThenExpression: ICQLExpression read GetThenExpression write SetThenExpression;
  end;

  ICQLCaseWhenList = interface
    ['{CD02CC25-7261-4C37-8D22-532320EFAEB1}']
    function GetWhenThen(AIdx: Integer): ICQLCaseWhenThen;
    procedure SetWhenThen(AIdx: Integer; const AValue: ICQLCaseWhenThen);
    //
    function Add: ICQLCaseWhenThen; overload;
    function Add(const AWhenThen: ICQLCaseWhenThen): Integer; overload;
    function Count: Integer;
    property WhenThen[AIdx: Integer]: ICQLCaseWhenThen read GetWhenThen write SetWhenThen; default;
  end;

  ICQLCase = interface
    ['{C3CDCEE4-990A-4709-9B24-D0A1DF2E3373}']
    function GetCaseExpression: ICQLExpression;
    function GetElseExpression: ICQLExpression;
    function GetWhenList: ICQLCaseWhenList;
    procedure SetCaseExpression(const AValue: ICQLExpression);
    procedure SetElseExpression(const AValue: ICQLExpression);
    procedure SetWhenList(const AValue: ICQLCaseWhenList);
    //
    function Serialize: String;
    property CaseExpression: ICQLExpression read GetCaseExpression write SetCaseExpression;
    property WhenList: ICQLCaseWhenList read GetWhenList write SetWhenList;
    property ElseExpression: ICQLExpression read GetElseExpression write SetElseExpression;
  end;

  ICQLCriteriaCase = interface
    ['{B542AEE6-5F0D-4547-A7DA-87785432BC65}']
    function _GetCase: ICQLCase;
    //
    function AndOpe(const AExpression: array of const): ICQLCriteriaCase; overload;
    function AndOpe(const AExpression: String): ICQLCriteriaCase; overload;
    function AndOpe(const AExpression: ICQLCriteriaExpression): ICQLCriteriaCase; overload;
    function ElseIf(const AValue: String): ICQLCriteriaCase; overload;
    function ElseIf(const AValue: int64): ICQLCriteriaCase; overload;
    function EndCase: ICQL;
    function OrOpe(const AExpression: array of const): ICQLCriteriaCase; overload;
    function OrOpe(const AExpression: String): ICQLCriteriaCase; overload;
    function OrOpe(const AExpression: ICQLCriteriaExpression): ICQLCriteriaCase; overload;
    function IfThen(const AValue: String): ICQLCriteriaCase; overload;
    function IfThen(const AValue: int64): ICQLCriteriaCase; overload;
    function When(const ACondition: String): ICQLCriteriaCase; overload;
    function When(const ACondition: array of const): ICQLCriteriaCase; overload;
    function When(const ACondition: ICQLCriteriaExpression): ICQLCriteriaCase; overload;
    property CaseExpr: ICQLCase read _GetCase;
  end;

  ICQL = interface
    ['{DFDEA57B-A75B-450E-A576-DC49523B01E7}']
    function AndOpe(const AExpression: array of const): ICQL; overload;
    function AndOpe(const AExpression: String): ICQL; overload;
    function AndOpe(const AExpression: ICQLCriteriaExpression): ICQL; overload;
    function Alias(const AAlias: String): ICQL;
    function CaseExpr(const AExpression: String = ''): ICQLCriteriaCase; overload;
    function CaseExpr(const AExpression: array of const): ICQLCriteriaCase; overload;
    function CaseExpr(const AExpression: ICQLCriteriaExpression): ICQLCriteriaCase; overload;
    function OnCond(const AExpression: String): ICQL; overload;
    function OnCond(const AExpression: array of const): ICQL; overload;
    function OrOpe(const AExpression: array of const): ICQL; overload;
    function OrOpe(const AExpression: String): ICQL; overload;
    function OrOpe(const AExpression: ICQLCriteriaExpression): ICQL; overload;
    function SetValue(const AColumnName, AColumnValue: String): ICQL; overload;
    function SetValue(const AColumnName: String; AColumnValue: Integer): ICQL; overload;
    function SetValue(const AColumnName: String; AColumnValue: Extended; ADecimalPlaces: Integer): ICQL; overload;
    function SetValue(const AColumnName: String; AColumnValue: Double; ADecimalPlaces: Integer): ICQL; overload;
    function SetValue(const AColumnName: String; AColumnValue: Currency; ADecimalPlaces: Integer): ICQL; overload;
    function SetValue(const AColumnName: String; const AColumnValue: array of const): ICQL; overload;
    function SetValue(const AColumnName: String; const AColumnValue: TDate): ICQL; overload;
    function SetValue(const AColumnName: String; const AColumnValue: TDateTime): ICQL; overload;
    function SetValue(const AColumnName: String; const AColumnValue: TGUID): ICQL; overload;
    function All: ICQL;
    function Clear: ICQL;
    function ClearAll: ICQL;
    function Column(const AColumnName: String = ''): ICQL; overload;
    function Column(const ATableName: String; const AColumnName: String): ICQL; overload;
    function Column(const AColumnsName: array of const): ICQL; overload;
    function Column(const ACaseExpression: ICQLCriteriaCase): ICQL; overload;
    function Delete: ICQL;
    function Desc: ICQL;
    function Distinct: ICQL;
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
    function FullJoin(const ATableName: String): ICQL; overload;
    function InnerJoin(const ATableName: String): ICQL; overload;
    function LeftJoin(const ATableName: String): ICQL; overload;
    function RightJoin(const ATableName: String): ICQL; overload;
    function FullJoin(const ATableName: String; const AAlias: String): ICQL; overload;
    function InnerJoin(const ATableName: String; const AAlias: String): ICQL; overload;
    function LeftJoin(const ATableName: String; const AAlias: String): ICQL; overload;
    function RightJoin(const ATableName: String; const AAlias: String): ICQL; overload;
    function Insert: ICQL;
    function Into(const ATableName: String): ICQL;
    function IsEmpty: Boolean;
    function OrderBy(const AColumnName: String = ''): ICQL; overload;
    function OrderBy(const ACaseExpression: ICQLCriteriaCase): ICQL; overload;
    function Select(const AColumnName: String = ''): ICQL; overload;
    function Select(const ACaseExpression: ICQLCriteriaCase): ICQL; overload;
    function First(const AValue: Integer): ICQL;
    function Skip(const AValue: Integer): ICQL;
    function Limit(const AValue: Integer): ICQL;
    function Offset(const AValue: Integer): ICQL;
    function Update(const ATableName: String): ICQL;
    function Where(const AExpression: String = ''): ICQL; overload;
    function Where(const AExpression: array of const): ICQL; overload;
    function Where(const AExpression: ICQLCriteriaExpression): ICQL; overload;
    function Values(const AColumnName, AColumnValue: String): ICQL; overload;
    function Values(const AColumnName: String; const AColumnValue: array of const): ICQL; overload;
    // Operators functions
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
    function GreaterThan(const AValue: TDateTime): ICQL; overload;
    function GreaterEqThan(const AValue: Extended): ICQL; overload;
    function GreaterEqThan(const AValue: Integer) : ICQL; overload;
    function GreaterEqThan(const AValue: TDate): ICQL; overload;
    function GreaterEqThan(const AValue: TDateTime): ICQL; overload;
    function LessThan(const AValue: Extended): ICQL; overload;
    function LessThan(const AValue: Integer) : ICQL; overload;
    function LessThan(const AValue: TDate): ICQL; overload;
    function LessThan(const AValue: TDateTime): ICQL; overload;
    function LessEqThan(const AValue: Extended): ICQL; overload;
    function LessEqThan(const AValue: Integer) : ICQL; overload;
    function LessEqThan(const AValue: TDate) : ICQL; overload;
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
    //
    function AsFun: ICQLFunctions;
    function AsString: String;
  end;

  ICQLName = interface
    ['{FA82F4B9-1202-4926-8385-C2100EB0CA97}']
    function _GetAlias: String;
    function _GetCase: ICQLCase;
    function _GetName: String;
    procedure _SetAlias(const Value: String);
    procedure _SetCase(const Value: ICQLCase);
    procedure _SetName(const Value: String);
    //
    procedure Clear;
    function IsEmpty: Boolean;
    function Serialize: String;
    property Name: String read _GetName write _SetName;
    property Alias: String read _GetAlias write _SetAlias;
    property CaseExpr: ICQLCase read _GetCase write _SetCase;
  end;

  ICQLNames = interface
    ['{6030F621-276C-4C52-9135-F029BEEEB39C}']
    function  GetColumns(AIdx: Integer): ICQLName;
    //
    function Add: ICQLName; overload;
    procedure Add(const Value: ICQLName); overload;
    procedure Clear;
    function Count: Integer;
    function IsEmpty: Boolean;
    function Serialize: String;
    property Columns[AIdx: Integer]: ICQLName read GetColumns; default;
  end;

  ICQLSection = interface
    ['{6FA93873-2285-4A08-B700-7FBAAE846F73}']
    function _GetName: String;
    //
    procedure Clear;
    function IsEmpty: Boolean;
    property Name: String read _GetName;
  end;

  TOrderByDirection = (dirAscending, dirDescending);

  ICQLOrderByColumn = interface(ICQLName)
    ['{AC57006D-9087-4319-8258-97E68801503A}']
    function GetDirection: TOrderByDirection;
    procedure SetDirection(const value: TOrderByDirection);
    //
    property Direction: TOrderByDirection read GetDirection write SetDirection;
  end;

  ICQLOrderBy = interface(ICQLSection)
    ['{8D3484F7-9856-4232-AFD5-A80FB4F7833E}']
    function Columns: ICQLNames;
    function Serialize: String;
  end;

  TSelectQualifierType = (sqFirst, sqSkip, sqDistinct);

  ICQLSelectQualifier = interface
    ['{44EBF85E-10BB-45C0-AC6E-336A82B3A81D}']
    function  _GetQualifier: TSelectQualifierType;
    function  _GetValue: Integer;
    procedure _SetQualifier(const Value: TSelectQualifierType);
    procedure _SetValue(const Value: Integer);
    //
    property Qualifier: TSelectQualifierType read _GetQualifier write _SetQualifier;
    property Value: Integer read _GetValue write _SetValue;
  end;

  ICQLSelectQualifiers = interface
    ['{4AC225D9-2447-4906-8285-23D55F59B676}']
    function _GetQualifier(AIdx: Integer): ICQLSelectQualifier;
    //
    function Add: ICQLSelectQualifier; overload;
    procedure Add(AQualifier: ICQLSelectQualifier); overload;
    procedure Clear;
    function ExecutingPagination: Boolean;
    function Count: Integer;
    function IsEmpty: Boolean;
    function SerializePagination: String;
    function SerializeDistinct: String;
    property Qualifier[AIdx: Integer]: ICQLSelectQualifier read _GetQualifier; default;
  end;

  ICQLSelect = interface(ICQLSection)
    ['{E7EE1220-ACB9-4A02-82E5-C4F51AD2D333}']
    procedure Clear;
    function IsEmpty: Boolean;
    function Columns: ICQLNames;
    function TableNames: ICQLNames;
    function Qualifiers: ICQLSelectQualifiers;
    function Serialize: String;
  end;

  ICQLWhere = interface(ICQLSection)
    ['{664D8830-662B-4993-BD9C-325E6C1A2ACA}']
    function _GetExpression: ICQLExpression;
    procedure _SetExpression(const Value: ICQLExpression);
    //
    function Serialize: String;
    property Expression: ICQLExpression read _GetExpression write _SetExpression;
  end;

  ICQLDelete = interface(ICQLSection)
    ['{8823EABF-FCFB-4BDE-AF56-7053944D40DB}']
    function TableNames: ICQLNames;
    function Serialize: String;
  end;

  TJoinType = (jtINNER, jtLEFT, jtRIGHT, jtFULL);

  ICQLJoin = interface(ICQLSection)
    ['{BCB6DF85-05DE-43A0-8622-5627B88FB914}']
    function _GetCondition: ICQLExpression;
    function _GetJoinedTable: ICQLName;
    function _GetJoinType: TJoinType;
    procedure _SetCondition(const Value: ICQLExpression);
    procedure _SetJoinedTable(const Value: ICQLName);
    procedure _SetJoinType(const Value: TJoinType);
    //
    property JoinedTable: ICQLName read _GetJoinedTable write _SetJoinedTable;
    property JoinType: TJoinType read _GetJoinType write _SetJoinType;
    property Condition: ICQLExpression read _GetCondition write _SetCondition;
  end;

  ICQLJoins = interface
    ['{2A9F9075-01C3-433A-9E65-0264688D2E88}']
    function _GetJoins(AIdx: Integer): ICQLJoin;
    procedure _SetJoins(AIdx: Integer; const Value: ICQLJoin);
    //
    function Add: ICQLJoin; overload;
    procedure Add(const AJoin: ICQLJoin); overload;
    procedure Clear;
    function Count: Integer;
    function IsEmpty: Boolean;
    function Serialize: String;
    property Joins[AIidx: Integer]: ICQLJoin read _GetJoins write _SetJoins; default;
  end;

  ICQLGroupBy = interface(ICQLSection)
    ['{820E003C-81FF-49BB-A7AC-2F00B58BE497}']
    function Columns: ICQLNames;
    function Serialize: String;
  end;

  ICQLHaving = interface(ICQLSection)
    ['{FAD8D0B5-CF5A-4615-93A5-434D4B399E28}']
    function _GetExpression: ICQLExpression;
    procedure _SetExpression(const Value: ICQLExpression);
    //
    function Serialize: String;
    property Expression: ICQLExpression read _GetExpression write _SetExpression;
  end;

  ICQLNameValue = interface
    ['{FC6C53CA-7CD1-475B-935C-B356E73105CF}']
    function  _GetName: String;
    function  _GetValue: String;
    procedure _SetName(const Value: String);
    procedure _SetValue(const Value: String);
    //
    procedure Clear;
    function IsEmpty: Boolean;
    property Name: String read _GetName write _SetName;
    property Value: String read _GetValue write _SetValue;
  end;

  ICQLNameValuePairs = interface
    ['{561CA151-60B9-45E1-A443-5BAEC88DA955}']
    function  _GetItem(AIdx: integer): ICQLNameValue;
    //
    function Add: ICQLNameValue; overload;
    procedure Add(const ANameValue: ICQLNameValue); overload;
    procedure Clear;
    function Count: Integer;
    function IsEmpty: Boolean;
    property Item[AIdx: Integer]: ICQLNameValue read _GetItem; default;
  end;

  ICQLInsert = interface(ICQLSection)
    ['{61136DB2-EBEB-46D1-8B9B-F5B6DBD1A423}']
    function  _GetTableName: String;
    procedure _SetTableName(const value: String);
    //
    function Columns: ICQLNames;
    function Values: ICQLNameValuePairs;
    function Serialize: String;
    property TableName: String read _GetTableName write _SetTableName;
  end;

  ICQLUpdate = interface(ICQLSection)
    ['{90F7AC38-6E5A-4F5F-9A78-482FE2DBF7B1}']
    function  _GetTableName: String;
    procedure _SetTableName(const value: String);
    //
    function Values: ICQLNameValuePairs;
    function Serialize: String;
    property TableName: String read _GetTableName write _SetTableName;
  end;

  ICQLAST = interface
    ['{09DC93FD-ABC4-4999-80AE-124EC1CAE9AC}']
    function _GetASTColumns: ICQLNames;
    procedure _SetASTColumns(const Value: ICQLNames);
    function _GetASTSection: ICQLSection;
    procedure _SetASTSection(const Value: ICQLSection);
    function _GetASTName: ICQLName;
    procedure _SetASTName(const Value: ICQLName);
    function _GetASTTableNames: ICQLNames;
    procedure _SetASTTableNames(const Value: ICQLNames);
    //
    procedure Clear;
    function IsEmpty: Boolean;
    function Select: ICQLSelect;
    function Delete: ICQLDelete;
    function Insert: ICQLInsert;
    function Update: ICQLUpdate;
    function Joins: ICQLJoins;
    function Where: ICQLWhere;
    function GroupBy: ICQLGroupBy;
    function Having: ICQLHaving;
    function OrderBy: ICQLOrderBy;
    property ASTColumns: ICQLNames read _GetASTColumns write _SetASTColumns;
    property ASTSection: ICQLSection read _GetASTSection write _SetASTSection;
    property ASTName: ICQLName read _GetASTName write _SetASTName;
    property ASTTableNames: ICQLNames read _GetASTTableNames write _SetASTTableNames;
  end;

  ICQLSerialize = interface
    ['{8F7A3C1F-2704-401F-B1DF-D334EEFFC8B7}']
    function AsString(const AAST: ICQLAST): String;
  end;

  TCQLOperatorCompare  = (fcEqual, fcNotEqual,
                          fcGreater, fcGreaterEqual,
                          fcLess, fcLessEqual,
                          fcIn, fcNotIn,
                          fcIsNull, fcIsNotNull,
                          fcBetween, fcNotBetween,
                          fcExists, fcNotExists,
                          fcLikeFull, fcLikeLeft, fcLikeRight,
                          fcNotLikeFull, fcNotLikeLeft, fcNotLikeRight,
                          fcLike, fcNotLike);

  TCQLDataFieldType = (dftUnknown, dftString, dftInteger, dftFloat, dftDate,
                       dftArray, dftText, dftDateTime, dftGuid, dftBoolean);

  ICQLOperator = interface
    ['{A07D4935-0C52-4D8A-A3CF-5837AFE01C75}']
    function _GetColumnName: String;
    function _GetCompare: TCQLOperatorCompare;
    function _GetValue: Variant;
    function _GetDataType: TCQLDataFieldType;
    procedure _SetColumnName(const Value: String);
    procedure _SetCompare(const Value: TCQLOperatorCompare);
    procedure _SetValue(const Value: Variant);
    procedure _SetDataType(const Value: TCQLDataFieldType);

    property ColumnName: String read _GetColumnName write _SetColumnName;
    property Compare: TCQLOperatorCompare read _GetCompare write _SetCompare;
    property Value: Variant read _GetValue write _SetValue;
    property DataType: TCQLDataFieldType read _GetDataType   write _SetDataType;
    function AsString: String;
  end;

  ICQLOperators = interface
    ['{7F855D42-FB26-4F21-BCBE-93BC407ED15B}']
    function IsEqual(const AValue: Extended) : String; overload;
    function IsEqual(const AValue: Integer): String; overload;
    function IsEqual(const AValue: String): String; overload;
    function IsEqual(const AValue: TDate): String; overload;
    function IsEqual(const AValue: TDateTime): String; overload;
    function IsEqual(const AValue: TGUID): String; overload;
    function IsNotEqual(const AValue: Extended): String; overload;
    function IsNotEqual(const AValue: Integer): String; overload;
    function IsNotEqual(const AValue: String): String; overload;
    function IsNotEqual(const AValue: TDate): String; overload;
    function IsNotEqual(const AValue: TDateTime): String; overload;
    function IsNotEqual(const AValue: TGUID): String; overload;
    function IsGreaterThan(const AValue: Extended): String; overload;
    function IsGreaterThan(const AValue: Integer): String; overload;
    function IsGreaterThan(const AValue: TDate): String; overload;
    function IsGreaterThan(const AValue: TDateTime): String; overload;
    function IsGreaterEqThan(const AValue: Extended): String; overload;
    function IsGreaterEqThan(const AValue: Integer): String; overload;
    function IsGreaterEqThan(const AValue: TDate): String; overload;
    function IsGreaterEqThan(const AValue: TDateTime): String; overload;
    function IsLessThan(const AValue: Extended): String; overload;
    function IsLessThan(const AValue: Integer): String; overload;
    function IsLessThan(const AValue: TDate): String; overload;
    function IsLessThan(const AValue: TDateTime): String; overload;
    function IsLessEqThan(const AValue: Extended): String; overload;
    function IsLessEqThan(const AValue: Integer) : String; overload;
    function IsLessEqThan(const AValue: TDate) : String; overload;
    function IsLessEqThan(const AValue: TDateTime) : String; overload;
    function IsNull: String;
    function IsNotNull: String;
    function IsLike(const AValue: String): String;
    function IsLikeFull(const AValue: String): String;
    function IsLikeLeft(const AValue: String): String;
    function IsLikeRight(const AValue: String): String;
    function IsNotLike(const AValue: String): String;
    function IsNotLikeFull(const AValue: String): String;
    function IsNotLikeLeft(const AValue: String): String;
    function IsNotLikeRight(const AValue: String): String;

    function IsIn(const AValue: TArray<Double>): String; overload;
    function IsIn(const AValue: TArray<String>): String; overload;
    function IsIn(const AValue: String): String; overload;
    function IsNotIn(const AValue: TArray<Double>): String; overload;
    function IsNotIn(const AValue: TArray<String>): String; overload;
    function IsNotIn(const AValue: String): String; overload;
    function IsExists(const AValue: String): String; overload;
    function IsNotExists(const AValue: String): String; overload;
  end;

  ICQLFunctions = interface
    ['{5035E399-D3F0-48C6-BACB-9CA6D94B2BE7}']
    function Count(const AValue: String): String;
    function Lower(const AValue: String): String;
    function Min(const AValue: String): String;
    function Max(const AValue: String): String;
    function Upper(const AValue: String): String;
    function SubString(const AVAlue: String; const AFrom, AFor: Integer): String;
    function Date(const AVAlue: String; const AFormat: String): String; overload;
    function Date(const AVAlue: String): String; overload;
    function Day(const AValue: String): String;
    function Month(const AValue: String): String;
    function Year(const AValue: String): String;
    function Concat(const AValue: array of String): String;
  end;

implementation

end.
