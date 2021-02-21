#!/bin/bash
terraform apply -var "do_token=${DO_PAT}" -var "pvt_key=./id_rsa"
