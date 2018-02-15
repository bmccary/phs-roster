
from __future__ import print_function

from io import StringIO

from operator import itemgetter

import sys

import re

import csv

STUDENT = re.compile(r'^(?P<last_name>[^,]+),\s+(?P<first_name>[^(]+)\((?P<netid>[^)]*)\)$')

def go(args):

    if args.txt == '-':
        s = sys.stdin.read()
    else:
        with open(args.txt, 'r') as r:
            s = r.read()

    s = s.replace('\r','\n')
    s = s.replace('\n\n','\n')
    s = s.replace('\n\n','\n')
    s = s.replace('\n(',' (')
    s = s.replace(',\n',', ')

    try:
        t = unicode(s)
        s = t
    except NameError:
        pass

    s = StringIO(s)

    def g():

        j = 0
        i_missing_netid = 0

        for line in s.readlines():

            line = line.strip()

            if not line:
                if args.debug > 1: print('D:', line)
                continue

            if line.startswith('UT Dallas ::'):
                if args.debug > 1: print('D:', line)
                continue

            if line.startswith('Printed:'):
                if args.debug > 1: print('D:', line)
                continue

            if line.startswith('Generated:'):
                if args.debug > 1: print('D:', line)
                continue

            if line.isdigit():
                if args.debug > 1: print('D:', line)
                continue

            m = STUDENT.match(line)

            if not m:
                raise Exception('Parse error: "{}"'.format(line))

            if args.debug > 0: print('S:', line)
      
            last_name  = m.group('last_name')
            first_name = m.group('first_name')
            netid      = m.group('netid')

            last_name  = last_name.strip()
            first_name = first_name.strip()
            netid      = netid.strip()

            netid = netid.lower()

            if not netid:
                netid = 'missing-netid-{:03d}'.format(i_missing_netid)
                i_missing_netid += 1

            yield { 
                        'j'          : '{:03d}'.format(j),
                        'last_name'  : last_name, 
                        'first_name' : first_name, 
                        'netid'      : netid,
                    }

            j += 1

    rows = list(g())

    sorted_rows = sorted(rows, key=itemgetter('last_name', 'first_name', 'netid'))

    if rows != sorted_rows:
        sys.stderr.write('\n'*8)
        sys.stderr.write('*'*80 + '\n')
        sys.stderr.write('Not sorted! There could be an association problem!\n')
        sys.stderr.write('*'*80 + '\n')
        sys.stderr.write('\n'*8)

    rows = sorted_rows

    X = set(x['netid'] for x in rows)

    assert len(X) == len(rows), 'Non-unique NetIDs.'

    def g():
        for i, row in enumerate(rows):
            row['i'] = '{:03d}'.format(i)
            yield row

    rows = list(g())

    fieldnames = ['i', 'netid', 'last_name', 'first_name', 'j',]

    if args.csv == '-':
        c = csv.DictWriter(sys.stdout, fieldnames=fieldnames)
        c.writeheader()
        c.writerows(rows) 
    else:
        with open(args.csv, 'w') as w:
            c = csv.DictWriter(w, fieldnames=fieldnames)
            c.writeheader()
            c.writerows(rows) 

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
            '--txt', 
            type=str, 
            default='-',
            help='''The TXT input.'''
        )
    parser.add_argument(
            '--csv', 
            type=str, 
            default='-',
            help='''The CSV output.'''
        )
    return parser

if __name__ == '__main__':

    parser = mkparser('Roster .txt to .csv')

    args = parser.parse_args()

    go(args)

# vim:ts=4:sw=4:et

