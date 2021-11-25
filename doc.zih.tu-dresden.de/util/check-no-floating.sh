#!/bin/bash

if [ ${#} -ne 1 ]; then
  echo "Usage: ${0} <path>"
fi

export DOCUMENT_ROOT=${1}
export maxDepth=4
export expectedFooter="$DOCUMENT_ROOT/docs/legal_notice.md $DOCUMENT_ROOT/docs/accessibility.md $DOCUMENT_ROOT/docs/data_protection_declaration.md"

check_md() {
  awk -F'/' '{print $0,NF}' <<< "${1}" | while IFS=' ' read string depth; do
    #echo "string=${string} depth=${depth}"

    # max depth check 
    if [ "${depth}" -gt $maxDepth ]; then
      echo "max depth ($maxDepth) exceeded for ${string}"
    fi

    md=${string#${DOCUMENT_ROOT}/docs/}

    # md included in nav 
    numberOfReferences=`sed -n '/nav:/,/^$/p' ${DOCUMENT_ROOT}/mkdocs.yml | grep -c ${md}`
    if [ $numberOfReferences -eq 0 ]; then
      # fallback: md included in footer 
      if [[ "${expectedFooter}" =~ ${string} ]]; then
        numberOfReferencesInFooter=`sed -n '/footer:/,/^$/p' ${DOCUMENT_ROOT}/mkdocs.yml | grep -c /${md%.md}`
        if [ $numberOfReferencesInFooter -eq 0 ]; then
          echo "${md} is not included in footer"
        elif [ $numberOfReferencesInFooter -ne 1 ]; then
          echo "${md} is included $numberOfReferencesInFooter times in footer"
        fi
      else
        echo "${md} is not included in nav"
      fi
    elif [ $numberOfReferences -ne 1 ]; then
      echo "${md} is included $numberOfReferences times in nav"
    fi
  done
}

export -f check_md

MSG=$(find ${DOCUMENT_ROOT}/docs -name "*.md" -exec bash -c 'check_md "${0}"' {} \;)
if [ ! -z "${MSG}" ]; then
  echo "${MSG}"
  exit -1
fi
