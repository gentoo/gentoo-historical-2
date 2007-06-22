# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/ace/ace-5.5.8.ebuild,v 1.2 2007/06/22 22:37:59 dragonheart Exp $

S="${WORKDIR}/ACE_wrappers"
DESCRIPTION="The Adaptive Communications Environment"
SRC_URI="!tao? (
			http://download.dre.vanderbilt.edu/previous_versions/ACE-${PV}.tar.bz2 )
		tao? ( !ciao? (
				http://download.dre.vanderbilt.edu/previous_versions/ACE+TAO-${PV}.tar.bz2 )
			ciao? (
				http://download.dre.vanderbilt.edu/previous_versions/ACE+TAO+CIAO-${PV}.tar.bz2
				)
		 )"

HOMEPAGE="http://www.cs.wustl.edu/~schmidt/ACE.html"

SLOT="0"
LICENSE="BSD as-is"
KEYWORDS="~x86 ~sparc ~ppc ~alpha ~amd64"
IUSE="X ipv6 tao ciao"

COMMON_DEPEND="dev-libs/openssl"
# TODO probably more
RDEPEND="${COMMON_DEPEND}
	X? ( || (
	( x11-libs/libXt
	x11-libs/libXaw )
	virtual/x11 )
	)"

DEPEND="${COMMON_DEPEND}
	X? ( || (
	( x11-proto/xproto )
	virtual/x11 )
	)"

src_compile() {
	export ACE_ROOT="${S}"
	mkdir build
	cd build
	ECONF_SOURCE="${S}"
	econf --enable-lib-all $(use_with X) $(use_enable ipv6) || \
		die "econf died"
	# --with-qos needs ACE_HAS_RAPI
	emake static_libs=1 || die
}


src_test() {
	cd "${S}"/build
	make ACE_ROOT=${S} check || die "self test failed"
}

src_install() {
	cd build
	make ACE_ROOT="${S}" DESTDIR="${D}" install || die "failed to install"
	insinto /usr/include/ace
	doins "${S}"/ace/OS.inl
	doins "${S}"/ace/Select_Reactor.h
	# punt gperf stuff
	rm -rf "${D}"/usr/bin "${D}"/usr/share
}


pkg_postinst() {
	# This is required, as anything trying to compile against ACE will have
	# problems with conflicting OS.h files if this is not done.

	local CC_MACHINE=`gcc -dumpmachine`
	local CC_VERSION=`gcc -dumpversion`
	if [ -d "/usr/lib/gcc-lib/${CC_MACHINE}/${CC_VERSION}/include/ace" ]; then
		mv "/usr/lib/gcc-lib/${CC_MACHINE}/${CC_VERSION}/include/ace" \
			"/usr/lib/gcc-lib/${CC_MACHINE}/${CC_VERSION}/include/ace.old"
	fi
}
