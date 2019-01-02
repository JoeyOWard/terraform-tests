terraform {

  required_version = ">= 0.11.10, < 0.12"

    backend "s3"{
      bucket         = "terraform-test-jw"
      key            = "stage/services/webserver-cluster/terraform.tfstate"
      region         = "us-east-1"
    }
}


data "terraform_remote_state" "db" {
      backend = "s3"

      config {

        bucket         = "terraform-test-jw"
        key            = "stage/data-stores/mysql/terraform.tfstate"
        region         = "us-east-1"

      }

}

data "template_file" "user_data" {
  template = "${file("user-data.sh")}"

  vars {
    server_port = "${var.server_port}"
    db_address  = "${data.terraform_remote_state.db.address}"
    db_port     = "${data.terraform_remote_state.db.port}"
  }
}






