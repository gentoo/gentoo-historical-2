# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libsafe/libsafe-2.0_p16.ebuild,v 1.1 2004/03/02 17:03:10 matsuu Exp $

MY_P="${P/_p/-}"
DESCRIPTION="Protection against buffer overflow vulnerabilities"
HOMEPAGE="http://www.research.avayalabs.com/project/libsafe/index.html"
SRC_URI="http://www.research.avayalabs.com/project/libsafe/src/${MY_P}.tgz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE="prelude"

DEPEND="virtual/glibc
	prelude? ( dev-libs/libprelude )"

S=${WORKDIR}/${MY_P}

src_compile() {
	local mycflags=""

	mycflags="${mycflags} ${CFLAGS}"
	mycflags="${mycflags} -DLIBSAFE_VERSION=\"\$(VERSION)\""
	use prelude && mycflags="${mycflags} \$(LIBPRELUDE_CFLAGS)"

	# Note email notification currently not implimented in this ebuild
	# due to I cannot work out if a mta is on localhost:25 for it.
	# It safer not too assume it is. Uncomment the following if desired
	# use mta && mycflags="${mycflags} -DNOTIFY_WITH_EMAIL"

	emake CC="${CC}" CFLAGS="${mycflags}" || die
}

src_install() {

	# libsafe stuff
	into /
	dolib.so src/libsafe.so.${PV/_p/.} || die
	# dodir /lib
	dosym libsafe.so.${PV/_p/.} /lib/libsafe.so || die
	dosym libsafe.so.${PV/_p/.} /lib/libsafe.so.${PV%%.*} || die

	# Documentation
	doman doc/libsafe.8
	dohtml doc/libsafe.8.html

	dodoc COPYING README INSTALL
	use prelude && dodoc LIBPRELUDE
	# use mta && dodoc EMAIL_NOTIFICATION
}

pkg_postinst() {
	einfo
	einfo "To use this you have to put the library as one of the variables"
	einfo "in LD_PRELOAD."
	einfo "Example in bash:"
	einfo "export LD_PRELOAD=/lib/libsafe.so.${PV%%.*}"
	einfo
}
