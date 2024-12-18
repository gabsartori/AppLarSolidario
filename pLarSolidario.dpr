program pLarSolidario;

uses
  System.StartUpCopy,
  FMX.Forms,
  uFrmLogin in 'uFrmLogin.pas' {frmLogin},
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
  Frame.EditarLaresTemporarios in 'Frames\Frame.EditarLaresTemporarios.pas' {FrameEditarLaresTemporarios: TFrame},
  Frame.EditarAnimais in 'Frames\Frame.EditarAnimais.pas' {FrameEditarAnimais: TFrame},
  uFrmEdicaoLares in 'uFrmEdicaoLares.pas' {frmEdicaoLares},
  uFrmEdicaoAnimais in 'uFrmEdicaoAnimais.pas' {frmEdicaoAnimais},
  uFrmEditarCadastro in 'uFrmEditarCadastro.pas' {frmEditarCadastro},
  uFrmAlterarSenha in 'uFrmAlterarSenha.pas' {frmAlterarSenha},
  uFrmEditarAnimais in 'uFrmEditarAnimais.pas' {frmEditarAnimais},
  uPaginaConfiguracoes in 'uPaginaConfiguracoes.pas' {frmPaginaConfiguracoes},
  uFrmEditarLarTemporario in 'uFrmEditarLarTemporario.pas' {frmEditarLarTemporario},
  uFrmNotificacoes in 'uFrmNotificacoes.pas' {frmNotificacoes},
  Frame.Notificacoes in 'Frames\Frame.Notificacoes.pas' {FrameNotificacoes: TFrame},
  Frame.NotificacoesRespondidas in 'Frames\Frame.NotificacoesRespondidas.pas' {FrameNotificacoesRespondidas: TFrame};

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
  Application.CreateForm(TfrmEditarCadastro, frmEditarCadastro);
  Application.CreateForm(TfrmAlterarSenha, frmAlterarSenha);
  Application.CreateForm(TfrmEditarAnimais, frmEditarAnimais);
  Application.CreateForm(TfrmPaginaConfiguracoes, frmPaginaConfiguracoes);
  Application.CreateForm(TfrmEditarLarTemporario, frmEditarLarTemporario);
  Application.CreateForm(TfrmNotificacoes, frmNotificacoes);
  Application.Run;
end.
