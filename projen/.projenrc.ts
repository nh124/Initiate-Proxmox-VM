import { github, javascript, typescript } from "projen";
import * as fs from "fs";
import * as path from "path";

const project = new typescript.TypeScriptProject({
  name: "proxmox-github-actions",

  packageManager: javascript.NodePackageManager.NPM,

  projenrcTs: true,

  // Keep GitHub enabled so we can create our own workflows.
  github: true,

  // Disable Projen's default workflows/features.
  buildWorkflow: false,
  release: false,
  releaseToNpm: false,

  githubOptions: {
    pullRequestLint: false,
  },
});

/**
 * Inputs shared by all Terraform workflows.
 */
const terraformInputs = {
  vm_name: {
    description: "VM name",
    required: true,
    default: "forgejo-dev-server",
    type: "string",
  },

  memory: {
    description: "Memory in MB",
    required: true,
    default: "2048",
    type: "string",
  },

  cpu_cores: {
    description: "CPU cores",
    required: true,
    default: "2",
    type: "string",
  },

  disk_size: {
    description: "Disk size in GB",
    required: true,
    default: "10",
    type: "string",
  },

  node_name: {
    description: "Proxmox node",
    required: true,
    default: "pve",
    type: "string",
  },

  datastore_id: {
    description: "VM datastore",
    required: true,
    default: "big-4tb",
    type: "string",
  },

  vm_username: {
    description: "VM username",
    required: true,
    default: "ubuntu",
    type: "string",
  },
} as const;

/**
 * Terraform variables passed to Terraform CLI commands.
 */
const terraformVariables = [
  '-var="vm_name=${{ inputs.vm_name }}"',
  '-var="memory=${{ inputs.memory }}"',
  '-var="cpu_cores=${{ inputs.cpu_cores }}"',
  '-var="disk_size=${{ inputs.disk_size }}"',
  '-var="node_name=${{ inputs.node_name }}"',
  '-var="datastore_id=${{ inputs.datastore_id }}"',
  '-var="vm_username=${{ inputs.vm_username }}"',
  '-var="vm_password=${{ secrets.VM_PASSWORD }}"',
  '-var="proxmox_api_token=${{ secrets.PROXMOX_API_TOKEN }}"',
];

/**
 * Terraform Plan
 */
const planWorkflow = project.github?.addWorkflow("terraform");

planWorkflow?.on({
  workflowDispatch: {
    inputs: terraformInputs,
  },
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

/**
 * Terraform Apply
 */
const applyWorkflow = project.github?.addWorkflow("terraform-apply");

applyWorkflow?.on({
  workflowDispatch: {
    inputs: terraformInputs,
  },
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

/**
 * Terraform Destroy
 */
const destroyWorkflow = project.github?.addWorkflow("terraform-destroy");

destroyWorkflow?.on({
  workflowDispatch: {
    inputs: terraformInputs,
  },
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
 * Synthesize the Projen project.
 */
project.synth();

/**
 * Copy only the generated GitHub workflows
 * from the Projen directory to the repository root.
 *
 * projen/.github/workflows
 *             ↓
 * ../.github/workflows
 */
const sourceWorkflows = path.join(process.cwd(), ".github", "workflows");

const rootWorkflows = path.join(process.cwd(), "..", ".github", "workflows");

fs.mkdirSync(rootWorkflows, { recursive: true });

for (const file of fs.readdirSync(sourceWorkflows)) {
  if (file.endsWith(".yml") || file.endsWith(".yaml")) {
    fs.copyFileSync(
      path.join(sourceWorkflows, file),
      path.join(rootWorkflows, file)
    );
  }
}
