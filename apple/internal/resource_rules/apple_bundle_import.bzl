# Copyright 2019 The Bazel Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""Implementation of apple_bundle_import rule."""

load(
    "@bazel_skylib//lib:partial.bzl",
    "partial",
)
load(
    "@build_bazel_rules_apple//apple/internal:providers.bzl",
    "new_appleresourcebundleinfo",
)
load(
    "@build_bazel_rules_apple//apple/internal:resources.bzl",
    "resources",
)

visibility("//apple/...")

def _apple_bundle_import_impl(ctx):
    """Implementation of the apple_bundle_import rule."""
    parent_dir_param = partial.make(
        resources.bundle_relative_parent_dir,
        extension = "bundle",
    )
    resource_provider = resources.bucketize_typed(
        bucket_type = "unprocessed",
        expect_files = True,
        parent_dir_param = parent_dir_param,
        resources = ctx.files.bundle_imports,
    )
    return [
        new_appleresourcebundleinfo(),
        resource_provider,
    ]

apple_bundle_import = rule(
    implementation = _apple_bundle_import_impl,
    attrs = {
        "bundle_imports": attr.label_list(
            allow_empty = False,
            allow_files = True,
            mandatory = True,
            doc = """
The list of files under a .bundle directory to be propagated to the top-level bundling target.
""",
        ),
    },
    doc = """
This rule encapsulates an already-built bundle. It is defined by a list of files in a .bundle
directory. apple_bundle_import targets need to be added to library targets through the data
attribute, or to other resource targets (i.e. apple_resource_bundle) through the resources
attribute.
""",
)
