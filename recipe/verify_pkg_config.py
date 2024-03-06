# Usage: python verify_pkg_config.py <file> <word1> <word2> ...
import os


def normalize_path_separator(s):
    return s.replace('/', '-').replace('\\', '-')

def find_regsvr32():
    regsvr32 = os.path.join(
        os.environ['SystemRoot'],
        'System32' if os.environ['PROCESSOR_ARCHITECTURE'] == 'AMD64' else 'SysWOW64',
        'regsvr32.exe',
    )

def main(*args):
    txt, *words = args
    normalized_words = [normalize_path_separator(w.strip()) for w in words]

    with open(txt) as f:
        lines = [normalize_path_separator(line.rstrip()) for line in f]

    for w in normalized_words:
        found = any(w in line for line in lines)
        status = "Found" if found else "NOT"
        print(f'   {w[:15]} {status} in {txt}')

        if not found:
            exit(1)


if __name__ == "__main__":
    import sys

    main(*sys.argv[1:])
