#!/usr/bin/env python

import openpyxl
import openpyxl.drawing
import os

from glob import glob
from itertools import islice

from openpyxl.styles import Alignment

from pprint import pprint

def go(options):

    def g():
        def image(x):
            if x:
                return openpyxl.drawing.image.Image(x)
            return None
        images = sorted(glob(os.path.join(options.netid, '*.png')))
        it = iter(images)
        row = True
        while row:
            row = [image(x) for x in list(islice(it, options.width))]
            yield row

    rows1 = list(g())

    wb1 = openpyxl.Workbook()
    ws1 = wb1.active

    for i, row in enumerate(rows1):
        for j, v in enumerate(row):
            c = ws1.cell(row=i+1, column=j+1)
            ws1.add_image(v, c.coordinate)
            ws1.row_dimensions[c.row].height = options.imheight
            ws1.column_dimensions[c.column].width = options.imwidth

    wb1.save(options.xlsx1)

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
            '--xlsx1', 
            required=True, 
            type=str,
            help='''The XLSX output.'''
            )
    parser.add_argument(
            '--netid', 
            required=True, 
            type=str,
            help='''The directory of NetIDs.'''
            )
    parser.add_argument(
            '--imwidth', 
            required=True, 
            type=int,
            help='''The width of the image-containing columns.'''
            )
    parser.add_argument(
            '--imheight', 
            required=True, 
            type=int,
            help='''The height of the image-containing columns.'''
            )
    parser.add_argument(
            '--width', 
            required=True, 
            type=int,
            help='''The number of pictures per row.'''
            )
    return parser

if __name__ == '__main__':

    parser = mkparser('XLSX input to XLSX output.')

    options = parser.parse_args()

    go(options)


