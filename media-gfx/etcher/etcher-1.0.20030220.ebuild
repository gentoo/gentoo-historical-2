# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/etcher/etcher-1.0.20030220.ebuild,v 1.1 2003/02/20 12:37:35 vapier Exp $

DESCRIPTION="graphical editing tool for creating and manipulating Ebits GUI elements"
HOMEPAGE="http://www.enlightenment.org/pages/etcher.html"
SRC_URI="mirror://gentoo/${P}.tar.bz2
	http://wh0rd.tk/gentoo/distfiles/${P}.tar.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"

DEPEND="virtual/glibc
	sys-devel/gcc
	=x11-libs/gtk+-1*
	>=media-libs/imlib2-1.0.6.2003*
	>=x11-libs/evas-1.0.0.2003*
	>=dev-db/edb-1.0.3.2003*"

S=${WORKDIR}/${PN}

pkg_setup() {
	# the stupid gettextize script prevents non-interactive mode, so we hax it
	cp `which gettextize` ${T} || die "could not copy gettextize"
	cp ${T}/gettextize ${T}/gettextize.old
	sed -e 's:read dummy < /dev/tty::' ${T}/gettextize.old > ${T}/gettextize
}

src_compile() {
	cp Makefile.am{,.old}
	sed -e 's:intl::' \
		-e 's:po::' \
		Makefile.am.old > Makefile.am
	cp configure.in configure.in.old
	sed -e 's:intl/Makefile::' \
		-e 's:po/Makefile.in::' \
		-e 's:m4/Makefile::' \
		configure.in.old > configure.in

	env PATH="${T}:${PATH}" WANT_AUTOCONF_2_5=1 NOCONFIGURE=yes ./autogen.sh || die
	econf --disable-nls --with-gnu-ld || die
	emake || die
}

src_install() {
	make install DESTDIR=${D} || die
	find ${D} -name CVS -type d -exec rm -rf '{}' \;
	dodoc AUTHORS ChangeLog NEWS README
}
