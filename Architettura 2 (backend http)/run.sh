#! /bin/bash

echo "----- Pronto per eseguire terragrunt $1 -----"

export AWS_PROFILE=angelo_varelli
export TFE_PARALLELISM=4

export TERRAGRUNT_PARALLELISM=1

terragrunt run-all $1