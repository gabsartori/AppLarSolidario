unit Frame.EditarLaresTemporarios;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, FMX.DialogService, FMX.VirtualKeyboard,
  FMX.Platform;

type
  TFrameEditarLaresTemporarios = class(TFrame)
    lblNome: TLabel;
    lblEndereco: TLabel;
    lblTelefone: TLabel;
    lblTipoAnimal: TLabel;
    lblQtdAnimais: TLabel;
    lblTelas: TLabel;
    btnDesativar: TRoundRect;
    btnEditar: TRoundRect;
    Label1: TLabel;
    lblDesativar: TLabel;
    lblSituacao: TLabel;
    Rectangle1: TRectangle;
    lbl1: TLabel;
    lblInformacoes: TLabel;
    lblCodLar: TLabel;
    Rectangle2: TRectangle;
    procedure btnEditarClick(Sender: TObject);
    procedure btnDesativarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses uFrmEditarLarTemporario, uDtmServidor, uFrmEdicaoLares, Notificacao;

procedure TFrameEditarLaresTemporarios.btnDesativarClick(Sender: TObject);
var
  VirtualKeyboard: IFMXVirtualKeyboardService;
begin
   if TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(VirtualKeyboard)) then
   begin
      VirtualKeyboard.HideVirtualKeyboard;
   end;

   if (lblDesativar.Text = 'Desativar') then
   begin
      frmEdicaoLares.lblConfirmacao.Text := 'Deseja realmente inativar lar temporário?';
      frmEdicaoLares.ParametrosInativacao('Desativar', lblCodLar.Text);
   end
   else
   begin
      frmEdicaoLares.lblConfirmacao.Text := 'Deseja realmente ativar lar temporário?';
      frmEdicaoLares.ParametrosInativacao('Ativar', lblCodLar.Text);
   end;

   frmEdicaoLares.lytOpaco.Visible := True;
   frmEdicaoLares.lytConfirmaInativacao.Visible := True;
end;

procedure TFrameEditarLaresTemporarios.btnEditarClick(Sender: TObject);
begin
   if (lblCodLar.Text <> '') then
   begin
      frmEditarLarTemporario.BuscaCodigoLar(StrToInt(lblCodLar.Text));
      frmEditarLarTemporario.Show;
   end;
end;

end.
