#!/usr/bin/python

# Cloudwatch query script for use with Zabbix (or any other monitoring tool)
# Queries for the values over the last 20 minutes and returns the most recent value
# Author: Stefan Radu
# Web: http://rstefan.blogspot.com

## Parameters:
# MetricName. Eg: CurrConnections
# Function. Can be one of the following: Average, Sum, SampleCount, Maximum, or Minimum.
# Dimension. Eg: CacheClusterId=cache,CacheNodeId=0001
# Region. Eg: eu-west-1
# AWS_Access_Key
# AWS_Secret_Access_Key


import boto.ec2.cloudwatch
import sys
import datetime

try:
    metName = sys.argv[1]
    funcName = sys.argv[2]
    dimSpace = sys.argv[3]
    region = sys.argv[4]
    accessKey = sys.argv[5]
    secretKey = sys.argv[6]

except:
    print "Usage: get_aws.py MetricName Function Dimension Region AWS_ACCESS_KEY AWS_SECRET_ACCESS_KEY"
    print "Example: get_aws.py CurrConnections Average \"CacheClusterId=cache,CacheNodeId=0001\" eu-west-1 ACCESS_KEY SECRET_ACCESS_KEY"
    sys.exit(1)

dim = {}
firstSplit = dimSpace.split(',')
for word in firstSplit:
    secondSplit = word.split('=')
    dim[secondSplit[0]] = secondSplit[1]

regions = boto.ec2.cloudwatch.regions()
reg = ''
for r in regions:
    if region == r.name:
        reg = r
c = boto.ec2.cloudwatch.CloudWatchConnection(aws_access_key_id=accessKey, aws_secret_access_key=secretKey, region=reg)
metrics = c.list_metrics(dimensions=dim)

end = datetime.datetime.utcnow()
start = end - datetime.timedelta(minutes=20)

dataPoints = [];

for met in metrics:
    if met.name == metName:
        dataPoints = met.query(start, end, funcName)

if len(dataPoints) > 0:
    max = datetime.datetime.utcnow() - datetime.timedelta(hours=1)
    index = 0
    for i in range(0,len(dataPoints)):
        if max < dataPoints[i][u'Timestamp']:
            max = dataPoints[i][u'Timestamp']
            index = i
    for key in dataPoints[index].keys():
        if funcName in key:
            value = dataPoints[index][key]
    print long(value)
else:
    print 'Error! No response from Amazon.'
    sys.exit(2)
