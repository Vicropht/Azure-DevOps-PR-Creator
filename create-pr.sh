#!/bin/bash
magenta=`tput setaf 5`
yellow=`tput setaf 3`
reset=`tput sgr0`
PS3='Choose repository number to create a PR: '
repos=("[REPO-1]" "[REPO-2]" "Quit")

usage() { echo "Usage: $0 [-v <release version>] [-r <reviewer name>] [-e <emoji>]" 1>&2; exit 1; }

while getopts ":v:r:e:" o; do
    case "${o}" in
        v)
            v=${OPTARG}
            ;;
        r)
            r=${OPTARG}
            ;;
		    e)
			      e=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${v}" ] || [ -z "${r}" ] || [ -e "${e}" ]; then
    usage
fi

echo "${yellow}DISCLAIMER: Please make sure the selected repository branch source has changed files (a blank PR will be created otherwise, see: https://github.com/Azure/azure-cli/issues/21177) if specified, PRs will have an OPTIONAL reviewer.${reset}"

select repo in "${repos[@]}"; do
    case $repo in
        "Quit")
			  exit
			;;
		*)
        echo "Creating PR for $repo..."
        az repos pr create --org https://dev.azure.com/[YOUR-ORGANIZATION-URL]/ --open -p=[PROJECT-NAME] -r $repo -s [SOURCE-BRANCH] -t [TARGET-BRANCH] --reviewers "${r}" --title "Rollout Name version ${v} ${e}" --auto-complete true
        for((i=0;i<${#repos[@]};i++));do echo "$((i+1))) ${repos[$i]}";done
        ;;
	
    esac
done
