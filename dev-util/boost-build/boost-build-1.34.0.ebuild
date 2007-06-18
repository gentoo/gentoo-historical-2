# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/boost-build/boost-build-1.34.0.ebuild,v 1.6 2007/06/18 11:15:15 armin76 Exp $

inherit flag-o-matic toolchain-funcs versionator

KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc64 ~sparc ~x86"

MY_PV=$(replace_all_version_separators _)

DESCRIPTION="A system for large project software construction, which is simple to use and powerfull."
HOMEPAGE="http://www.boost.org/tools/build/v2/index.html"
SRC_URI="mirror://sourceforge/boost/boost_${MY_PV}.tar.bz2"
LICENSE="Boost-1.0"
SLOT="0"
IUSE=""

DEPEND="!<dev-libs/boost-1.34.0"
RDEPEND=""

S=${WORKDIR}/boost_${MY_PV}/tools

src_unpack() {
	unpack ${A}

	# Remove stripping option
	cd "${S}/jam/src"
	sed -i \
		-e 's/-s\b//' \
		build.jam || die "sed failed"

	# This patch allows us to fully control optimization
	# and stripping flags when bjam is used as build-system
	# We simply extend the optimization and debug-symbols feature
	# with empty dummies called 'none'
	cd "${S}/build/v2"
	sed -i \
		-e 's/\(feature optimization : off speed space\)/\1 none/' \
		-e 's/\(feature debug-symbols : on off\)/\1 none/' \
		tools/builtin.jam || die "sed failed"
}

src_compile() {

	cd jam/src
	local toolset

	if [ "${ARCH}" == "ppc-macos" ] ; then
		toolset=darwin
	else
		# Using boost's generic toolset here, which respects CC and CFLAGS
		toolset=cc
	fi

	append-flags -fno-strict-aliasing

	CC=$(tc-getCC) ./build.sh ${toolset} || die "building bjam failed"
}

src_install() {
	dobin jam/src/bin.*/bjam

	cd "${S}/build/v2"
	insinto /usr/share/boost-build
	doins -r boost-build.jam bootstrap.jam build-system.jam site-config.jam user-config.jam \
		build kernel options tools util
}
