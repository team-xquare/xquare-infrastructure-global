import json
import logging
import os
import boto3

from base64 import b64decode
from urllib.request import Request, urlopen
from urllib.error import URLError, HTTPError

HOOK_URL = os.environ['hookUrl']
SLACK_CHANNEL = os.environ['slackChannel']

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def get_instance_name(instance_id):
    # Create an EC2 resource
    ec2 = boto3.resource("ec2")
    instance = ec2.Instance(instance_id)

    # Retrieve instance name tag
    instance_name = None
    for tag in instance.tags:
        if tag["Key"] == "Name":
            instance_name = tag["Value"]
            break

    # Return the instance name tag
    return instance_name


def get_instance_private_ip(instance_id):
    # Create an EC2 resource
    ec2 = boto3.resource("ec2")
    instance = ec2.Instance(instance_id)

    # Retrieve instance private ip
    try:
        instance_private_ip = instance.private_ip_address
    except Exception as e:
        logger.error(f"Error occurred while retrieving private IP for instance id: {instance_id}")
        logger.error(f"Request failed: {e}")

    # Return the instance private ip
    return instance_private_ip


def lambda_handler(event, context):
    logger.info("Event: " + str(event))
    message = event

    region = message['region']
    account_id = message['account']
    instance_arn = ''.join(message['resources'])
    instance_id = message['detail']['instance-id']
    instance_name = get_instance_name(instance_id)
    instance_private_ip = get_instance_private_ip(instance_id)
    instance_action = message['detail']['instance-action']
    instance_url = f"https://{region}.console.aws.amazon.com/ec2/home?region={region}#Instances:instanceId={instance_id}"

    # Send slack message for spot instance interruption events.
    slack_message = {
        "channel": SLACK_CHANNEL,
        "username": "EC2 Spot Instance Interruption Warning",
        "icon_url": "https://raw.githubusercontent.com/aendrew/aws-slack-emojipack/master/General_AWScloud.png",
        "blocks": [
            {
                "type": "section",
                "text": {
                    "type": "mrkdwn",
                    "text": 'EC2 스팟 인스턴스가 중단될 예정입니다.'
                }
            },
            {
                "type": "divider"
            }
        ],
        "attachments": [
            {
                "fallback": "EC2 Spot Instance Interruption Warning",
                "color": "#FFC300",
                "blocks": [
                    {
                        "type": "section",
                        "fields": [
                            {
                                "type": "mrkdwn",
                                "text": f"*Account*:  {account_id}"
                            },
                            {
                                "type": "mrkdwn",
                                "text": f"*ARN*:  {instance_arn}"
                            },
                            {
                                "type": "mrkdwn",
                                "text": f"*Instance ID*:  {instance_id}"
                            },
                            {
                                "type": "mrkdwn",
                                "text": f"*Instance Name*:  {instance_name}"
                            },
                            {
                                "type": "mrkdwn",
                                "text": f"*Instance Private IP*:  {instance_private_ip}"
                            },
                            {
                                "type": "mrkdwn",
                                "text": f"*Action*:  {instance_action}"
                            }
                        ]
                    },
                    {
                        "type": "actions",
                        "elements": [
                            {
                                "type": "button",
                                "text": {
                                    "type": "plain_text",
                                    "text": "AWS 콘솔에서 EC2 조회  :waving_white_flag:"
                                },
                                "style": "primary",
                                "url": instance_url
                            }
                        ]
                    }
                ]
            }
        ]
    }

    try:
        req = Request(HOOK_URL, json.dumps(slack_message).encode('utf-8'))
        req.add_header('Content-Type', 'application/json')
        response = urlopen(req)
        response.read()
        logger.info("Message posted to %s", slack_message['channel'])
    except HTTPError as e:
        logger.error("Request failed: %d %s", e.code, e.reason)
    except URLError as e:
        logger.error("Server connection failed: %s", e.reason)
