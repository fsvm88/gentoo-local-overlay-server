# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )
inherit distutils-r1

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://github.com/uskudnik/amazon-glacier-cmd-interface.git"
	inherit autotools git-r3
else
	SRC_URI="https://github.com/uskudnik/amazon-glacier-cmd-interface.git"
fi

DESCRIPTION="Glacier cmd interface based on AWS CLI"
HOMEPAGE="https://github.com/uskudnik/amazon-glacier-cmd-interface"

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND="
	dev-python/awscli[${PYTHON_USEDEP}]
	dev-python/botocore[${PYTHON_USEDEP}]
	dev-python/prettytable[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	"
