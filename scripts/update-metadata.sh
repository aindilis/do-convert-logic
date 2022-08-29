#!/bin/bash

cd /var/lib/myfrdcsa/collaborative/git/do-convert-logic && swipl -s do_convert_logic.pl -g "processFile('$1'),testDCL,halt."
