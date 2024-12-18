unit uPaginaInicial;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, REST.Types,
  REST.Client, Data.Bind.Components, Data.Bind.ObjectScope,
  FMX.Controls.Presentation, FMX.Edit, FMX.StdCtrls, FMX.Layouts, FMX.ExtCtrls,
  FMX.Objects;

type
  TfrmPaginaInicial = class(TForm)
    Layout1: TLayout;
    Rectangle1: TRectangle;
    lblUsuario: TLabel;
    Label3: TLabel;
    Layout2: TLayout;
    Layout3: TLayout;
    Layout4: TLayout;
    Layout5: TLayout;
    btnBuscarAnimais: TRoundRect;
    Label4: TLabel;
    Layout6: TLayout;
    btnCadastrarAnimais: TRoundRect;
    Label1: TLabel;
    Layout7: TLayout;
    btnCadastrarLar: TRoundRect;
    Label2: TLabel;
    imgSair: TImage;
    Image1: TImage;
    imgNotificacoes: TImage;
    imgConfiguracoes: TImage;
    lblQtdNotificacoes: TLabel;
    Circle1: TCircle;
    procedure FormShow(Sender: TObject);
    procedure imgSairClick(Sender: TObject);
    procedure btnCadastrarLarClick(Sender: TObject);
    procedure btnCadastrarAnimaisClick(Sender: TObject);
    procedure btnBuscarAnimaisClick(Sender: TObject);
    procedure imgConfiguracoesClick(Sender: TObject);
    procedure imgNotificacoesClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Circle1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPaginaInicial: TfrmPaginaInicial;

implementation

{$R *.fmx}

uses uFrmLogin, uFrmCadastroLarTemporario, uFrmCadastroAnimais, uFrmPaginaBuscas,
  uPaginaConfiguracoes, uFrmNotificacoes, uDtmServidor;

procedure TfrmPaginaInicial.btnBuscarAnimaisClick(Sender: TObject);
begin
   frmPaginaBuscas.Show;
end;

procedure TfrmPaginaInicial.btnCadastrarAnimaisClick(Sender: TObject);
begin
   frmCadastroAnimais.Show;
end;

procedure TfrmPaginaInicial.btnCadastrarLarClick(Sender: TObject);
begin
   frmCadastroLarTemporario.Show;
end;

procedure TfrmPaginaInicial.Circle1Click(Sender: TObject);
begin
   imgNotificacoesClick(Sender);
end;

procedure TfrmPaginaInicial.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   frmPaginaInicial.Close;
   lblQtdNotificacoes.Text := '0';
end;

procedure TfrmPaginaInicial.FormShow(Sender: TObject);
var
   i: Integer;
begin
   lblUsuario.Text := 'Bem-Vindo(a), '+ frmLogin.sNomeUsuarioLogado +'!';
   dtmServidor.qryGeral.Active := False;
   dtmServidor.qryGeral.SQL.Text := '';
   dtmServidor.qryGeral.SQL.Text := ' SELECT status_solicitacao,                      '+
                                    '        cod_pessoa,                              '+
                                    '        cod_pessoa_solicitada                    '+
                                    ' FROM solicitacoes                               '+
                                    ' WHERE status_solicitacao IN (0,1,2)             '+
                                    ' AND (cod_pessoa_solicitada = '+frmLogin.sUsuarioLogado+
                                    ' OR cod_pessoa = '+frmLogin.sUsuarioLogado+')    ';
   dtmServidor.qryGeral.Active := True;

   if (dtmServidor.qryGeral.RecordCount > 0) then
   begin
      i := 0;
      dtmServidor.qryGeral.First;

      while not dtmServidor.qryGeral.Eof do
      begin
         if (dtmServidor.qryGeral.FieldByName('cod_pessoa_solicitada').AsString = frmLogin.sUsuarioLogado) and
            (dtmServidor.qryGeral.FieldByName('status_solicitacao').AsString = '0') then
         begin
            i := i + 1;
         end
         else
         if (dtmServidor.qryGeral.FieldByName('cod_pessoa').AsString = frmLogin.sUsuarioLogado) and
            ((dtmServidor.qryGeral.FieldByName('status_solicitacao').AsString = '1') or
             (dtmServidor.qryGeral.FieldByName('status_solicitacao').AsString = '2')) then
         begin
            i := i + 1;
         end;

         dtmServidor.qryGeral.Next;
      end;

      lblQtdNotificacoes.Text := IntToStr(i);
   end
   else
   begin
      lblQtdNotificacoes.Text := '0';
   end;

end;

procedure TfrmPaginaInicial.imgConfiguracoesClick(Sender: TObject);
begin
   frmPaginaConfiguracoes.Show;
end;

procedure TfrmPaginaInicial.imgNotificacoesClick(Sender: TObject);
begin
   frmNotificacoes.Show;
   frmPaginaInicial.Close;
end;

procedure TfrmPaginaInicial.imgSairClick(Sender: TObject);
begin
   frmLogin.sUsuarioLogado := '';
   frmLogin.sNomeUsuarioLogado := '';
   frmLogin.edtUsuario.Text := '';
   frmLogin.edtSenha.Text := '';
   frmPaginaInicial.Close;
   frmLogin.Show;
end;

end.
