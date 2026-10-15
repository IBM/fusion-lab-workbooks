# IBM Technology Zone Lab Guides

IBM Technology Zone (TechZone) is the single destination for our go-to-market teams and IBM business partners' ecosystem to access on-demand and live environments to learn, build, show, and share the value of IBM solutions. Additionally, they can extend our certified base images and further customize them for test, education, demonstration, and pilot activities.

This collection of lab guides can be used to study and create custom client-facing labs and demonstrations.

## Scope

The purpose of this project is to provide a platform to develop the collection of lab guides.

## Publication access

**IBM Fusion PDF guides**

* Demo guide [PDF](pdf/ibm-fusion-demo-guide.pdf)
* Backup & Restore [PDF](pdf/ibm-fusion-backup-restore-guide.pdf)
* OpenShift Virtualization [PDF](pdf/ibm-fusion-ocp-virt-guide.pdf)
* Hosted Control Plane (HCP) [PDF](pdf/ibm-fusion-hcp-guide.pdf)
* Regional Disaster Recovery (RDR) [PDF](pdf/ibm-fusion-rdr-guide.pdf)
* Fusion Access for SAN [PDF](pdf/ibm-fusion-access-guide.pdf)

**IBM Fusion local desktop HTML (MacOS only)**

You can set up the guides as a local set of HTML pages. You will need to either clone the repository with `git clone ...` or download the ZIP file and unzip it in your preferred work directory.  

Once you have the repository's files on your workstation, change to the guides' base directory, and run the following command:

> You may be prompted to install Antora publisher.

```bash
npx --yes -p @antora/cli -p @antora/site-generator antora ./antora-playbook-local.yml
```

Navigate to the `./build/site` directory, if you don't see any build errors, and double click the `index.html` file to open the local site. If you don't see the `./build` directory the click `SHIFT - CMD - .` (Shift + Command + Period keys) to show hidden directories.

## Usage

This repository contains our guidelines:

* [LICENSE](LICENSE)
* [README.md](README.md)
* [CONTRIBUTING.md](CONTRIBUTING.md)
* [author-guide.adoc](modules/ROOT/pages/author-guide.adoc)
* [MAINTAINERS.md](MAINTAINERS.md)
* [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)
<!-- A Changelog allows you to track major changes and things that happen, https://github.com/github-changelog-generator/github-changelog-generator can help automate the process 
* [CHANGELOG.md](CHANGELOG.md)
-->

## Notes

If you have any questions or issues you can create a new [issue here](https://github.com/IBM/fusion-lab-workbooks/issues).

Pull requests are very welcome! Make sure your material submissions are well tested.
Create a topic branch for every separate change you make. For example:

1. Fork the repo
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
