resource "aws_s3_bucket" "static_bucket" {
    bucket =  var.static_bucket_name
}

resource "aws_s3_bucket_policy" "bucket_policy" {
    bucket = aws_s3_bucket.static_bucket.id
    policy = file("./bucket_policy.json")
}

resource "aws_s3_bucket_acl" "bucket_acl" {
    bucket = aws_s3_bucket.static_bucket.id
    acl = "public-read"
}

resource "aws_s3_object" "index" {
    bucket = aws_s3_bucket.static_bucket.id
    key = "index.html"
    source = "../index.html"
    acl = "public-read"
    content_type = lookup(local.mime_types, regex("\\.[^.]+$", "index.html"), null)
}

resource "aws_s3_object" "img" {
    bucket = aws_s3_bucket.static_bucket.id
    for_each = fileset("../img/", "*")
    key = "img/${each.value}"
    source = "../img/${each.value}"
    content_type = lookup(local.mime_types, regex("\\.[^.]+$", "${each.value}"), null)
    acl = "public-read"

}

resource "aws_s3_object" "css" {
    bucket = aws_s3_bucket.static_bucket.id
    for_each = fileset("../css/", "*")
    key = "css/${each.value}"
    source = "../css/${each.value}"
    acl = "public-read"
    content_type = lookup(local.mime_types, regex("\\.[^.]+$", "${each.value}"), null)
}

resource "aws_s3_object" "vendor" {
    bucket = aws_s3_bucket.static_bucket.id
    for_each = fileset("../vendor/", "**")
    key = "vendor/${each.value}"
    source = "../vendor/${each.value}"
    content_type = lookup(local.mime_types, regex("\\.[^.]+$", "${each.value}"), null)
    acl = "public-read"
}

resource "aws_s3_bucket_website_configuration" "website_hosting" {
    bucket =  aws_s3_bucket.static_bucket.id
    
    index_document {
      suffix = "index.html"
    }

    error_document {
      key = "index.html"
    }
}
