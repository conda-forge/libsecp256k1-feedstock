import re


def main(*args):
    txt = args[0]
    words = args[1:]

    with open(txt) as f:
        found = False
        for line in f:
            line = line.replace('\\', '\\\\')
            for w in words:
                w = w.replace('\\', '\\\\')
                if re.search(w, line):
                    print(line)
                    found = True
                    break
        if not found:
            exit(1)


if __name__ == "__main__":
    import sys
    
    main(*sys.argv[1:])
