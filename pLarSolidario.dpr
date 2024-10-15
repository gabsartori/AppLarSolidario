program pLarSolidario;

uses
  System.StartUpCopy,
  FMX.Forms,
  uLogin in 'uLogin.pas' {frmLogin},
  uCriarCadastro in 'uCriarCadastro.pas' {frmCriarCadastro},
  uPaginaInicial in 'uPaginaInicial.pas' {Z},
  uDtmServidor in 'uDtmServidor.pas' {dtmServidor: TDataModule},
  Notificacao in 'Notificacao.pas',
  uFrmCadastroLarTemporario in 'uFrmCadastroLarTemporario.pas' {frmCadastroLarTemporario},
  uFrmCadastroAnimais in 'uFrmCadastroAnimais.pas' {frmCadastroAnimais},
  u99Permissions in 'Units\u99Permissions.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TfrmCriarCadastro, frmCriarCadastro);
  Application.CreateForm(TfrmCadastroLarTemporario, frmCadastroLarTemporario);
  Application.CreateForm(TfrmCadastroAnimais, frmCadastroAnimais);
  Application.CreateForm(TdtmServidor, dtmServidor);
  Application.CreateForm(TfrmPaginaInicial, frmPaginaInicial);
  Application.Run;
end.
