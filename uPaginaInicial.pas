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
    Image2: TImage;
    procedure FormShow(Sender: TObject);
    procedure imgSairClick(Sender: TObject);
    procedure btnCadastrarLarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPaginaInicial: TfrmPaginaInicial;

implementation

{$R *.fmx}

uses uLogin, uFrmCadastroLarTemporario;

procedure TfrmPaginaInicial.btnCadastrarLarClick(Sender: TObject);
begin
   frmCadastroLarTemporario.Show;
end;

procedure TfrmPaginaInicial.FormShow(Sender: TObject);
begin
   lblUsuario.Text := 'Bem-Vindo(a) '+ frmLogin.sUsuarioLogado +'!';
end;

procedure TfrmPaginaInicial.imgSairClick(Sender: TObject);
begin
   frmLogin.Show;
end;

end.
