terraform {
  backend "gcs" {
    bucket  = "tf-state-project-b84fbdfe-5665-4285-ad8"
    prefix  = "terraform/state"
  }
}
