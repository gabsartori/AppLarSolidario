object dtmServidor: TdtmServidor
  OnCreate = DataModuleCreate
  Height = 242
  Width = 272
  object fdConexao: TFDConnection
    Params.Strings = (
      'DriverID=sQLite')
    LoginPrompt = False
    AfterConnect = fdConexaoAfterConnect
    Left = 32
    Top = 24
  end
  object qryGeral: TFDQuery
    Connection = fdConexao
    Left = 32
    Top = 80
  end
  object RESTRequest1: TRESTRequest
    Client = RESTClient1
    Params = <>
    Response = RESTResponse1
    SynchronizedEvents = False
    Left = 192
    Top = 32
  end
  object RESTClient1: TRESTClient
    Params = <>
    SynchronizedEvents = False
    Left = 192
    Top = 96
  end
  object RESTResponse1: TRESTResponse
    Left = 192
    Top = 160
  end
  object qryInsert: TFDQuery
    Connection = fdConexao
    Left = 32
    Top = 136
  end
  object qryGeral2: TFDQuery
    Connection = fdConexao
    Left = 96
    Top = 81
  end
  object qryUpdate: TFDQuery
    Connection = fdConexao
    Left = 97
    Top = 136
  end
end
