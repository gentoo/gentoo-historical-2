# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/readline/readline-4.3-r4.ebuild,v 1.23 2004/09/08 15:17:46 vapier Exp $

inherit eutils gnuconfig

# Official patches
PLEVEL="x001 x002"

DESCRIPTION="Another cute console display library"
HOMEPAGE="http://cnswww.cns.cwru.edu/php/chet/readline/rltop.html"
SRC_URI="mirror://gnu/readline/${P}.tar.gz
	${PLEVEL//x/mirror://gnu/${PN}/${PN}-${PV}-patches/${PN}${PV/\.}-}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc mips alpha hppa amd64 ia64"
IUSE=""

# We must be certain that we have a bash that is linked
# to its internal readline, else we may get problems.
DEPEND=">=app-shells/bash-2.05b-r2
	>=sys-libs/ncurses-5.2-r2"

src_unpack() {
	unpack ${P}.tar.gz

	cd ${S}
	for x in ${PLEVEL//x}
	do
		epatch ${DISTDIR}/${PN}${PV/\.}-${x}
	done

	# Fix segfaults in Python when using latin-1 chars in interactive mode
	# (bug #11762).
	epatch ${FILESDIR}/readline4.3-mbutil.patch

	gnuconfig_update
}

src_compile() {

	econf --with-curses || die

	emake || die
	cd shlib
	emake || die
}


src_install() {

	make prefix=${D}/usr mandir=${D}/usr/share/man \
		infodir=${D}/usr/share/info install || die
	cd ${S}/shlib
	make prefix=${D}/usr mandir=${D}/usr/share/man \
		infodir=${D}/usr/share/info install || die

	cd ${S}

	dodir /lib
	mv ${D}/usr/lib/*.so* ${D}/lib
	rm -f ${D}/lib/*.old
	# bug #4411
	gen_usr_ldscript libreadline.so
	gen_usr_ldscript libhistory.so
	# end bug #4411
	dosym libhistory.so.${PV/a/} /lib/libhistory.so
	dosym libreadline.so.${PV/a/} /lib/libreadline.so
	# Needed because make install uses ${D} for the link
	dosym libhistory.so.${PV/a/} /lib/libhistory.so.4
	dosym libreadline.so.${PV/a/} /lib/libreadline.so.4
	chmod 755 ${D}/lib/*.${PV/a/}

	dodoc CHANGELOG CHANGES COPYING MANIFEST README USAGE
	docinto ps
	dodoc doc/*.ps
	dohtml -r doc

	# Backwards compatibility #29865
	if [ -e ${ROOT}/lib/libreadline.so.4.1 ] ; then
		cp -a ${ROOT}/lib/libreadline.so.4.1 ${D}/lib/
		touch ${D}/lib/libreadline.so.4.1
	fi
}

pkg_postinst() {
	if [ -e ${ROOT}/lib/libreadline.so.4.1 ] ; then
		ewarn "Your old readline libraries have been copied over."
		ewarn "You should run 'revdep-rebuild --soname libreadline.so.4.1' asap."
		ewarn "Once you have, you can safely delete /lib/libreadline.so.4.1"
	fi
}
