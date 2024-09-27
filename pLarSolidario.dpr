program pLarSolidario;

uses
  System.StartUpCopy,
  FMX.Forms,
  uLogin in 'uLogin.pas' {frmLogin},
  uCriarCadastro in 'uCriarCadastro.pas' {frmCriarCadastro},
  uPaginaInicial in 'uPaginaInicial.pas' {Z},
  uDtmServidor in 'uDtmServidor.pas' {dtmServidor: TDataModule},
  Notificacao in 'Notificacao.pas',
  uFrmCadastroLarTemporario in 'uFrmCadastroLarTemporario.pas' {frmCadastroLarTemporario};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TfrmCriarCadastro, frmCriarCadastro);
  Application.CreateForm(TfrmPaginaInicial, frmPaginaInicial);
  Application.CreateForm(TdtmServidor, dtmServidor);
  Application.CreateForm(TfrmCadastroLarTemporario, frmCadastroLarTemporario);
  Application.Run;
end.
