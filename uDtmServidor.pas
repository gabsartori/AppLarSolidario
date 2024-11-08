unit uDtmServidor;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, Data.DB,
  FireDAC.Comp.Client, System.IOUtils, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, REST.Types,
  REST.Client, Data.Bind.Components, Data.Bind.ObjectScope;

type
  TdtmServidor = class(TDataModule)
    fdConexao: TFDConnection;
    qryGeral: TFDQuery;
    RESTRequest1: TRESTRequest;
    RESTClient1: TRESTClient;
    RESTResponse1: TRESTResponse;
    qryInsert: TFDQuery;
    qryGeral2: TFDQuery;
    qryUpdate: TFDQuery;
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
             raise Exception.Create('Erro de conex�o com o banco de dados: ' + e.Message);
          end;
       end;
   end;
end;

procedure TdtmServidor.fdConexaoAfterConnect(Sender: TObject);
begin
   fdConexao.ExecSQL(' DROP TABLE IF EXISTS SOLICITACOES;');
   fdConexao.ExecSQL(' DROP TABLE IF EXISTS ANIMAIS;');
   fdConexao.ExecSQL(' DROP TABLE IF EXISTS LARTEMPORARIO;');
   fdConexao.ExecSQL(' DROP TABLE IF EXISTS PESSOAS;');
   fdConexao.ExecSQL(' DROP TABLE IF EXISTS MOTIVOS;');
   fdConexao.ExecSQL(' DROP TABLE IF EXISTS CIDADES;');

   fdConexao.ExecSQL(' CREATE TABLE IF NOT EXISTS Cidades (			       	  '+
                     '     Cod_Cidade  INTEGER PRIMARY KEY AUTOINCREMENT, '+
                     '     Nome_Cidade TEXT    NOT NULL,                  '+
                     '     UF          TEXT    NOT NULL                   '+
                     ' );                                                 ');

   fdConexao.ExecSQL(' CREATE TABLE IF NOT EXISTS Pessoas (	   				              '+
                     '     Cod_Pessoa      INTEGER PRIMARY KEY AUTOINCREMENT,       '+
                     '     Nome_Pessoa     TEXT    NOT NULL,                        '+
                     '     Telefone_Pessoa TEXT,                                    '+
                     '     Des_Rua         TEXT,                                    '+
                     '     UF              TEXT,                                    '+
                     '     Email_Pessoa    TEXT,                                    '+
                     '     Senha_Pessoa    TEXT,                                    '+
                     '     Des_Bairro      TEXT,                                    '+
                     '     Ind_Ativo       INTEGER,                                 '+
                     '     Cod_Cidade      INTEGER,                                 '+
                     '     FOREIGN KEY (Cod_Cidade) REFERENCES Cidades (Cod_Cidade) '+
                     ' );                 										                      ');

   fdConexao.ExecSQL(' CREATE TABLE IF NOT EXISTS Motivos (          '+
                     ' Cod_Motivo INTEGER PRIMARY KEY AUTOINCREMENT, '+
                     ' Descricao TEXT NOT NULL,                      '+
                     ' Status INTEGER                                '+
                     ');                                             ');

  fdConexao.ExecSQL(' CREATE TABLE IF NOT EXISTS LarTemporario (                    '+
                    '     Cod_Lar          INTEGER PRIMARY KEY AUTOINCREMENT,       '+
                    '     Nome_Lar         TEXT    NOT NULL,                        '+
                    '     Des_Endereco_Lar TEXT,                                    '+
                    '     Des_Bairro_Lar   TEXT,                                    '+
                    '     Telefone_Lar     TEXT,                                    '+
                    '     UF               TEXT,                                    '+
                    '     Qtd_Animais      INTEGER,                                 '+
                    '     Informacoes_Lar  TEXT,                                    '+
                    '     Tipo_Animal      TEXT,                                    '+
                    '     Ind_Telas        INTEGER,                                 '+
                    '     Ind_Ativo        INTEGER,                                 '+
                    '     Cod_Pessoa       INTEGER,                                 '+
                    '     Cod_Cidade       INTEGER,                                 '+
                    '     FOREIGN KEY (Cod_Pessoa) REFERENCES Pessoas (Cod_Pessoa), '+
                    '     FOREIGN KEY (Cod_Cidade) REFERENCES Cidades (Cod_Cidade)  '+
                    ' );                                                            ');

  fdConexao.ExecSQL(' CREATE TABLE IF NOT EXISTS Animais (							            '+
                    '     Cod_Animal          INTEGER PRIMARY KEY AUTOINCREMENT,    '+
                    '     Nome_Animal         TEXT    NOT NULL,                     '+
                    '     Genero_Animal       TEXT,                                 '+
                    '     Idade_Animal        TEXT,                                 '+
                    '     Cor_Pelagem         TEXT,                                 '+
                    '     Ind_Ativo           INTEGER,                              '+
                    '     Ind_Castrado        INTEGER,                              '+
                    '     Foto_Animal         BLOB,                                 '+
                    '     Tipo_Animal         TEXT,                                 '+
                    '     Informacoes_Animal  TEXT,                                 '+
                    '     Situacao_Animal     TEXT,                                 '+
                    '     Des_Endereco_Animal TEXT,                                 '+
                    '     Des_Bairro_Animal   TEXT,                                 '+
                    '     UF                  TEXT,                                 '+
                    '     Cod_Lar             INTEGER,                              '+
                    '     Cod_Pessoa          INTEGER,                              '+
                    '     Cod_Cidade          INTEGER,                              '+
                    '     FOREIGN KEY (Cod_Lar) REFERENCES LarTemporario (Cod_Lar), '+
                    '     FOREIGN KEY (Cod_Pessoa) REFERENCES Pessoas (Cod_Pessoa), '+
                    '     FOREIGN KEY (Cod_Cidade) REFERENCES Cidades (Cod_Cidade)  '+
                    ' );															                              ');

  fdConexao.ExecSQL(' CREATE TABLE IF NOT EXISTS Solicitacoes (                '+
                    ' Cod_Solicitacao INTEGER PRIMARY KEY AUTOINCREMENT,       '+
                    ' Tipo_Solicitacao TEXT,                                   '+
                    ' Status_Solicitacao INTEGER,                              '+
                    ' Cod_Motivo INTEGER,                                      '+
                    ' Cod_Pessoa INTEGER,                                      '+
                    ' Cod_Lar INTEGER,                                         '+
                    ' FOREIGN KEY (Cod_Motivo) REFERENCES Motivos(Cod_Motivo), '+
                    ' FOREIGN KEY (Cod_Pessoa) REFERENCES Pessoa(Cod_Pessoa),  '+
                    ' FOREIGN KEY (Cod_Lar) REFERENCES LarTemporario(Cod_Lar)  '+
                    ' );                                                       ');

  fdConexao.ExecSQL(' DELETE FROM SOLICITACOES;');
  fdConexao.ExecSQL(' DELETE FROM ANIMAIS;');
  fdConexao.ExecSQL(' DELETE FROM LARTEMPORARIO;');
  fdConexao.ExecSQL(' DELETE FROM PESSOAS;');
  fdConexao.ExecSQL(' DELETE FROM MOTIVOS;');
  fdConexao.ExecSQL(' DELETE FROM CIDADES;');

  fdConexao.ExecSQL(' INSERT INTO CIDADES (NOME_CIDADE, UF) VALUES (''Passo Fundo'', ''RS''); '+
                    ' INSERT INTO CIDADES (NOME_CIDADE, UF) VALUES (''Marau'', ''RS'');       '+
                    ' INSERT INTO CIDADES (NOME_CIDADE, UF) VALUES (''Itaja�'', ''SC'');      '+
                    ' INSERT INTO CIDADES (NOME_CIDADE, UF) VALUES (''Conc�rdia'', ''SC'');   '+
                    ' INSERT INTO CIDADES (NOME_CIDADE, UF) VALUES (''Cascavel'', ''PR'');    '+
                    ' INSERT INTO CIDADES (NOME_CIDADE, UF) VALUES (''Curitiba'', ''PR'');    ');
end;

end.
