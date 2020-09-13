""" Module for CloudWatchLogsUnencrypted """

import json
import os

import boto3
from reflex_core import AWSRule, subscription_confirmation


class CloudWatchLogsUnencrypted(AWSRule):
    """ A Reflex Rule for detecting CloudWatch Logs that are unencrypted """

    client = boto3.client("logs")

    def __init__(self, event):
        super().__init__(event)

    def extract_event_data(self, event):
        """ Extract required event data """
        self.log_group_name = event["detail"]["requestParameters"]["logGroupName"]

    def resource_compliant(self):
        """
        Determine if the resource is compliant with your rule.

        Return True if it is compliant, and False if it is not.
        """
        response = self.client.describe_log_groups(logGroupNamePrefix=self.log_group_name)

        for log_group in response["logGroups"]:
            if log_group["logGroupName"] != self.log_group_name:
                continue
            # If "kmsKeyId" is present, the logs are encrypted
            return "kmsKeyId" in log_group

        # We didn't find the Log Group we were looking for. That likely means it has been deleted
        # and no action is required
        return True

    def get_remediation_message(self):
        """ Returns a message about the remediation action that occurred """
        return f"The CloudWatch Log Group {self.log_group_name} is unencrypted."


def lambda_handler(event, _):
    """ Handles the incoming event """
    print(event)
    if subscription_confirmation.is_subscription_confirmation(event):
        subscription_confirmation.confirm_subscription(event)
        return
    rule = CloudWatchLogsUnencrypted(json.loads(event["Records"][0]["body"]))
    rule.run_compliance_rule()
