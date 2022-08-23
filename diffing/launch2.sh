#!/bin/bash

# swipl -s test.pl -g "getPrologContentsForPrologFileNameAndRevision('/var/lib/myfrdcsa/collaborative/git/do-convert-logic/diffing/sample.do',0,Contents)."

swipl -s test.pl -g "getDiff."
