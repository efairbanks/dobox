#!/bin/bash
terraform destroy -var "do_token=${DO_PAT}" -var "pvt_key=./id_rsa"
