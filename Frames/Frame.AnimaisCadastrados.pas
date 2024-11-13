unit Frame.AnimaisCadastrados;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation;

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
    procedure imgWhatsAppClick(Sender: TObject);
    procedure AbrirWhatsApp(sTelefone: string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

procedure TFrameAnimaisCadastrados.AbrirWhatsApp(sTelefone: string);
var
  sURL: string;
begin
  // Formatar o n�mero de telefone para o formato internacional correto
  sTelefone := sTelefone.Replace(' ', '').Replace('(', '').Replace(')', '').Replace('-', '');
  sURL := 'https://wa.me/' + sTelefone;
  // Abrir a URL usando o intent do Android
  TAndroidHelper.Context.startActivity(
    TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_VIEW,
    StrToJURI(sURL)));
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
         Close;
      end;
   end;
end;

end.
