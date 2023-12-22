################################################################################
# MAKEFILE
#
# @file
# @version 0.1
#
##########
# PREREQUISITES
#   - 
#   - 
################################################################################

##############################
# FOUNDATION - DEFAULT
##############################
default: help
ACTION ?= plan
.PHONY: clean clean-all configure-all nomad-all nomad-init nomad-kill nomad-acl-boostrap nomad-jwks-harvest vault-jwks-url-configure vault-jwks-url-destroy nomad-job-test


##############################
# CLEAN
##############################
clean: #target ## Housekeeping

clean-all: vault-jwks-url-destroy nomad-kill #target ## Clean All


##############################
# ALL
##############################
configure-all: nomad-all vault-jwks-url-all #target ## Configure All


##############################
# NOMAD
##############################
nomad-all: nomad-init nomad-acl-boostrap nomad-jwks-harvest #target ## All Setup Targets for Nomad

nomad-init: # target ## Nomad Initialize
	@chmod 754 *.sh && \
	./01-01-nomad-init.sh

nomad-kill: # target ## Nomad Kill
	@chmod 754 *.sh && \
	./01-02-nomad-kill.sh

nomad-acl-boostrap: # target ## Nomad ACL Bootstrap
	@chmod 754 *.sh && \
	sleep 88 && \
	./01-03-nomad-acl-bootstrap.sh

nomad-jwks-harvest: # target ## Nomad JWKS Harvest for Manual insertion of Public Key in Vault JWT Role
	@chmod 754 *.sh && \
	source 01-03-nomad-acl-bootstrap.env && \
	./01-04-nomad-jwks-harvest.sh


##############################
# VAULT <= JWKS URL => NOMAD
##############################

vault-jwks-url-all: vault-jwks-url-configure nomad-job-test # target ## Vault JWKS URL - All


vault-jwks-url-configure: # target ## Vault JWKS URL - Configure
	@source 01-03-nomad-acl-bootstrap.env && \
	cd tf-jwks-url && \
	terraform init && terraform apply --auto-approve

vault-jwks-url-destroy: # target ## Vault JWKS URL - Destroy
	@source 01-03-nomad-acl-bootstrap.env && \
	cd tf-jwks-url && \
	terraform destroy --auto-approve


##############################
# NOMAD JOB TEST
##############################
nomad-job-test: # target ## Nomad Job Test
	@chmod 754 *.sh && \
	sleep 32 && \
	./03-01-nomad-job-test.sh && \
	cat *.out


##############################
# VAULT - SCRIPTS
##############################

# vault-auth: # target ## Vault Auth - JWT
# 	@chmod 754 *.sh && \
# 	./01-01-vault-auth-jwt.sh

# vault-auth-disable: # target ## Vault Auth - Disable
# 	@chmod 754 *.sh && \
# 	./01-02-vault-auth-disable.sh




##############################
# VAULT 
##############################

















##############################
# HELP
# REF GH @ jen20/hashidays-nyc/blob/master/terraform/GNUmakefile
##############################
.PHONY: help
help: #target ## Display help for this Makefile (default target).
	@echo "Valid targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

check_defined = \
		$(strip $(foreach 1,$1, \
		$(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
		$(if $(value $1),, \
		$(error Undefined $1$(if $2, ($2))))

