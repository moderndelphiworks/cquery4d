{
      ORM Brasil � um ORM simples e descomplicado para quem utiliza Delphi

                   Copyright (c) 2016, Isaque Pinheiro
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

{ @abstract(ORMBr Framework.)
  @created(20 Jul 2016)
  @author(Isaque Pinheiro <isaquepsp@gmail.com>)
}

{
  Windows MSWINDOWS
  macOS MACOS
  iOS IOS
  Android ANDROID
  Linux LINUX
}

{
  Compiler			CompilerVersion		Defined Symbol	Used BPL
  Delphi 13   ??        	36 			VER370			30
  Delphi 12.3 Athens       	36 			VER360			29
  Delphi 11.1 Alexandria 	35 			VER350			28
  Delphi 10.4 Sidney     	34 			VER340			27
  Delphi 10.3 Rio			33 			VER330			26
  Delphi 10.2 Tokyo	 		32 			VER320			25
  Delphi 10.1 Berlin	 	31			VER310			24
  Delphi 10 Seattle	 		30			VER300      	23
  Delphi XE8		 		29 			VER290      	22
  Delphi XE7		 		28 			VER280          21
  Delphi XE6		 		27 			VER270          20
  Delphi XE5		 		26 			VER260          19
  Delphi XE4		 		25 			VER250          18 
  Delphi XE3		 		24 			VER240          17
  Delphi XE2		 		23 			VER230          16
  Delphi XE	        		22 			VER220          15
  Delphi 2010 	       		21 			VER210          14
}

{$DEFINE VCL}
{.$DEFINE FMX}

// Banco de dados utiliza��o
{$DEFINE FIREBIRD}
{.$DEFINE MSSQL}
{.$DEFINE MYSQL}
{.$DEFINE SQLITE}
{.$DEFINE INTERBASE}
{.$DEFINE DB2}
{.$DEFINE ORACLE}
{.$DEFINE INFORMIX}
{.$DEFINE POSTGRESQL}
{.$DEFINE ADS}
{.$DEFINE ASA}
{.$DEFINE ABSOLUTEDB}
{.$DEFINE MONGODB}
{.$DEFINE ELEVATEDB}
{.$DEFINE NEXUSDB}


{$IFDEF FMX}
  {$DEFINE HAS_FMX}
{$ENDIF}
{$IFDEF VCL}
  {$DEFINE HAS_VCL}
{$ENDIF}

// Delphi ???
{$IFDEF VER370}
  {$DEFINE DELPHI14_UP}
  {$DEFINE DELPHI15_UP}
  {$DEFINE DELPHI16_UP}
  {$DEFINE DELPHI17_UP}
  {$DEFINE DELPHI18_UP}
  {$DEFINE DELPHI19_UP}
  {$DEFINE DELPHI20_UP}
  {$DEFINE DELPHI21_UP}
  {$DEFINE DELPHI22_UP}
  {$DEFINE DELPHI23_UP}
  {$DEFINE DELPHI24_UP}
  {$DEFINE DELPHI25_UP}
  {$DEFINE DELPHI26_UP}
  {$DEFINE DELPHI27_UP}
  {$DEFINE DELPHI28_UP}
  {$DEFINE DELPHI29_UP}
  {$DEFINE DELPHI30_UP}
{$ENDIF}

// Delphi Athens
{$IFDEF VER360}
  {$DEFINE DELPHI14_UP}
  {$DEFINE DELPHI15_UP}
  {$DEFINE DELPHI16_UP}
  {$DEFINE DELPHI17_UP}
  {$DEFINE DELPHI18_UP}
  {$DEFINE DELPHI19_UP}
  {$DEFINE DELPHI20_UP}
  {$DEFINE DELPHI21_UP}
  {$DEFINE DELPHI22_UP}
  {$DEFINE DELPHI23_UP}
  {$DEFINE DELPHI24_UP}
  {$DEFINE DELPHI25_UP}
  {$DEFINE DELPHI26_UP}
  {$DEFINE DELPHI27_UP}
  {$DEFINE DELPHI28_UP}
  {$DEFINE DELPHI29_UP}
{$ENDIF}

// Delphi Alexandria
{$IFDEF VER350}
  {$DEFINE DELPHI14_UP}
  {$DEFINE DELPHI15_UP}
  {$DEFINE DELPHI16_UP}
  {$DEFINE DELPHI17_UP}
  {$DEFINE DELPHI18_UP}
  {$DEFINE DELPHI19_UP}
  {$DEFINE DELPHI20_UP}
  {$DEFINE DELPHI21_UP}
  {$DEFINE DELPHI22_UP}
  {$DEFINE DELPHI23_UP}
  {$DEFINE DELPHI24_UP}
  {$DEFINE DELPHI25_UP}
  {$DEFINE DELPHI26_UP}
  {$DEFINE DELPHI27_UP}
  {$DEFINE DELPHI28_UP}
{$ENDIF}

// Delphi Sidney
{$IFDEF VER340}
  {$DEFINE DELPHI14_UP}
  {$DEFINE DELPHI15_UP}
  {$DEFINE DELPHI16_UP}
  {$DEFINE DELPHI17_UP}
  {$DEFINE DELPHI18_UP}
  {$DEFINE DELPHI19_UP}
  {$DEFINE DELPHI20_UP}
  {$DEFINE DELPHI21_UP}
  {$DEFINE DELPHI22_UP}
  {$DEFINE DELPHI23_UP}
  {$DEFINE DELPHI24_UP}
  {$DEFINE DELPHI25_UP}
  {$DEFINE DELPHI26_UP}
  {$DEFINE DELPHI27_UP}
{$ENDIF}

// Delphi Rio
{$IFDEF VER330}
  {$DEFINE DELPHI14_UP}
  {$DEFINE DELPHI15_UP}
  {$DEFINE DELPHI16_UP}
  {$DEFINE DELPHI17_UP}
  {$DEFINE DELPHI18_UP}
  {$DEFINE DELPHI19_UP}
  {$DEFINE DELPHI20_UP}
  {$DEFINE DELPHI21_UP}
  {$DEFINE DELPHI22_UP}
  {$DEFINE DELPHI23_UP}
  {$DEFINE DELPHI24_UP}
  {$DEFINE DELPHI25_UP}
  {$DEFINE DELPHI26_UP}
{$ENDIF}

// Delphi Tokyo
{$IFDEF VER320}
  {$DEFINE DELPHI14_UP}
  {$DEFINE DELPHI15_UP}
  {$DEFINE DELPHI16_UP}
  {$DEFINE DELPHI17_UP}
  {$DEFINE DELPHI18_UP}
  {$DEFINE DELPHI19_UP}
  {$DEFINE DELPHI20_UP}
  {$DEFINE DELPHI21_UP}
  {$DEFINE DELPHI22_UP}
  {$DEFINE DELPHI23_UP}
  {$DEFINE DELPHI24_UP}
  {$DEFINE DELPHI25_UP}
{$ENDIF}

// Delphi BERLIN
{$IFDEF VER310}
  {$DEFINE DELPHI14_UP}
  {$DEFINE DELPHI15_UP}
  {$DEFINE DELPHI16_UP}
  {$DEFINE DELPHI17_UP}
  {$DEFINE DELPHI18_UP}
  {$DEFINE DELPHI19_UP}
  {$DEFINE DELPHI20_UP}
  {$DEFINE DELPHI21_UP}
  {$DEFINE DELPHI22_UP}
  {$DEFINE DELPHI23_UP}
  {$DEFINE DELPHI24_UP}
{$ENDIF}

// Delphi SEATLLE
{$IFDEF VER300}
  {$DEFINE DELPHI14_UP}
  {$DEFINE DELPHI15_UP}
  {$DEFINE DELPHI16_UP}
  {$DEFINE DELPHI17_UP}
  {$DEFINE DELPHI18_UP}
  {$DEFINE DELPHI19_UP}
  {$DEFINE DELPHI20_UP}
  {$DEFINE DELPHI21_UP}
  {$DEFINE DELPHI22_UP}
  {$DEFINE DELPHI23_UP}
{$ENDIF}

// Delphi XE8
{$IFDEF VER290}
  {$DEFINE DELPHI14_UP}
  {$DEFINE DELPHI15_UP}
  {$DEFINE DELPHI16_UP}
  {$DEFINE DELPHI17_UP}
  {$DEFINE DELPHI18_UP}
  {$DEFINE DELPHI19_UP}
  {$DEFINE DELPHI20_UP}
  {$DEFINE DELPHI21_UP}
  {$DEFINE DELPHI22_UP}
{$ENDIF}

// Delphi XE7
{$IFDEF VER280}
  {$DEFINE DELPHI14_UP}
  {$DEFINE DELPHI15_UP}
  {$DEFINE DELPHI16_UP}
  {$DEFINE DELPHI17_UP}
  {$DEFINE DELPHI18_UP}
  {$DEFINE DELPHI19_UP}
  {$DEFINE DELPHI20_UP}
  {$DEFINE DELPHI21_UP}
{$ENDIF}

// Delphi XE6
{$IFDEF VER270}
  {$DEFINE DELPHI14_UP}
  {$DEFINE DELPHI15_UP}
  {$DEFINE DELPHI16_UP}
  {$DEFINE DELPHI17_UP}
  {$DEFINE DELPHI18_UP}
  {$DEFINE DELPHI19_UP}
  {$DEFINE DELPHI20_UP}
{$ENDIF}

// Delphi XE5
{$IFDEF VER260}
  {$DEFINE DELPHI14_UP}
  {$DEFINE DELPHI15_UP}
  {$DEFINE DELPHI16_UP}
  {$DEFINE DELPHI17_UP}
  {$DEFINE DELPHI18_UP}
  {$DEFINE DELPHI19_UP}
{$ENDIF}

// Delphi XE4
{$IFDEF VER250}
  {$DEFINE DELPHI14_UP}
  {$DEFINE DELPHI15_UP}
  {$DEFINE DELPHI16_UP}
  {$DEFINE DELPHI17_UP}
  {$DEFINE DELPHI18_UP}
{$ENDIF}

// Delphi XE3
{$IFDEF VER240}
  {$DEFINE DELPHI14_UP}
  {$DEFINE DELPHI15_UP}
  {$DEFINE DELPHI16_UP}
  {$DEFINE DELPHI17_UP}
{$ENDIF}

// Delphi XE2
{$IFDEF VER230}
  {$DEFINE DELPHI14_UP}
  {$DEFINE DELPHI15_UP}
  {$DEFINE DELPHI16_UP}
{$ENDIF}

// Delphi XE
{$IFDEF VER220}
  {$DEFINE DELPHI14_UP}
  {$DEFINE DELPHI15_UP}
{$ENDIF}

//Delphi 2010
{$IFDEF VER210}
  {$DEFINE DELPHI14_UP}
{$ENDIF}

//Lazarus
{$IFDEF FCP}
  {$DEFINE DELPHI14_UP}
{$ENDIF}

{$IFDEF DELPHI15_UP}
  {$DEFINE FORMATSETTINGS}
{$ENDIF}

{$IFDEF DELPHI17_UP}
  {$DEFINE HAS_NET_ENCODING}
{$ELSE IFDEF DELPHI16_UP}
  {$DEFINE HAS_SOAP_ENCODING}
{$ELSE}
  {$DEFINE HAS_ENCDDECD}
{$ENDIF}
