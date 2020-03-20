import boto3
import json
import logging
import os
from botocore.vendored import requests

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    print(event)
    logger.info("Event: User Name [{}], Server ID: [{}]".format(event["username"], event["serverId"]))

    response = {}

    if "username" not in event or "serverId" not in event or "password" not in event:
        return response

    # It is recommended to verify server ID against some value, this template does not verify server ID
    server_id = event["serverId"]
    username = event["username"]
    password = event["password"]

    status_code = auth_with_okta(get_full_username(username), password)

    if status_code == 200:
        home_directory = "${mybucket}" + "/" + username + "/"

        # NOTE: If it is necessary to modify the Role passed here, the TransferCanVerifyReturnedUserRole
        #       in this stack template must be modified to reflect this role as well.
        response["Role"] = "${transfer_role_arn}"
        response["HomeDirectory"] = "/" + home_directory
        # Optional JSON blob to further restrict this user's permissions
        response["Policy"] = ""
        logger.info("Message: {}".format(response))
    else:
        logger.info("Failed to authenticate user [{}] with Okta. Received status code of {}".format(get_full_username(username), status_code))

    return response

def get_full_username(user_name):
    return user_name + "@" + "${UserSigninDomain}"

# This function authenticates a user with Okta and returns a status code
def auth_with_okta(user_name, password):
    headers = {"Accept": "application/json", "Content-Type": "application/json"}
    credentials = {"username": user_name, "password": password}

    try:
        res = requests.post(url="https://engie.okta-emea.com/api/v1/authn", data=json.dumps(credentials), headers=headers)
        logger.info("Okta response: [{}]".format(res))
        return res.status_code
    except Exception as e:
        logger.info("Error authing with Okta: {}".format(str(e)))
        return 0