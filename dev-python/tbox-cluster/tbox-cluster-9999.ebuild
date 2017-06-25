# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
PYTHON_COMPAT=( python{2_7,3_4,3_5})

inherit distutils-r1 git-2

DESCRIPTION="Tinderbox cluster project"
HOMEPAGE="https://gitweb.gentoo.org/proj/tinderbox-cluster.git/"
SRC_URI=""
LICENSE="GPL-2"
KEYWORDS="~amd64"
SLOT="0"
IUSE="+mysql"

RDEPEND="sys-apps/portage
	dev-python/sqlalchemy
	dev-python/git-python
	mysql? ( dev-python/mysql-connector-python )"

DEPEND="${RDEPEND}
	dev-python/setuptools"

EGIT_REPO_URI="git://anongit.gentoo.org/proj/tinderbox-cluster.git"

python_prepare_all() {
	einfo "Copying needed files from portage"
	cp /usr/lib64/python2.7/site-packages/_emerge/actions.py ${S}/pym/tbc/
	cp /usr/lib64/python2.7/site-packages/_emerge/main.py ${S}/pym/tbc/
	cp /usr/lib64/python2.7/site-packages/_emerge/Scheduler.py ${S}/pym/tbc/
	cp /usr/lib64/python2.7/site-packages/repoman/main.py ${S}/pym/tbc/repoman.py

	einfo "Done."


	epatch "${S}/patches/portage.patch"


	distutils-r1_python_prepare_all
}

src_install() {
	dodir etc/tbc
	insinto /etc/tbc
	doins ${FILESDIR}/tbc.conf
	dosbin ${S}/bin/tbc_host_jobs
	dosbin  ${S}/bin/tbc_guest_jobs
	#dodoc ${S}/zobcs/sql/zobcs.sql || die
	#dodoc  ${S}/zobcs/doc/Setup.txt || die

	distutils-r1_src_install
}	
