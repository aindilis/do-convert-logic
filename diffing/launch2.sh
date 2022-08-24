#!/bin/bash

# swipl -s logic3.pl -g "getPrologContentsForPrologFileNameAndRevision('/var/lib/myfrdcsa/collaborative/git/do-convert-logic/diffing/sample.do',0,Contents)."

swipl -s logic3.pl -g "getDiff('/var/lib/myfrdcsa/collaborative/git/do-convert-logic/diffing/sample.do',Changes)."
