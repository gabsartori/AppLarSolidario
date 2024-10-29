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
  u99Permissions in 'Units\u99Permissions.pas',
  uFrmPaginaBuscas in 'uFrmPaginaBuscas.pas' {frmPaginaBuscas},
  Frame.AnimaisCadastrados in 'Frames\Frame.AnimaisCadastrados.pas' {FrameAnimaisCadastrados: TFrame},
  uFunctions in 'Units\uFunctions.pas',
  uPaginaConfiguracoes in 'uPaginaConfiguracoes.pas' {frmPaginaConfiguracoes},
  Frame.EditarLaresTemporarios in 'Frames\Frame.EditarLaresTemporarios.pas' {FrameEditarLaresTemporarios: TFrame},
  Frame.EditarAnimais in 'Frames\Frame.EditarAnimais.pas' {FrameEditarAnimais: TFrame},
  uFrmEdicaoLares in 'uFrmEdicaoLares.pas' {frmEdicaoLares},
  uFrmEdicaoAnimais in 'uFrmEdicaoAnimais.pas' {frmEdicaoAnimais};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TfrmCriarCadastro, frmCriarCadastro);
  Application.CreateForm(TfrmCadastroLarTemporario, frmCadastroLarTemporario);
  Application.CreateForm(TfrmCadastroAnimais, frmCadastroAnimais);
  Application.CreateForm(TdtmServidor, dtmServidor);
  Application.CreateForm(TfrmPaginaConfiguracoes, frmPaginaConfiguracoes);
  Application.CreateForm(TfrmPaginaBuscas, frmPaginaBuscas);
  Application.CreateForm(TfrmPaginaInicial, frmPaginaInicial);
  Application.CreateForm(TfrmEdicaoLares, frmEdicaoLares);
  Application.CreateForm(TfrmEdicaoAnimais, frmEdicaoAnimais);
  Application.Run;
end.
