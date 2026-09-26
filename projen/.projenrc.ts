import { github, javascript, typescript } from "projen";
import * as fs from "fs";
import * as path from "path";

const project = new typescript.TypeScriptProject({
  name: "proxmox-github-actions",

  packageManager: javascript.NodePackageManager.NPM,

  projenrcTs: true,

  // Enable GitHub so we can create custom workflows.
  github: true,

  // Disable Projen's default workflows.
  buildWorkflow: false,
  release: false,
  releaseToNpm: false,

  githubOptions: {
    pullRequestLint: false,
  },
});

/*
 * Only secrets come from GitHub Actions.
 *
 * All VM configuration is defined in Terraform.
 */
const terraformVariables = [
  '-var="vm_password=${{ secrets.VM_PASSWORD }}"',
  '-var="proxmox_api_token=${{ secrets.PROXMOX_API_TOKEN }}"',
  '-proxmox_endpoint=${{ secrets.PROXMOX_ENDPOINT }}"',
];

/*
 * Terraform Plan
 *
 * Manual execution only.
 */
const planWorkflow = project.github?.addWorkflow("terraform");

planWorkflow?.on({
  workflowDispatch: {},
});

planWorkflow?.addJob("plan", {
  name: "Terraform Plan",
  runsOn: ["self-hosted"],

  permissions: {
    contents: github.workflows.JobPermission.READ,
  },

  steps: [
    {
      name: "Checkout",
      uses: "actions/checkout@v4",
    },
    {
      name: "Terraform Init",
      run: "terraform init -input=false -no-color",
    },
    {
      name: "Terraform Plan",
      run: [
        "terraform plan",
        "-input=false",
        "-no-color",
        ...terraformVariables,
      ].join(" "),
    },
  ],
});

/*
 * Terraform Apply
 *
 * Manual execution only.
 */
const applyWorkflow = project.github?.addWorkflow("terraform-apply");

applyWorkflow?.on({
  workflowDispatch: {},
});

applyWorkflow?.addJob("apply", {
  name: "Terraform Apply",
  runsOn: ["self-hosted"],

  environment: "terraform-apply",

  permissions: {
    contents: github.workflows.JobPermission.READ,
  },

  steps: [
    {
      name: "Checkout",
      uses: "actions/checkout@v4",
    },
    {
      name: "Terraform Init",
      run: "terraform init -input=false -no-color",
    },
    {
      name: "Terraform Apply",
      run: [
        "terraform apply",
        "-auto-approve",
        "-input=false",
        "-no-color",
        ...terraformVariables,
      ].join(" "),
    },
  ],
});

/*
 * Terraform Destroy
 *
 * Manual execution only.
 */
const destroyWorkflow = project.github?.addWorkflow("terraform-destroy");

destroyWorkflow?.on({
  workflowDispatch: {},
});

destroyWorkflow?.addJob("destroy", {
  name: "Terraform Destroy",
  runsOn: ["self-hosted"],

  environment: "terraform-apply",

  permissions: {
    contents: github.workflows.JobPermission.READ,
  },

  steps: [
    {
      name: "Checkout",
      uses: "actions/checkout@v4",
    },
    {
      name: "Terraform Init",
      run: "terraform init -input=false -no-color",
    },
    {
      name: "Terraform Destroy",
      run: [
        "terraform destroy",
        "-auto-approve",
        "-input=false",
        "-no-color",
        ...terraformVariables,
      ].join(" "),
    },
  ],
});

/*
 * Generate the Projen project.
 */
project.synth();

const sourceWorkflows = path.join(process.cwd(), ".github", "workflows");

const rootWorkflows = path.join(process.cwd(), "..", ".github", "workflows");

fs.mkdirSync(rootWorkflows, { recursive: true });

const workflowFiles = [
  "terraform.yml",
  "terraform-apply.yml",
  "terraform-destroy.yml",
];

for (const file of workflowFiles) {
  const source = path.join(sourceWorkflows, file);
  const destination = path.join(rootWorkflows, file);

  // Make the generated file writable by the current user.
  fs.chmodSync(source, 0o644);

  // Make an existing destination file writable before overwriting it.
  if (fs.existsSync(destination)) {
    fs.chmodSync(destination, 0o644);
  }

  fs.copyFileSync(source, destination);

  console.log(`Copied ${file} → ${destination}`);
}
