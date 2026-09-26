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

/**
 * Terraform variables passed from GitHub Actions secrets.
 */
const terraformVariables = [
  '-var="vm_password=${{ secrets.VM_PASSWORD }}"',
  '-var="vm_username=${{ secrets.VM_USERNAME }}"',
  '-var="proxmox_api_token=${{ secrets.PROXMOX_API_TOKEN }}"',
  '-var="proxmox_endpoint=${{ secrets.PROXMOX_ENDPOINT }}"',
];

/**
 * Terraform Plan
 *
 * Manual execution only.
 *
 * Shows the complete Terraform plan in the GitHub Actions Summary.
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
        "-out=tfplan",
        ...terraformVariables,
        "| tee plan.txt",
      ].join(" "),
    },

    {
      name: "Add Plan to Summary",
      run: [
        'echo "## Terraform Plan" >> "$GITHUB_STEP_SUMMARY"',
        'echo "" >> "$GITHUB_STEP_SUMMARY"',
        "echo '```text' >> \"$GITHUB_STEP_SUMMARY\"",
        'cat plan.txt >> "$GITHUB_STEP_SUMMARY"',
        "echo '```' >> \"$GITHUB_STEP_SUMMARY\"",
      ].join("\n"),
    },

    {
      name: "Upload Terraform Plan",
      uses: "actions/upload-artifact@v4",
      with: {
        name: "terraform-plan",
        path: "tfplan",
        retentionDays: "1",
      },
    },
  ],
});

/**
 * Terraform Apply
 *
 * Manual execution only.
 *
 * First shows the plan, then requires approval through the
 * terraform-apply GitHub Environment before applying.
 */
const applyWorkflow = project.github?.addWorkflow("terraform-apply");

applyWorkflow?.on({
  workflowDispatch: {},
});

/**
 * First job: generate and display the plan.
 */
applyWorkflow?.addJob("plan", {
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
        "-out=tfplan",
        ...terraformVariables,
        "| tee plan.txt",
      ].join(" "),
    },

    {
      name: "Add Plan to Summary",
      run: [
        'echo "## Terraform Plan" >> "$GITHUB_STEP_SUMMARY"',
        'echo "" >> "$GITHUB_STEP_SUMMARY"',
        "echo '```text' >> \"$GITHUB_STEP_SUMMARY\"",
        'cat plan.txt >> "$GITHUB_STEP_SUMMARY"',
        "echo '```' >> \"$GITHUB_STEP_SUMMARY\"",
      ].join("\n"),
    },

    {
      name: "Upload Terraform Plan",
      uses: "actions/upload-artifact@v4",
      with: {
        name: "terraform-plan",
        path: "tfplan",
        retentionDays: "1",
      },
    },
  ],
});

/**
 * Second job: requires environment approval before applying.
 */
applyWorkflow?.addJob("apply", {
  name: "Terraform Apply",

  runsOn: ["self-hosted"],

  needs: ["plan"],

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
      name: "Download Terraform Plan",
      uses: "actions/download-artifact@v4",
      with: {
        name: "terraform-plan",
      },
    },

    {
      name: "Terraform Init",
      run: "terraform init -input=false -no-color",
    },

    {
      name: "Terraform Apply",
      run: "terraform apply -input=false -no-color -auto-approve tfplan",
    },
  ],
});

/**
 * Terraform Destroy
 *
 * Manual execution only.
 *
 * Requires approval through the terraform-apply environment.
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

/**
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
