#!/bin/bash
X=1;
for account in $(cat ./aws_accounts.csv|tail -f -n +2); do
  ACCOUNT_ID=$(echo $account| cut -d ';' -f1);
  PROFILEACCOUNT=$(echo $account| cut -d ';' -f2);
  SERIAL=$(echo $account| cut -d ';' -f3);
  EXPIRATIONDATE=$(echo $account| cut -d ';' -f4);
  X=$((X+1));
  cutoff=$(date +%s);
  age=$(date -d "$EXPIRATIONDATE" +%s)
  if (($age < $cutoff))
  then
    echo "Warning! is older than 3 days";
    echo $ACCOUNT_ID;
    echo $PROFILEACCOUNT;
    echo $SERIAL;
    read;
    TOKEN=$REPLY
    # TOKEN=$(\
    #   dialog --title "Digite o TOKEN" \
    #         --inputbox "$PROFILEACCOUNT TOKEN CODE:" 8 40 \
    #   3>&1 1>&2 2>&3 3>&- \
    # )
    echo "$TOKEN"

    echo "Configuring $PROFILEACCOUNT with token $TOKEN"
    CREDJSON="$(aws sts get-session-token --serial-number $SERIAL --profile $PROFILEACCOUNT --token-code $TOKEN --duration-seconds 129600)"
    echo $CREDJSON

    ACCESSKEY="$(echo $CREDJSON | jq '.Credentials.AccessKeyId' | sed 's/"//g')"
    SECRETKEY="$(echo $CREDJSON | jq '.Credentials.SecretAccessKey' | sed 's/"//g')"
    SESSIONTOKEN="$(echo $CREDJSON | jq '.Credentials.SessionToken' | sed 's/"//g')"
    EXPIRATIONTOKEN="$(echo $CREDJSON | jq '.Credentials.Expiration' | sed 's/"//g')"
    PROFILENAMEMFA="$PROFILEACCOUNT""_mfa"

    aws configure set aws_access_key_id $ACCESSKEY --profile $PROFILENAMEMFA
    aws configure set aws_secret_access_key $SECRETKEY --profile $PROFILENAMEMFA
    aws configure set aws_session_token $SESSIONTOKEN --profile $PROFILENAMEMFA
    REPLACEEXPDATE=$X"s/;[^;]*$/;"$EXPIRATIONTOKEN"/ ./aws_accounts.csv";
    EXEC=$(sed -i $REPLACEEXPDATE);
  else
    echo "$PROFILEACCOUNT vaĺido - $cutoff - $age";
  fi
done
