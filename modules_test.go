package kubeclusters

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestDigitalOcean(t *testing.T) {
	runTestForEnv(t, "testdata/digitalocean")
}

func TestGKE(t *testing.T) {
	runTestForEnv(t, "testdata/gke")
}

func runTestForEnv(t *testing.T, path string) {
	if testing.Short() {
		t.Skip()
	}
	terraformOptions := &terraform.Options{
		// The path to where your Terraform code is located
		TerraformDir: path,
	}

	// At the end of the test, run `terraform destroy`
	defer terraform.Destroy(t, terraformOptions)

	// Run `terraform init` and `terraform apply`
	terraform.InitAndApply(t, terraformOptions)

	got := terraform.Output(t, terraformOptions, "hello")
	if got != "world" {
		t.Errorf("Expected %q, got %q", "world", got)
	}

	// Verify loading config via context module

	terraformOptions = &terraform.Options{
		// The path to where your Terraform code is located
		TerraformDir: fmt.Sprintf("%v/context", path),
	}

	// At the end of the test, run `terraform destroy`
	defer terraform.Destroy(t, terraformOptions)

	// Run `terraform init` and `terraform apply`
	terraform.InitAndApply(t, terraformOptions)

	got = terraform.Output(t, terraformOptions, "hello")
	if got != "world" {
		t.Errorf("Expected %q, got %q", "world", got)
	}
}
