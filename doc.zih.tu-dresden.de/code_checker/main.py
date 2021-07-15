# @Author Michael Müller
# @Organisation TU Dresden, ZIH

import os
import re


def extract(content, f_name):
  re_code = re.compile('```(.*?)```', re.DOTALL)
  
  matches = re_code.findall(content)
  # TODO filter for testing keyword here!
  code_snippets = ['\n'.join(x.split('\n')[1:]) for x in matches] #if 'Bash' in x.split('\n')[0]]
  if code_snippets:
    print('===='+f_name+'====')
    print('\n------------\n'.join(code_snippets))
    # TODO Do pipeline tests here!


def main():
  exec_dir = os.path.dirname(__file__)
  DOC_PATH = os.path.join(exec_dir, "..", "docs")

  # Loop .md Files
  for subdir, dirs, files in os.walk(DOC_PATH):
    for f_name in files:
      if os.path.splitext(f_name)[-1] == '.md':
        with open(os.path.join(subdir, f_name), 'r') as f:
          extract(f.read(), f_name)


if __name__ == "__main__":
  main()  
