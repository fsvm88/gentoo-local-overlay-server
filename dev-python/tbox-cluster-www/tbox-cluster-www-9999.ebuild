# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 python3_4 )

inherit distutils-r1 python-utils-r1 prefix git-2

DESCRIPTION="Tinderbox web frontend"
HOMEPAGE="https://gitweb.gentoo.org/proj/tinderbox-cluster.git/"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+mysql"

DEPEND=""
RDEPEND="
	>=dev-python/django-1.6[${PYTHON_USEDEP}]
	mysql? ( || ( dev-python/mysql-python dev-python/mysqlclient ) )
	>=dev-python/twisted-core-10.0[${PYTHON_USEDEP}]
	>=dev-python/django-tagging-0.3.1[${PYTHON_USEDEP}]
	"

EGIT_REPO_URI="git://anongit.gentoo.org/proj/tinderbox-cluster-www.git"

PATCHES=(
	# Do not install the configuration and data files. We install them
	# somewhere sensible by hand.
#	"${FILESDIR}"/${P}-fhs-paths.patch
#	"${FILESDIR}"/${P}-system-libs.patch
)

#EXAMPLES=(
#	examples/example-graphite-vhost.conf
#)

src_prepare() {
	# use FHS-style paths
#	rm setup.cfg || die
	# make sure we don't use bundled stuff
#	rm -Rf webapp/graphite/thirdparty
	distutils-r1_src_prepare
#	eprefixify \
#		conf/graphite.wsgi.example \
#		webapp/graphite/local_settings.py.example
}

python_install() {
	distutils-r1_python_install #\
#		--install-data="${EPREFIX}"/usr/share/${PN}

	# make manage.py available from an easier location/name
#	dodir /usr/bin
#	mv "${D}"/$(python_get_sitedir)/graphite/manage.py \
#		"${ED}"/usr/bin/${PN}-manage || die
#	chmod 0755 "${ED}"/usr/bin/${PN}-manage || die
#	python_fix_shebang "${ED}"/usr/bin/${PN}-manage

#	insinto /etc/${PN}
#	newins webapp/graphite/local_settings.py.example local_settings.py
#	pushd "${D}"/$(python_get_sitedir)/graphite > /dev/null || die
#	ln -s ../../../../../etc/${PN}/local_settings.py local_settings.py
#	popd > /dev/null || die
#	doins conf/dashboard.conf.example
#	doins conf/graphite.wsgi.example
}

#pkg_config() {
#	"${ROOT}"/usr/bin/${PN}-manage syncdb --noinput
#	local idx=$(grep 'INDEX_FILE =' "${EROOT}"/etc/local_settings.py 2>/dev/null)
#	if [[ -n ${idx} ]] ; then
#		idx=${idx##*=}
#		idx=$(echo ${idx})
#		eval "idx=${idx}"
#		touch "${ROOT}"/"${idx}"/index
#	fi
#}

#pkg_postinst() {
#	einfo "Don't forget to edit local_settings.py in ${EPREFIX}/etc/${PN}"
#	einfo "Run emerge --config =${PN}-${PVR} if this is a fresh install."
#}
