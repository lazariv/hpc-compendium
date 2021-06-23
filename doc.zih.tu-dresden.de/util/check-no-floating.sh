#!/bin/bash

if [ ${#} -ne 1 ]; then
  echo "Usage: ${0} <path>"
fi

DOCUMENT_ROOT=${1}

check_md() {
  awk -F'/' '{print $0,NF,$NF}' <<< "${1}" | while IFS=' ' read string depth md; do
    #echo "string=${string} depth=${depth} md=${md}"

    # max depth check 
    if [ "${depth}" -gt "5" ]; then
      echo "max depth (4) exceeded for ${string}"
      exit -1
    fi

    # md included in nav 
    if ! sed -n '/nav:/,/^$/p' ${2}/mkdocs.yml | grep --quiet ${md}; then
      echo "${md} is not included in nav"
      exit -1
    fi
  done
}

export -f check_md

#find ${DOCUMENT_ROOT}/docs -name "*.md" -exec bash -c 'check_md "${0#${1}}" "${1}"' {} ${DOCUMENT_ROOT} \; 
MSG=$(find ${DOCUMENT_ROOT}/docs -name "*.md" -exec bash -c 'check_md "${0#${1}}" "${1}"' {} ${DOCUMENT_ROOT} \;)
if [ ! -z "${MSG}" ]; then
  echo "${MSG}"
  exit -1
fi
