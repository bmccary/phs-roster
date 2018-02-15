#!/usr/bin/env python

import csv
import os

def go(options):

    with open(options.csv, 'r') as r:
        N = {row['netid']: row for row in csv.DictReader(r)}

    with open(options.csv0, 'r') as r:
        rows = list(csv.reader(r))

    def g():
        yield r'\documentclass[10pt]{article}'
        yield r'\usepackage[top=6mm,left=2mm,bottom=6mm,right=2mm]{geometry}'
        yield r'\usepackage{nopageno}'
        yield r'\usepackage{graphicx}'

        yield r'\def\imwidth{50mm}'

        if options.sty:
            yield r'\usepackage{{{sty}}}'.format(sty=options.sty)

        yield r'\begin{document}'
        yield r'\pagestyle{empty}'
        yield r'\begin{center}'

        def image(x):
            if x:
                path = os.path.join(options.netid, '{x}.png'.format(x=x))
                return r'\includegraphics[width=\imwidth]{{{path}}}'.format(path=path)
            return None

        def name(x):
            if x:
                return r'{last_name}, {first_name}'.format(**N[x])
            return None

        def netid(x):
            if x:
                return r'\texttt{{{netid}}}'.format(**N[x])
            return None

        W = max(len(row) for row in rows)
        cs = '|'.join('c'*W)

        yield r'\begin{{tabular}}{{|{cs}|}}'.format(cs=cs)
        yield r'\hline'

        def pg(row):
            for i, x in enumerate(row):
                yield x
            for j in range(i+1, W):
                yield None

        def join(row):
            return ' & '.join(x or '' for x in row) + r'\\ \hline'

        for row in rows:
            yield join([image(x) for x in pg(row)])
            yield join([name(x) for x in pg(row)])
            yield join([netid(x) for x in pg(row)])
            yield join([None for x in pg(row)])

        yield r'\end{tabular}'
        yield r'\end{center}'
        yield r'\end{document}'

    with open(options.tex1, 'w') as w:
        for line in g():
            w.write(line + '\n')

import argparse

class HelpFormatter(argparse.ArgumentDefaultsHelpFormatter):
    def add_arguments(self, actions):
        actions = sorted(actions, key=attrgetter('option_strings'))
        super(HelpFormatter, self).add_arguments(actions)

def mkparser(description):
    parser = argparse.ArgumentParser(
                    description=description,
                    formatter_class=HelpFormatter,
                )
    parser.add_argument(
            '--debug', 
            type=int,
            default=0,
            help='''Turn on script debugging.'''
        )
    parser.add_argument(
            '--csv0', 
            required=True, 
            type=str,
            help='''The CSV input.'''
            )
    parser.add_argument(
            '--tex1', 
            required=True, 
            type=str,
            help='''The TeX output.'''
            )
    parser.add_argument(
            '--netid', 
            required=True, 
            type=str,
            help='''The directory of NetIDs.'''
            )
    parser.add_argument(
            '--csv', 
            required=True, 
            type=str,
            help='''The CSV of known NetIDs.'''
            )
    parser.add_argument(
            '--sty', 
            type=str,
            help='''The STY to include.'''
            )
    return parser

if __name__ == '__main__':

    parser = mkparser('XLSX input to XLSX output.')

    options = parser.parse_args()

    go(options)


