def main(*args):
    txt = args[0]
    words = args[1:]

    for w in words:
        w = w.replace('\\', '\\\\').strip()
        with open(txt) as f:
            found = False
            for line in f:
                line = line.replace('\\', '\\\\').rstrip()
                if w in line:
                    print('PASS')
                    found = True
                    break
            if not found:
                exit(1)


if __name__ == "__main__":
    import sys

    main(*sys.argv[1:])
