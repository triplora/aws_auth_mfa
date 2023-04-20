# aws_auth_mfa
A very useful AWS MFA authentication script
1 - Dependencies:
1.1 - JQ - Install JQ via sudo apt install jq;
1.2 - Dialog - Install Dialog via sudo apt install dialog (* if you want use Dialog);
1.3 - AWS Cli V2. Maybe works with V1;
1.4 - AWS accounts properly configured with ACCESS_KEY and SECRET_KEYS in AWS config files. (~/.aws/config and ~/.aws/credentials).
2 - Add/Replace account entries in aws_mfa_accounts.csv file with column information based on config files.
If you want use Dialog as input you can replace read by uncommenting   the respective Dialog lines or replace by other input variable tool.
3 - chmod +x aws_auth_mfa.sh
4 - Execute bash script file:
4.1 - ./aws_auth_mfa.sh
