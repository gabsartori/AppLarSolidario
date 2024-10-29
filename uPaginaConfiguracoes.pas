unit uPaginaConfiguracoes;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, REST.Types,
  REST.Client, Data.Bind.Components, Data.Bind.ObjectScope,
  FMX.Controls.Presentation, FMX.Edit, FMX.StdCtrls, FMX.Layouts, FMX.ExtCtrls,
  FMX.Objects;

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
    lblEditarPerfil: TLabel;
    lblAlterarSenha: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    lblDesativarConta: TLabel;
    lblEditarPets: TLabel;
    btnEditarLares: TButton;
    procedure imgSairClick(Sender: TObject);
    procedure btnEditarLaresClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPaginaConfiguracoes: TfrmPaginaConfiguracoes;

implementation

{$R *.fmx}

uses uPaginaInicial, uFrmEdicaoLares;

procedure TfrmPaginaConfiguracoes.btnEditarLaresClick(Sender: TObject);
begin
   frmEdicaoLares.Show;
end;

procedure TfrmPaginaConfiguracoes.imgSairClick(Sender: TObject);
begin
   frmPaginaInicial.Show;
end;

end.