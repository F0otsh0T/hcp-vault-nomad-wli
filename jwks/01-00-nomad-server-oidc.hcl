# Nomad Server Config
# OIDC Issuer @ https://developer.hashicorp.com/nomad/docs/configuration/server#oidc_issuer

server {
#    oidc_issuer = "http://{{$FQDN}}"{{$PORT}}""
#    oidc_issuer = "https://{{$FQDN}}:{{$PORT}}"
#    oidc_issuer = "http://0.0.0.0:4646"
    oidc_issuer = "http://host.docker.internal:4646"
}


