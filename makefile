.PHONY: install-pre-commit

install-pre-commit-tools:
	curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
	curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sudo sh -s -- -b /usr/local/bin v0.62.1

run-pre-commit:
	terraform fmt --recursive
	terraform validate
	tflint --init
	tflint --chdir=terraform
	trivy config ./terraform