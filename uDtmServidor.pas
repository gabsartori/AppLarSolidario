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
//   fdConexao.ExecSQL(' DROP TABLE IF EXISTS SOLICITACOES;');
//   fdConexao.ExecSQL(' DROP TABLE IF EXISTS ANIMAIS;');
//   fdConexao.ExecSQL(' DROP TABLE IF EXISTS LARTEMPORARIO;');
//   fdConexao.ExecSQL(' DROP TABLE IF EXISTS PESSOAS;');
//   fdConexao.ExecSQL(' DROP TABLE IF EXISTS MOTIVOS;');
//   fdConexao.ExecSQL(' DROP TABLE IF EXISTS CIDADES;');

   fdConexao.ExecSQL(' CREATE TABLE IF NOT EXISTS cidades (			       	  '+
                     '     cod_cidade  INTEGER PRIMARY KEY AUTOINCREMENT, '+
                     '     nome_cidade TEXT    NOT NULL,                  '+
                     '     UF          TEXT    NOT NULL                   '+
                     ' );                                                 ');

   fdConexao.ExecSQL(' CREATE TABLE IF NOT EXISTS Pessoas (	   				                 '+
                     '        cod_pessoa      INTEGER PRIMARY KEY AUTOINCREMENT,       '+
                     '        nome_pessoa     TEXT    NOT NULL,                        '+
                     '        telefone_pessoa TEXT,                                    '+
                     '        des_rua         TEXT,                                    '+
                     '        UF              TEXT,                                    '+
                     '        email_pessoa    TEXT,                                    '+
                     '        senha_pessoa    TEXT,                                    '+
                     '        des_bairro      TEXT,                                    '+
                     '        ind_ativo       INTEGER,                                 '+
                     '        cod_cidade      INTEGER,                                 '+
                     '        FOREIGN KEY (cod_cidade) REFERENCES cidades (cod_cidade) '+
                     ' );                 										                         ');

   fdConexao.ExecSQL(' CREATE TABLE IF NOT EXISTS Motivos (                 '+
                     '        cod_motivo INTEGER PRIMARY KEY AUTOINCREMENT, '+
                     '        descricao TEXT NOT NULL                       '+
                     ' );                                                   ');

  fdConexao.ExecSQL(' CREATE TABLE IF NOT EXISTS LarTemporario (                       '+
                    '        cod_lar          INTEGER PRIMARY KEY AUTOINCREMENT,       '+
                    '        nome_lar         TEXT    NOT NULL,                        '+
                    '        des_endereco_lar TEXT,                                    '+
                    '        des_bairro_lar   TEXT,                                    '+
                    '        telefone_lar     TEXT,                                    '+
                    '        UF               TEXT,                                    '+
                    '        qtd_animais      INTEGER,                                 '+
                    '        informacoes_lar  TEXT,                                    '+
                    '        tipo_animal      TEXT,                                    '+
                    '        ind_telas        INTEGER,                                 '+
                    '        ind_ativo        INTEGER,                                 '+
                    '        cod_pessoa       INTEGER,                                 '+
                    '        cod_cidade       INTEGER,                                 '+
                    '        FOREIGN KEY (cod_pessoa) REFERENCES Pessoas (cod_pessoa), '+
                    '        FOREIGN KEY (cod_cidade) REFERENCES Cidades (cod_cidade)  '+
                    ' );                                                               ');

  fdConexao.ExecSQL(' CREATE TABLE IF NOT EXISTS Animais (							               '+
                    '        cod_animal          INTEGER PRIMARY KEY AUTOINCREMENT,    '+
                    '        nome_animal         TEXT    NOT NULL,                     '+
                    '        genero_animal       TEXT,                                 '+
                    '        idade_animal        TEXT,                                 '+
                    '        cor_pelagem         TEXT,                                 '+
                    '        ind_ativo           INTEGER,                              '+
                    '        ind_castrado        INTEGER,                              '+
                    '        foto_animal         BLOB,                                 '+
                    '        tipo_animal         TEXT,                                 '+
                    '        informacoes_animal  TEXT,                                 '+
                    '        situacao_animal     TEXT,                                 '+
                    '        des_endereco_animal TEXT,                                 '+
                    '        des_bairro_animal   TEXT,                                 '+
                    '        UF                  TEXT,                                 '+
                    '        cod_lar             INTEGER,                              '+
                    '        cod_pessoa          INTEGER,                              '+
                    '        cod_cidade          INTEGER,                              '+
                    '        FOREIGN KEY (cod_lar) REFERENCES LarTemporario (cod_lar), '+
                    '        FOREIGN KEY (cod_pessoa) REFERENCES Pessoas (cod_pessoa), '+
                    '        FOREIGN KEY (cod_cidade) REFERENCES Cidades (cod_cidade)  '+
                    ' );															                                 ');

  fdConexao.ExecSQL(' CREATE TABLE IF NOT EXISTS Solicitacoes (                       '+
                    '        cod_solicitacao INTEGER PRIMARY KEY AUTOINCREMENT,       '+
                    '        tipo_solicitacao TEXT,                                   '+
                    '        status_solicitacao INTEGER,                              '+
                    '        cod_motivo INTEGER,                                      '+
                    '        cod_animal INTEGER,                                      '+
                    '        cod_pessoa_solicitada INTEGER,                           '+
                    '        cod_pessoa INTEGER,                                      '+
                    '        cod_lar INTEGER,                                         '+
                    '        FOREIGN KEY (cod_motivo) REFERENCES Motivos(cod_motivo), '+
                    '        FOREIGN KEY (cod_animal) REFERENCES Animais(cod_animal), '+
                    '        FOREIGN KEY (cod_pessoa) REFERENCES Pessoas(cod_pessoa), '+
                    '        FOREIGN KEY (cod_lar) REFERENCES LarTemporario(cod_lar)  '+
                    ' );                                                              ');

  fdConexao.ExecSQL(' DELETE FROM SOLICITACOES;');
  fdConexao.ExecSQL(' DELETE FROM ANIMAIS;');
  fdConexao.ExecSQL(' DELETE FROM LARTEMPORARIO;');
  fdConexao.ExecSQL(' DELETE FROM PESSOAS;');
  fdConexao.ExecSQL(' DELETE FROM MOTIVOS;');
  fdConexao.ExecSQL(' DELETE FROM CIDADES;');

//  fdConexao.ExecSQL(' INSERT INTO CIDADES (NOME_CIDADE, UF) VALUES (''Passo Fundo'', ''RS''); '+
//                    ' INSERT INTO CIDADES (NOME_CIDADE, UF) VALUES (''Marau'', ''RS'');       '+
//                    ' INSERT INTO CIDADES (NOME_CIDADE, UF) VALUES (''Itaja�'', ''SC'');      '+
//                    ' INSERT INTO CIDADES (NOME_CIDADE, UF) VALUES (''Conc�rdia'', ''SC'');   '+
//                    ' INSERT INTO CIDADES (NOME_CIDADE, UF) VALUES (''Cascavel'', ''PR'');    '+
//                    ' INSERT INTO CIDADES (NOME_CIDADE, UF) VALUES (''Curitiba'', ''PR'');    ');
//
//  fdConexao.ExecSQL(' INSERT INTO MOTIVOS (DESCRICAO) VALUES (''Pet j� foi adotado'');           '+
//                    ' INSERT INTO MOTIVOS (DESCRICAO) VALUES (''Lar n�o possui telas'');         '+
//                    ' INSERT INTO MOTIVOS (DESCRICAO) VALUES (''Pet n�o est� mais dispon�vel''); ');
end;

end.
