#!/bin/bash

if [ ${#} -ne 1 ]; then
  echo "Usage: ${0} <path>"
fi

basedir=${1}
DOCUMENT_ROOT=${basedir}/docs
maxDepth=4
expectedFooter="$DOCUMENT_ROOT/legal_notice.md $DOCUMENT_ROOT/accessibility.md $DOCUMENT_ROOT/data_protection_declaration.md"

MSG=$(find ${DOCUMENT_ROOT} -name "*.md" | awk -F'/' '{print $0,NF}' | while IFS=' ' read string depth
  do
    #echo "string=${string} depth=${depth}"

    # max depth check 
    if [ "${depth}" -gt $maxDepth ]; then
      echo "max depth ($maxDepth) exceeded for ${string}"
    fi

    md=${string#${DOCUMENT_ROOT}/}

    # md included in nav 
    numberOfReferences=`sed -n '/nav:/,/^$/p' ${basedir}/mkdocs.yml | grep -c ${md}`
    if [ $numberOfReferences -eq 0 ]; then
      # fallback: md included in footer 
      if [[ "${expectedFooter}" =~ ${string} ]]; then
        numberOfReferencesInFooter=`sed -n '/footer:/,/^$/p' ${basedir}/mkdocs.yml | grep -c /${md%.md}`
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
)
if [ ! -z "${MSG}" ]; then
  echo "${MSG}"
  exit -1
fi
