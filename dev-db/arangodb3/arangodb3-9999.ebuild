# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6
CMAKE_BUILD_TYPE=Release
PYTHON_COMPAT=( python2_7 )

inherit eutils user vcs-snapshot systemd python-any-r1 cmake-utils flag-o-matic git-r3

DESCRIPTION="The multi-purpose multi-model NoSQL DB"
HOMEPAGE="http://www.arangodb.org/"

EGIT_REPO_URI="https://github.com/arangodb/arangodb"
#GITHUB_USER="arangodb"
#GITHUB_TAG="v${PV}"
PN=arangodb

#SRC_URI="https://github.com/${GITHUB_USER}/${PN}/archive/${GITHUB_TAG}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"
IUSE="+asm +backtrace +libssh2 -openssl +optimize-for-arch"

DEPEND=">=sys-libs/readline-6.2_p1
  libssh2? ( >=net-libs/libssh2-1.7.0 )
  openssl? ( >=dev-libs/openssl-1.0.0[-bindist] )
  ${PYTHON_DEPEND}"
RDEPEND="${DEPEND}"

pkg_setup() {
  python-any-r1_pkg_setup
  ebegin "Ensuring arangodb3 user and group exist"
  enewgroup arangodb3
  enewuser arangodb3 -1 -1 -1 arangodb3
  eend $?
}

src_prepare() {
  cmake-utils_src_prepare

  sed -i 's?@PKGDATADIR@?/usr/share/arangodb3?' etc/arangodb3/arangod.conf.in || die 'sed arangod.conf failed'
  sed -i 's?@PKGDATADIR@?/usr/share/arangodb3?' etc/arangodb3/arangosh.conf.in || die 'sed arangosh.conf failed'
}

src_configure() {

  local mycmakeargs=(
    -DVERBOSE=On
	-DAMD64=$(usex asm)
	-DUSE_OPTIMIZE_FOR_ARCHITECTURE=$(usex optimize-for-arch)
    -DCMAKE_BUILD_TYPE=Debug
	-DCMAKE_USE_LIBSSH2=$(usex libssh2)
	-DCMAKE_USE_OPENSSL=$(usex openssl)
	-DBASE_C_FLAGS="${CFLAGS} -g3"
	-DBASE_CXX_FLAGS="${CXXFLAGS} -g3"
	-DBASE_LD_FLAGS="${LDFLAGS}"
	-DUSE_BACKTRACE=$(usex backtrace)
    -DETCDIR=/etc
    -DVARDIR=/var
    -DCMAKE_INSTALL_PREFIX:PATH=/usr
    -DCMAKE_SKIP_RPATH:BOOL=ON
  )
  cmake-utils_src_configure
}

src_install() {
  cmake-utils_src_install

  newinitd "${FILESDIR}"/arangodb3.initd arangodb

  systemd_dounit "${FILESDIR}"/arangodb3.service
}
