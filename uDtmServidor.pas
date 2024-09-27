unit uDtmServidor;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, Data.DB,
  FireDAC.Comp.Client, System.IOUtils, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet;

type
  TdtmServidor = class(TDataModule)
    fdConexao: TFDConnection;
    qryGeral: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure fdConexaoAfterConnect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dtmServidor: TdtmServidor;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TdtmServidor.DataModuleCreate(Sender: TObject);
begin
   with fdConexao do
   begin
      Params.Values['DriverID'] := 'SQLite';

      {$IFDEF MSWINDOWS}
      Params.Values['Database'] := System.SysUtils.GetCurrentDir + '\Banco\LarSolidario.db';
      {$ELSE}
      Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, 'LarSolidario.db');
      {$ENDIF}

       try
          fdConexao.Connected := true;
       except
          on e:exception do
          begin
             raise Exception.Create('Erro de conexão com o banco de dados: ' + e.Message);
          end;
       end;
   end;
end;

procedure TdtmServidor.fdConexaoAfterConnect(Sender: TObject);
begin
   fdConexao.ExecSQL(' create table if not exists Pessoa (               '+
                     ' Cod_Pessoa     INTEGER PRIMARY KEY AUTOINCREMENT, '+
                     ' Nome           TEXT    NOT NULL,                  '+
                     ' Telefone       TEXT,                              '+
                     ' Dta_Nascimento DATE,                              '+
                     ' CEP            TEXT,                              '+
                     ' Rua            TEXT,                              '+
                     ' Bairro         TEXT,                              '+
                     ' Cidade         TEXT,                              '+
                     ' Estado         TEXT,                              '+
                     ' Email          TEXT,                              '+
                     ' Senha          TEXT,                              '+
                     ' Ind_Ativo      BOOLEAN DEFAULT 1);                ');

   fdConexao.ExecSQL(' create table if not exists Motivos (          '+
                     ' Cod_Motivo INTEGER PRIMARY KEY AUTOINCREMENT, '+
                     ' Descricao  TEXT,                              '+
                     ' Status     BOOLEAN DEFAULT 1);                ');

  fdConexao.ExecSQL(' create table if not exists Lar_Temporario (               '+
                    ' Cod_Lar     INTEGER PRIMARY KEY AUTOINCREMENT,            '+
                    ' Nome_Pessoa TEXT,                                         '+
                    ' Endereco    TEXT,                                         '+
                    ' Telefone    TEXT,                                         '+
                    ' Qtd_Animais INTEGER,                                      '+
                    ' Ind_Telas   BOOLEAN DEFAULT 0,                            '+
                    ' Informacoes TEXT,                                         '+
                    ' Ind_Ativo   BOOLEAN DEFAULT 1,                            '+
                    ' Cod_Pessoa  INTEGER,                                      '+
                    ' FOREIGN KEY (Cod_Pessoa) REFERENCES Pessoa (Cod_Pessoa)); ');

  fdConexao.ExecSQL(' create table if not exists Animais (                       '+
                    ' Cod_Animal  INTEGER PRIMARY KEY AUTOINCREMENT,             '+
                    ' Nome        TEXT,                                          '+
                    ' Genero      TEXT,                                          '+
                    ' Cor_Pelagem TEXT,                                          '+
                    ' Tipo_Animal TEXT,                                          '+
                    ' Ind_Ativo   BOOLEAN DEFAULT 1,                             '+
                    ' Foto        BLOB,                                          '+
                    ' Cod_Pessoa  INTEGER,                                       '+
                    ' Cod_Lar     INTEGER,                                       '+
                    ' FOREIGN KEY (Cod_Pessoa) REFERENCES Pessoa (Cod_Pessoa),   '+
                    ' FOREIGN KEY (Cod_Lar) REFERENCES Lar_Temporario (Cod_Lar));');

  fdConexao.ExecSQL(' create table if not exists Solicitacoes (                   '+
                    ' Cod_Solicitacao  INTEGER PRIMARY KEY AUTOINCREMENT,         '+
                    ' Status           TEXT,                                      '+
                    ' Tipo_Solicitacao TEXT,                                      '+
                    ' Cod_Motivo       INTEGER,                                   '+
                    ' Cod_Pessoa       INTEGER,                                   '+
                    ' Cod_Lar          INTEGER,                                   '+
                    ' FOREIGN KEY (Cod_Motivo) REFERENCES Motivos (Cod_Motivo),   '+
                    ' FOREIGN KEY (Cod_Pessoa) REFERENCES Pessoa (Cod_Pessoa),    '+
                    ' FOREIGN KEY (Cod_Lar) REFERENCES Lar_Temporario (Cod_Lar)); ');
end;

end.
