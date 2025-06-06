unit test.operators.like.firebird;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TTestCQLOperatorsLike = class
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure TestLikeFull;
    [Test]
    procedure TestLikeRight;
    [Test]
    procedure TestLikeLeft;
    [Test]
    procedure TestNotLikeFull;
    [Test]
    procedure TestNotLikeRight;
    [Test]
    procedure TestNotLikeLeft;

   end;

implementation

uses
  SysUtils,
  CQL.Interfaces,
  CQL;

procedure TTestCQLOperatorsLike.Setup;
begin

end;

procedure TTestCQLOperatorsLike.TearDown;
begin

end;

procedure TTestCQLOperatorsLike.TestLikeFull;
var
  LAsString : String;
begin
  LAsString := 'SELECT * FROM CLIENTES WHERE (NOME LIKE ''%VALUE%'')';
  Assert.AreEqual(LAsString, CQuery(dbnFirebird)
                                 .Select
                                 .All
                                 .From('CLIENTES')
                                 .Where('NOME').LikeFull('VALUE')
                                 .AsString);
end;

procedure TTestCQLOperatorsLike.TestLikeLeft;
var
  LAsString : String;
begin
  LAsString := 'SELECT * FROM CLIENTES WHERE (NOME LIKE ''%VALUE'')';
  Assert.AreEqual(LAsString, CQuery(dbnFirebird)
                                 .Select
                                 .All
                                 .From('CLIENTES')
                                 .Where('NOME').LikeLeft('VALUE')
                                 .AsString);
end;

procedure TTestCQLOperatorsLike.TestLikeRight;
var
  LAsString : String;
begin
  LAsString := 'SELECT * FROM CLIENTES WHERE (NOME LIKE ''VALUE%'')';
  Assert.AreEqual(LAsString, CQuery(dbnFirebird)
                                 .Select
                                 .All
                                 .From('CLIENTES')
                                 .Where('NOME').LikeRight('VALUE')
                                 .AsString);
end;

procedure TTestCQLOperatorsLike.TestNotLikeFull;
var
  LAsString : String;
begin
  LAsString := 'SELECT * FROM CLIENTES WHERE (NOME NOT LIKE ''%VALUE%'')';
  Assert.AreEqual(LAsString, CQuery(dbnFirebird)
                                 .Select
                                 .All
                                 .From('CLIENTES')
                                 .Where('NOME').NotLikeFull('VALUE')
                                 .AsString);
end;

procedure TTestCQLOperatorsLike.TestNotLikeLeft;
var
  LAsString : String;
begin
  LAsString := 'SELECT * FROM CLIENTES WHERE (NOME NOT LIKE ''%VALUE'')';
  Assert.AreEqual(LAsString, CQuery(dbnFirebird)
                                 .Select
                                 .All
                                 .From('CLIENTES')
                                 .Where('NOME').NotLikeLeft('VALUE')
                                 .AsString);
end;

procedure TTestCQLOperatorsLike.TestNotLikeRight;
var
  LAsString : String;
begin
  LAsString := 'SELECT * FROM CLIENTES WHERE (NOME NOT LIKE ''VALUE%'')';
  Assert.AreEqual(LAsString, CQuery(dbnFirebird)
                                 .Select
                                 .All
                                 .From('CLIENTES')
                                 .Where('NOME').NotLikeRight('VALUE')
                                 .AsString);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestCQLOperatorsLike);

end.
