import boto3
import sys

if len(sys.argv) >= 3:
    print("Too many args")

elif len(sys.argv) == 2:
    client = boto3.client('codepipeline')
    response = client.get_pipeline_state(
        name=sys.argv[1])
    for stage in response['stageStates']:
        print(f"Stage: {stage['stageName']}")
        for detail in stage['actionStates']:
            print(f"\tStatus: {detail['latestExecution']['status']}")

else:
    client = boto3.client('codepipeline')
    response = client.get_pipeline_state(
        name='AWS-Landing-Zone-CodePipeline'
    )
    for stage in response['stageStates']:
        print(f"Stage: {stage['stageName']}")
        for detail in stage['actionStates']:
            print(f"\tStatus: {detail['latestExecution']['status']}")
            print(f"\tTime:   {detail['latestExecution']['lastStatusChange']}")
            print("")
