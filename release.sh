#!/bin/bash

cd /var/lib/myfrdcsa/collaborative/git/do-convert-logic && swipl -s logic.pl -g 'testDCL,halt' # run.sh
cd /var/lib/myfrdcsa/collaborative/git/do-convert-logic && clean-emacs-backups -r
cd /var/lib/myfrdcsa/collaborative/git/do-convert-logic/scripts && ./update.sh
cd /var/lib/myfrdcsa/collaborative/git/do-convert-logic && git diff
