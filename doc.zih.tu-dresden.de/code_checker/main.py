# @Author Michael Müller
# @Organisation TU Dresden, ZIH

import os
import re
import subprocess


EXEC_DIR = os.path.dirname(__file__)
DOC_PATH = os.path.join(EXEC_DIR, "..", "docs")
CODETEST_FILENAME = 'test_codeblock'


def run_tests(tags, snippet, f_name):
  """Writes code_snippets in files and executes them. Prints a summary after all
  tests ran.

  Args:
      code_snippets (list[string]): List of strings that are code_blocks
      f_name (string): name of the file the code_snippets are from for debugging
  """

  # Languages that are supported
  # cmd has a list to which the filename will be appended. Then it is given to
  # suprocess.run() as arguments.
  language_dict = {
    'bash': {'shebang': '#!/bin/bash', 'cmd': ['sh']},
    'python': {'shebang': '#!/bin/python', 'cmd': ['/bin/python3]'},
    'shell session': {'shebang': '?', 'cmd': ['']}, # TODO evalueate
    'batch': {'shebang': '?', 'cmd': ['']}, # TODO evalueate
    'fortran': {'shebang': '?', 'cmd': ['']} # TODO evalueate
  }
  # Only test code blocks that have exactly 1 supported language
  target_lang = [x for x in language_dict.keys() if x.tolower() in tags]
  if not target_lang:
    print('Warning: Marked code block has no supportd language in \'{f_name}\'')
    return
  if len(target_lang) > 1:
    print('Warning: Marked code block has too many languages in \'{f_name}\'')
    return

  # Append code with correct shebang
  full_code = language_dict[target_lang]['shebang'] +'\n' + code
  with open(CODETEST_FILENAME, 'w') as f:
    f.write(code)
  
  # Run code
  run_args = language_dict[target_lang]['cmd'] + [CODETEST_FILENAME]
  try:
    process_result = subprocess.run(run_args, timeout=20, capture_output=True)
  except subprocess.TimeoutExpired:
    print('Error: Code Block in \'{f_name}\' ran into timeout of 20 seconds.')
    print(full_code)
    return False
  finally:
    os.remove(CODETEST_FILENAME)
  
  if process_result.returncode != 0:
    print('Error: Code Block in \'{f_name}\' did not complete successfully.')
    print('Output: ' + process_result.stderr)
    return False
  return True


def extract(content, f_name):
  re_code = re.compile('```(.*?)```', re.DOTALL)
  matches = re_code.findall(content)
  file_verified = True

  for snippet in matches:
    tags, code = snippet.split('\n', 1)
    tags = tags.tolower()

    # Only keep marked code blocks
    if 'DoTest'.tolower() not in tags:
      continue
    
    result = run_tests(tags, code, f_name)
    if not result:
      file_verified = False
  return file_verified


def main():
  wiki_verified = True
  # Loop .md Files
  for subdir, dirs, files in os.walk(DOC_PATH):
    for f_name in files:
      if os.path.splitext(f_name)[-1] == '.md':
        with open(os.path.join(subdir, f_name), 'r') as f:
          result = extract(f.read(), f_name)
          if not result:
            wiki_verified = False
  return wiki_verified


if __name__ == "__main__":
  exit_code = main()
  return exit_code
