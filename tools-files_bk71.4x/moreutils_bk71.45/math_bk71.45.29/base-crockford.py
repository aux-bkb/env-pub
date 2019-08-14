#!/usr/bin/env python3
#
import sys

import datetime

import base32_crockford
#from bases import Bases
#bases = Bases()


strdate = 0
if len(sys.argv) == 2:
    strdate=sys.argv[1]
    sys.stdout.write(str(base32_crockford.encode(strdate)).lower())
else:
    print("Err: no args")
    exit(1)


