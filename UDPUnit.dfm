object UDP: TUDP
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 204
  Width = 362
  object IdUDPServer: TIdUDPServer
    Bindings = <
      item
        IP = '127.0.0.1'
        Port = 50001
      end>
    DefaultPort = 0
    ReuseSocket = rsTrue
    OnUDPRead = IdUDPServerUDPRead
    Left = 48
    Top = 24
  end
end
