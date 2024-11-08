unit uPaginaConfiguracoes;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, REST.Types,
  REST.Client, Data.Bind.Components, Data.Bind.ObjectScope,
  FMX.Controls.Presentation, FMX.Edit, FMX.StdCtrls, FMX.Layouts, FMX.ExtCtrls,
  FMX.Objects, FMX.DialogService;

type
  TfrmPaginaConfiguracoes = class(TForm)
    Layout1: TLayout;
    Rectangle1: TRectangle;
    lblMenu: TLabel;
    Layout2: TLayout;
    imgSair: TImage;
    Image1: TImage;
    Image3: TImage;
    VertScrollBox1: TVertScrollBox;
    Layout3: TLayout;
    Label1: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    btnEditarLares: TButton;
    btnEditarAnimais: TButton;
    btnAlterarSenha: TButton;
    btnDesativarConta: TButton;
    btnEditarPerfil: TButton;
    procedure imgSairClick(Sender: TObject);
    procedure btnEditarLaresClick(Sender: TObject);
    procedure btnEditarAnimaisClick(Sender: TObject);
    procedure btnEditarPerfilClick(Sender: TObject);
    procedure btnAlterarSenhaClick(Sender: TObject);
    procedure ConfirmarInativacao;
    procedure btnDesativarContaClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPaginaConfiguracoes: TfrmPaginaConfiguracoes;

implementation

{$R *.fmx}

uses uPaginaInicial, uFrmEdicaoLares, uFrmEdicaoAnimais, uFrmEditarCadastro,
  uFrmAlterarSenha, uFrmLogin, uDtmServidor, uCriarCadastro, Notificacao;

procedure TfrmPaginaConfiguracoes.btnAlterarSenhaClick(Sender: TObject);
begin
   frmAlterarSenha.Show;
end;

procedure TfrmPaginaConfiguracoes.btnEditarAnimaisClick(Sender: TObject);
begin
   frmEdicaoAnimais.Show;
end;

procedure TfrmPaginaConfiguracoes.btnEditarLaresClick(Sender: TObject);
begin
   frmEdicaoLares.Show;
end;

procedure TfrmPaginaConfiguracoes.btnEditarPerfilClick(Sender: TObject);
begin
   frmEditarCadastro.Show;
end;

procedure TfrmPaginaConfiguracoes.btnDesativarContaClick(Sender: TObject);
begin
   ConfirmarInativacao;
end;

procedure TfrmPaginaConfiguracoes.ConfirmarInativacao;
begin
   TDialogService.MessageDialog(
       'Deseja realmente desativar sua conta?',
       TMsgDlgType.mtConfirmation,
       [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
       TMsgDlgBtn.mbNo, // Bot�o padr�o
       0,
       procedure(const AResult: TModalResult)
       begin
         if AResult = mrYes then
         begin
           try
               dtmServidor.qryUpdate.Active := False;
               dtmServidor.qryUpdate.SQL.Clear;
               dtmServidor.qryUpdate.SQL.Text := ' UPDATE PESSOAS '+
                                                 ' SET IND_ATIVO = 0 '+
                                                 ' WHERE COD_PESSOA = :COD_PESSOA ';

               dtmServidor.qryUpdate.Params.ParamByName('COD_PESSOA').AsString := frmLogin.sUsuarioLogado;

               dtmServidor.qryInsert.ExecSQL;

               try
                   if dtmServidor.fdConexao.InTransaction then
                   begin
                      dtmServidor.fdConexao.Commit;
                   end;
               except
                  TLoading.ToastMessage(frmCriarCadastro,
                                     'N�o foi poss�vel realizar a opera��o!',
                                      $FFFA3F3F,
                                      TAlignLayout.Top);
                  Exit;
               end;

           finally
               TLoading.ToastMessage(frmCriarCadastro,
                                'Conta inativada com sucesso',
                                 $FF22AF70,
                                 TAlignLayout.Top);

               frmLogin.Show;
           end;
         end
         else
         begin
            // C�digo caso o usu�rio cancele a exclus�o
            ShowMessage('A��o cancelada!');
         end;
       end
   );
end;

procedure TfrmPaginaConfiguracoes.imgSairClick(Sender: TObject);
begin
   frmPaginaInicial.Show;
end;

end.
