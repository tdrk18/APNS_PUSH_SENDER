#!/bin/sh

P12_PASSWORD=""
BUNDLE_IDENTIFIER=""
TOKEN=""

while getopts ":-:" opt; do
  if [ $opt = "-" ]; then
    opt=`echo ${OPTARG} | awk -F'=' '{print $1}'`
    OPTARG=`echo ${OPTARG} | awk -F'=' '{print $2}'`
  fi

  case "$opt" in
    bundleID)
      BUNDLE_IDENTIFIER=$OPTARG
      ;;
    token)
      TOKEN=$OPTARG
      ;;
    password)
      P12_PASSWORD=$OPTARG
      ;;
  esac
done
shift $((OPTIND - 1))

PUSH_DATA='{"aps": {"alert": "🎉push test"}}'
APPLE_URI="https://api.push.apple.com/3/device/"
PEM_PATH="/var/tmp/keys/certificate-and-privatekey.pem"
P12_PATH="/var/tmp/keys/aps_key.p12"

openssl pkcs12 -password pass:${P12_PASSWORD} -in ${P12_PATH} -nodes -out ${PEM_PATH}

curl -v \
  -d "$PUSH_DATA" \
  -H "apns-priority: 10" \
  -H "apns-expiration: 0" \
  -H "apns-topic: ${BUNDLE_IDENTIFIER}" \
  --http2 \
  --cert ${PEM_PATH} \
  ${APPLE_URI}${TOKEN}
