# marqeta.zsh
# -----------
# @description zsh configuration for marqeta.

function zionValidate {
  ZION_FQDN="zion.aws.marqeta.io"
  APP_TOKEN="<app-token-here>"
  ACCESS_TOKEN="<access-token-here>"

  curl --request POST \
    --url "https://${ZION_FQDN}/zion-api/accesstokens/authentication" \
    --user "${APP_TOKEN}:${ACCESS_TOKEN}" \
    --header 'Content-Type: application/json' \
    --data "{ \"application_token\": \"${APP_TOKEN}\", \"access_token\": \"${ACCESS_TOKEN}\" }"
}

function getNileToken {
  NILE_FQDN="nile.aws.marqeta.io"
  # NILE_FQDN=nile-api-qa-internal.mq01-qa.marqeta.io
  NILE_CLIENT_ID="<client-id-here>"
  NILE_CLIENT_SECRET="<client-secret-here>"

  curl --request POST \
    --url "https://${NILE_FQDN}/oauth2/token" \
    --header 'Content-Type: application/json' \
    --data "{ \"client_id\": \"${NILE_CLIENT_ID}\", \"client_secret\": \"${NILE_CLIENT_SECRET}\", \"state\": \"\", \"grant_type\": \"client_credentials\" }"
}
