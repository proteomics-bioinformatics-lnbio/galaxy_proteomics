#!/usr/bin/env python
import optparse
import os
import shutil
import sys
import tempfile
import subprocess
import logging

import re


def parse_groups(inputs_file):
    inputs_lines = [line.strip() for line in open(inputs_file, "r").readlines()]
    inputs_lines = [line for line in inputs_lines if line and not line.startswith("#")]

    i = 0
    groups = []
    while i < len(inputs_lines):
        groups.append({"path": inputs_lines[i],
                       "name": re.sub(r'.raw$', "", inputs_lines[i+1]),
                       "sample": inputs_lines[i+2],
                       "experiment": inputs_lines[i+3],
                       "group": inputs_lines[i+4]})
        i += 5
    return groups


def setup_inputs(input_groups_path, f):
    parsed_groups = parse_groups(input_groups_path)
    
    names = [x['name'] for x in parsed_groups]
    paths = [os.path.abspath(name+".raw") for name in names]
    paths_intermediate = [x['path'] for x in parsed_groups]
    samples = [x['sample'] for x in parsed_groups]
    experiments = [x['experiment'] for x in parsed_groups]
    groups = [x['group'] for x in parsed_groups]

    f.write('Name\t Fraction\t Experiment\n')
    for (name,sample,exp) in zip(names, samples, experiments):
        f.write(name+'\t'+sample+'\t'+exp+'\n')


parser = optparse.OptionParser()
parser.add_option("--input_groups")
parser.add_option("--output")


(options, args) = parser.parse_args()
f = open(options.output, 'w')

raw_file_info = setup_inputs(options.input_groups, f)

f.close()
