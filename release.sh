#!/bin/bash

cd /var/lib/myfrdcsa/collaborative/git/do-convert-logic && ./run.sh
cd /var/lib/myfrdcsa/collaborative/git/do-convert-logic && clean-emacs-backups -r
cd /var/lib/myfrdcsa/collaborative/git/do-convert-logic/scripts && ./update.sh
