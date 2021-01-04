import Config

db_url = System.get_env("DATABASE_URL")

config :acgp, AcgpWeb.Endpoint,
  secret_key_base: "LkrIIPvPC9XgMqkhgH2RsOn+ByJ+Th/dVRKSxxjE39A+oeEPIal8Gr3DXOffUKjR"

# Configure your database
config :acgp, Acgp.Repo,
  url: db_url,
  pool_size: 15
