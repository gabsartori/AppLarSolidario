unit Frame.EditarAnimais;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.DialogService, FMX.VirtualKeyboard,
  FMX.Platform;

type
  TFrameEditarAnimais = class(TFrame)
    lblTipo: TLabel;
    lblGenero: TLabel;
    lblNome: TLabel;
    lblCor: TLabel;
    lblIdade: TLabel;
    lblEndereco: TLabel;
    lblCastrado: TLabel;
    lblSituacao: TLabel;
    lblInformacoes: TLabel;
    btnDesativar: TRoundRect;
    btnEditar: TRoundRect;
    Label1: TLabel;
    lblDesativar: TLabel;
    lbl1: TLabel;
    cFotoAnimal: TCircle;
    lblCodAnimal: TLabel;
    Rectangle1: TRectangle;
    procedure btnEditarClick(Sender: TObject);
    procedure btnDesativarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses uFrmEdicaoAnimais, uFrmEditarAnimais, Notificacao, uFrmEdicaoLares,
  uDtmServidor;

procedure TFrameEditarAnimais.btnDesativarClick(Sender: TObject);
var
  VirtualKeyboard: IFMXVirtualKeyboardService;
begin
   if TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(VirtualKeyboard)) then
   begin
      VirtualKeyboard.HideVirtualKeyboard;
   end;

   if (lblDesativar.Text = 'Desativar') then
   begin
      frmEdicaoAnimais.lblConfirmacao.Text := 'Deseja realmente inativar pet?';
      frmEdicaoAnimais.ParametrosInativacao('Desativar', lblCodAnimal.Text);
   end
   else
   begin
      frmEdicaoAnimais.lblConfirmacao.Text := 'Deseja realmente ativar pet?';
      frmEdicaoAnimais.ParametrosInativacao('Ativar', lblCodAnimal.Text);
   end;

   frmEdicaoAnimais.lytOpaco.Visible := True;
   frmEdicaoAnimais.lytConfirmaInativacao.Visible := True;
end;

procedure TFrameEditarAnimais.btnEditarClick(Sender: TObject);
begin
   if lblCodAnimal.Text <> '' then
   begin
      frmEditarAnimais.BuscaCodigoAnimal(StrToInt(lblCodAnimal.text));
   end;

   frmEditarAnimais.Show;
end;

end.
