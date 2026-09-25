import { github, javascript, typescript } from "projen";

const project = new typescript.TypeScriptProject({
  name: "proxmox-github-actions",
  packageManager: javascript.NodePackageManager.NPM,
  projenrcTs: true,
  github: true,
});

const workflow = project.github?.addWorkflow("terraform");

workflow?.on({
  push: {
    branches: ["main"],
  },

  workflowDispatch: {
    inputs: {
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
    },
  },
});

workflow?.addJob("plan", {
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
      run: "terraform init",
    },
    {
      name: "Terraform Plan",
      run: [
        "terraform plan",
        '-var="vm_name=${{ inputs.vm_name }}"',
        '-var="memory=${{ inputs.memory }}"',
        '-var="cpu_cores=${{ inputs.cpu_cores }}"',
        '-var="disk_size=${{ inputs.disk_size }}"',
        '-var="node_name=${{ inputs.node_name }}"',
        '-var="datastore_id=${{ inputs.datastore_id }}"',
        '-var="vm_username=${{ inputs.vm_username }}"',
      ].join(" "),
    },
  ],
});

workflow?.addJob("apply", {
  name: "Terraform Apply",
  runsOn: ["self-hosted"],

  needs: ["plan"],

  permissions: {
    contents: github.workflows.JobPermission.READ,
  },

  environment: "terraform-apply",

  steps: [
    {
      name: "Terraform Apply",
      run: [
        "terraform apply",
        '-var="vm_name=${{ inputs.vm_name }}"',
        '-var="memory=${{ inputs.memory }}"',
        '-var="cpu_cores=${{ inputs.cpu_cores }}"',
        '-var="disk_size=${{ inputs.disk_size }}"',
        '-var="node_name=${{ inputs.node_name }}"',
        '-var="datastore_id=${{ inputs.datastore_id }}"',
        '-var="vm_username=${{ inputs.vm_username }}"',
      ].join(" "),
    },
  ],
});
project.tasks.addTask("copy-github", {
  exec: "cp -R .github ../.github",
});

project.synth();
