package kubeclusters

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestCivo(t *testing.T) {
	if testing.Short() {
		t.Skip()
	}
	terraformOptions := &terraform.Options{
		// The path to where your Terraform code is located
		TerraformDir: ".",
		Vars: map[string]interface{}{
			"civo_api_token": "H5KtzxPFkYb9V1ER6l04Cq2fnGILXcJOS7AjNTvagW8roymDuZ",
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
