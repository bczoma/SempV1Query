#!/bin/bash

OPTIND=1         # Reset in case getopts has been used previously in the shell.

# Initialize our own variables:
count_search=""
name=""
password=""
query=""
url=""
value_search=""

script_name=$0
verbose=0

while getopts "c:n:p:q:u:v:" opt; do
    case "$opt" in
    n)  name=$OPTARG
        ;;
    p)  password=$OPTARG
        ;;
    q)  query=$OPTARG
        ;;
    u)  url=$OPTARG
        ;;
    esac
done

shift $((OPTIND-1))
[ "$1" = "--" ] && shift

verbose=1
echo "`date` INFO:${script_name}: name=${name}, password=xxx, query=${query} \
             ,url=${url} ,Leftovers: $@"

if [[ ${url} = "" || ${name} = "" || ${password} = "" || ${query} = "" ]]; then
    echo "`date` ERROR:${script_name}: url, name, password and query are madatory fields"
    echo  '{"errorInfo":"missing parameter"}'
    exit 1
  fi

# One of Silent or not
query_response=`curl -s -u ${name}:${password} ${url} -d "${query}"`
#query_response=`curl -u ${name}:${password} ${url} -d "${query}"`
query_response_code=`echo $query_response`

if [[ -z ${query_response_code} && ${query_response_code} != "ok" ]]; then
    echo "`date` ERROR:${script_name}: Query failed -${query_response}-"
    echo  "{\"errorInfo\":\"query failed -${query_response_code}-\"}"
    exit 1
fi

echo "`date` INFO:${script_name}: Query passed ${query_response_code}"

