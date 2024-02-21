def main(*args):
    txt = args[0]
    words = args[1:]

    for w in words:
        w = w.strip()
        w = w.replace('/', '-')
        w = w.replace('\\', '-')
        with open(txt) as f:
            found = False
            for line in f:
                # Could contain / or \ as path separators
                line = line.rstrip()
                line = line.replace('/', '-')
                line = line.replace('\\', '-')
                if w in line:
                    print(f'   {w[:10]} Found in {txt}')
                    found = True
                    break
            if not found:
                print(f'   {w[:10]} NOT in {txt}')
                exit(1)


if __name__ == "__main__":
    import sys

    main(*sys.argv[1:])
