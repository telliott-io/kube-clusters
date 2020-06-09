package kubeclusters

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestCivo(t *testing.T) {
	if testing.Short() {
		t.Skip()
	}
	runTestForEnv(t, "testdata/civo")
}

func TestDigitalOcean(t *testing.T) {
	if testing.Short() {
		t.Skip()
	}
	runTestForEnv(t, "testdata/digitalocean")
}

func runTestForEnv(t *testing.T, path string) {
	terraformOptions := &terraform.Options{
		// The path to where your Terraform code is located
		TerraformDir: path,
		EnvVars: map[string]string{
			"TF_LOGS": "TRACE",
		},
	}

	// At the end of the test, run `terraform destroy`
	defer terraform.Destroy(t, terraformOptions)

	// Run `terraform init` and `terraform apply`
	terraform.InitAndApply(t, terraformOptions)

	got := terraform.Output(t, terraformOptions, "hello")
	if got != "world" {
		t.Errorf("Expected %q, got %q", "world", got)
	}
}
