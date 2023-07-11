#Configure Terraform Cloud as Backend
terraform {
  cloud {
    organization = "MFosterLUIT22"

    workspaces {
      name = "Wk22-MelFoster"
    }
  }
}