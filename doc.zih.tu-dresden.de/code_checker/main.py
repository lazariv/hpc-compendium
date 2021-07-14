# @Author Michael Müller
# @Organisation TU Dresden, ZIH

import os
import re

def main():
  exec_dir = os.path.dirname(__file__)
  DOC_PATH = os.path.join(exec_dir, "..", "docs")
  TEST_FILE = os.path.join(DOC_PATH, 'jobs_and_resources', 'slurm.md')
  with open(TEST_FILE, 'r') as f:
    content = f.read()
  re_code = re.compile('```(.*?)```', re.DOTALL)
  results = re_code.findall(content)
  # This contains only code
  # TODO replace "Bash" in if with the testing keyword.
  # TODO loop over all files
  # TODO move to function!
  code_snippets = [x.split('\n')[1:] for x in results if 'Bash' in x.split('\n')[0]]

if __name__ == "__main__":
  main()
  
