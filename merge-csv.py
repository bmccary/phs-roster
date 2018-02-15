
from __future__ import print_function

import sys

import csv

from operator import itemgetter
from itertools import groupby

def go(args):

    def g():
        for x in args.csv0:
            with open(x, 'r') as r:
                reader = csv.DictReader(r)
                for row in reader:
                    yield row

    X = sorted(g(), key=itemgetter('netid'))

    def g():
        for netid, rows in groupby(X, itemgetter('netid')):
            rows = list(rows)
            for x in ['first_name', 'last_name',]:
                Y = set(y[x] for y in rows)
                assert len(Y) == 1, 'Non-unique "{x}" for netid "{netid}".'.format(x=x, netid=netid)
            yield rows[0]

    X = list(g())

    fieldnames = ['netid', 'last_name', 'first_name',]

    with open(args.csv1, 'w') as w:
        writer = csv.DictWriter(w, fieldnames=fieldnames, extrasaction='ignore')
        writer.writeheader()
        writer.writerows(X)

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
            nargs='+',
            type=str, 
            help='''The CSV input(s).'''
        )
    parser.add_argument(
            '--csv1', 
            type=str, 
            default='-',
            help='''The CSV output.'''
        )
    return parser

if __name__ == '__main__':

    parser = mkparser('Merge the CSVs')

    args = parser.parse_args()

    go(args)

# vim:ts=4:sw=4:et

