unit uPaginaConfiguracoes;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, REST.Types,
  REST.Client, Data.Bind.Components, Data.Bind.ObjectScope,
  FMX.Controls.Presentation, FMX.Edit, FMX.StdCtrls, FMX.Layouts, FMX.ExtCtrls,
  FMX.Objects, FMX.DialogService, System.ImageList, FMX.ImgList;

type
  TfrmPaginaConfiguracoes = class(TForm)
    Layout1: TLayout;
    Rectangle1: TRectangle;
    lblMenu: TLabel;
    Layout2: TLayout;
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
    btnVoltar: TButton;
    ImageList1: TImageList;
    Rectangle2: TRectangle;
    lytOpaco: TLayout;
    Rectangle3: TRectangle;
    lytConfirmaInativacao: TLayout;
    Panel1: TPanel;
    btnSim: TRoundRect;
    Label5: TLabel;
    btnNao: TRoundRect;
    Label10: TLabel;
    lblConfirmacao: TLabel;
    procedure btnEditarLaresClick(Sender: TObject);
    procedure btnEditarAnimaisClick(Sender: TObject);
    procedure btnEditarPerfilClick(Sender: TObject);
    procedure btnAlterarSenhaClick(Sender: TObject);
    procedure ConfirmarInativacao;
    procedure btnDesativarContaClick(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    procedure btnSimClick(Sender: TObject);
    procedure btnNaoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
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

procedure TfrmPaginaConfiguracoes.btnNaoClick(Sender: TObject);
begin
   lytOpaco.Visible := False;
   lytConfirmaInativacao.Visible := False;
end;

procedure TfrmPaginaConfiguracoes.btnSimClick(Sender: TObject);
begin
   ConfirmarInativacao;
end;

procedure TfrmPaginaConfiguracoes.btnVoltarClick(Sender: TObject);
begin
   frmPaginaConfiguracoes.Close;
   frmPaginaInicial.Show;
end;

procedure TfrmPaginaConfiguracoes.btnDesativarContaClick(Sender: TObject);
begin
   lytOpaco.Visible := True;
   lytConfirmaInativacao.Visible := True;
end;

procedure TfrmPaginaConfiguracoes.ConfirmarInativacao;
begin
   try
       dtmServidor.qryUpdate.Active := False;
       dtmServidor.qryUpdate.SQL.Clear;
       dtmServidor.qryUpdate.SQL.Text := ' UPDATE pessoas '+
                                         ' SET ind_ativo = 0 '+
                                         ' WHERE cod_pessoa = :cod_pessoa ';

       dtmServidor.qryUpdate.Params.ParamByName('cod_pessoa').AsString := frmLogin.sUsuarioLogado;

       dtmServidor.qryUpdate.ExecSQL;

       try
           if dtmServidor.fdConexao.InTransaction then
           begin
              dtmServidor.fdConexao.Commit;
           end;
       except
          TLoading.ToastMessage(frmPaginaConfiguracoes,
                             'Não foi possível realizar a operação!',
                              $FFFA3F3F,
                              TAlignLayout.Top);
          Exit;
       end;

   finally
       TLoading.ToastMessage(frmPaginaConfiguracoes,
                        'Conta inativada com sucesso',
                         $FF22AF70,
                         TAlignLayout.Top);

       lytOpaco.Visible := True;
       lytConfirmaInativacao.Visible := True;
       frmLogin.Show;
   end;
end;

procedure TfrmPaginaConfiguracoes.FormShow(Sender: TObject);
begin
   lytOpaco.Visible := False;
   lytConfirmaInativacao.Visible := False;
end;

end.
