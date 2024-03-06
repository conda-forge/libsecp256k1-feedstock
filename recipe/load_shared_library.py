# Usage: python verify_pkg_config.py <file> <word1> <word2> ...
import os


def normalize_path_separator(s):
    return s.replace('/', '-').replace('\\', '-')


def find_regsvr32():
    return os.path.join(
        os.environ['SystemRoot'],
        'System32'
        if os.environ['PROCESSOR_ARCHITECTURE'] == 'AMD64'
        else 'SysWOW64',
        'regsvr32.exe',
    )


def load_library(library_name):
    from ctypes import CDLL

    if os.name == 'nt':
        regsvr32 = find_regsvr32()
        if not os.path.exists(regsvr32):
            raise FileNotFoundError(f'Could not find {regsvr32}')

        try:
            CDLL(library_name)
        except OSError as e:
            if 'DLL' in e.args[0]:
                os.system(f'{regsvr32} /s {library_name}')
            else:
                raise


def main(*args):
    library_path, *words = args
    library_path = normalize_path_separator(library_path.strip())

    load_library(library_path)


if __name__ == "__main__":
    import sys

    main(*sys.argv[1:])
