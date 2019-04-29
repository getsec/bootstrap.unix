import boto3
import uuid
import sys
import subprocess


usage = """
    Used to create a pull request on a repo and merge them to the master
    branch. This will be used for some fun fucking stuff.

    <example>
    /              (app)     (branch)            (repo_name)
    \________> ./deploy  request-432   master-template-repo # NOQA
"""


def get_git_branch_name():
    git_branch_cmd = "git branch | grep \* | cut -d ' ' -f2" # NOQA
    result = subprocess.check_output(
        git_branch_cmd,
        shell=True
    ).decode("utf-8").strip('\n')
    return result


def get_git_repo_name():
    git_repo_name_cmd = "git rev-parse --show-toplevel"
    result = subprocess.check_output(
        git_repo_name_cmd,
        shell=True
    ).decode("utf-8").strip('\n').split('/')[-1]
    return result


def main():
    client = boto3.client('codecommit')
    branch = get_git_branch_name()
    repo = get_git_repo_name()
    rand = uuid.uuid4()

    try:
        if sys.argv[1].lower() == 'dev':
            pull = "Automated PR via ngetty testing"
            desc = "This is an automated script nathan wrote doing this"
        else:
            sys.exit("Make sure you use the dev arg idiot...")
    except IndexError:
        pull = input("Pull request title: ")
        desc = input("Pull request desc: ")

    print(f"[PR] Repo: {repo}")
    print(f"[PR] BRANCH: {branch}")

    verify = input("Continue? [y/n]: ")
    if verify.lower() == 'y':
        response = client.create_pull_request(
            title=pull,
            description=desc,
            targets=[
                {
                    'repositoryName': repo,
                    'sourceReference': branch,
                },
            ],
            clientRequestToken=str(rand)
        )
        code = response['ResponseMetadata']['HTTPStatusCode']

    if code == 200:
        print(f"We received code [{code}]")
        merge = input("Want us to merge this diggity dog to master? [y/n]: ")
        if merge.lower() == 'y':
            mergeme = client.merge_pull_request_by_fast_forward(
                pullRequestId=response['pullRequest']['pullRequestId'],
                repositoryName=repo,
                sourceCommitId=response['pullRequest']['pullRequestTargets'][0]['sourceCommit'] # NOQA
            )
            print(mergeme)

    else:
        print("thats all folks")


if __name__ in '__main__':
    main()
