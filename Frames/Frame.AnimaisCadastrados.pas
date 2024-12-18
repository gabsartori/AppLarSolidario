unit Frame.AnimaisCadastrados;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.VirtualKeyboard, FMX.Platform,
  FMX.Helpers.Android, Androidapi.Helpers, Androidapi.JNI.GraphicsContentViewText;

type
  TFrameAnimaisCadastrados = class(TFrame)
    lblNome: TLabel;
    lblResponsavel: TLabel;
    lblEndereco: TLabel;
    lblTelefone: TLabel;
    lblGenero: TLabel;
    lblCor: TLabel;
    lblTipo: TLabel;
    lblSituacao: TLabel;
    lblCastrado: TLabel;
    lblInformacoes: TLabel;
    lblIdade: TLabel;
    cFotoAnimal: TCircle;
    btnHospedar: TRoundRect;
    btnAdotar: TRoundRect;
    Label2: TLabel;
    Label1: TLabel;
    Rectangle1: TRectangle;
    imgWhatsApp: TImage;
    lblCodAnimal: TLabel;
    procedure imgWhatsAppClick(Sender: TObject);
    procedure AbrirWhatsApp(sTelefone: string);
    procedure btnAdotarClick(Sender: TObject);
    procedure btnHospedarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses uFrmPaginaBuscas;

procedure TFrameAnimaisCadastrados.AbrirWhatsApp(sTelefone: string);
var
  sURL: string;
begin
  sTelefone := sTelefone.Replace(' ', '').Replace('(', '').Replace(')', '').Replace('-', '').Replace('Telefone:', '');
  sURL := 'https://wa.me/55' + sTelefone;

  TAndroidHelper.Context.startActivity(
  TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_VIEW,
  StrToJURI(sURL)));
end;

procedure TFrameAnimaisCadastrados.btnAdotarClick(Sender: TObject);
var
  VirtualKeyboard: IFMXVirtualKeyboardService;
begin
   if TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(VirtualKeyboard)) then
   begin
      VirtualKeyboard.HideVirtualKeyboard;
   end;

   frmPaginaBuscas.lblConfirmacao.Text := 'Deseja enviar solicita��o para ado��o?';

   if (lblCodAnimal.Text <> '') then
   begin
      frmPaginaBuscas.BuscaCodigoAnimal(StrToInt(lblCodAnimal.Text));
      frmPaginaBuscas.Show;
   end;

   frmPaginaBuscas.lytOpaco.Visible := True;
   frmPaginaBuscas.lytConfirmaSolicitacao.Visible := True;
   frmPaginaBuscas.sBotaoClicado := 'Ado��o';
end;

procedure TFrameAnimaisCadastrados.btnHospedarClick(Sender: TObject);
var
  VirtualKeyboard: IFMXVirtualKeyboardService;
begin
   if TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(VirtualKeyboard)) then
   begin
      VirtualKeyboard.HideVirtualKeyboard;
   end;

   frmPaginaBuscas.lblConfirmacao.Text := 'Deseja enviar solicita��o para hospedagem?';

   if (lblCodAnimal.Text <> '') then
   begin
      frmPaginaBuscas.BuscaCodigoAnimal(StrToInt(lblCodAnimal.Text));
      frmPaginaBuscas.Show;
   end;

   frmPaginaBuscas.lytOpaco.Visible := True;
   frmPaginaBuscas.lytConfirmaSolicitacao.Visible := True;
   frmPaginaBuscas.sBotaoClicado := 'Hospedagem';
end;

procedure TFrameAnimaisCadastrados.imgWhatsAppClick(Sender: TObject);
begin
   try
      AbrirWhatsApp(lblTelefone.Text); // Substitua pelo n�mero desejado
   except
      on E: Exception do
      begin
         ShowMessage('N�o foi poss�vel abrir o WhatsApp!'+#13+
                     'Erro: '+E.Message);
      end;
   end;
end;

end.
