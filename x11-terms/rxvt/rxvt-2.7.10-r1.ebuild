# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/rxvt/rxvt-2.7.10-r1.ebuild,v 1.3 2004/12/09 19:10:03 gustavoz Exp $

inherit eutils flag-o-matic

DESCRIPTION="rxvt -- nice small x11 terminal"
HOMEPAGE="http://www.rxvt.org/"
SRC_URI="mirror://sourceforge/rxvt/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc alpha sparc ~mips amd64 ~ppc64"
IUSE="motif cjk xgetdefault"

DEPEND="virtual/libc
	virtual/x11
	motif? ( x11-libs/openmotif )"

src_unpack() {
	unpack ${A}
	cd ${S}

	use motif && epatch ${FILESDIR}/${P}-azz4.diff
	use cjk && epatch ${FILESDIR}/${P}-rk.patch
}

src_compile() {

	local term
	if [ -n "${RXVT_TERM}" ] ; then
		term="${RXVT_TERM}"
	else
		term="rxvt"
	fi

	# bug #22325
	append-flags -DLINUX_KEYS
	append-ldflags -Wl,-z,now

	econf \
		--enable-everything \
		--enable-rxvt-scroll \
		--enable-next-scroll \
		--enable-xterm-scroll \
		--enable-transparency \
		--enable-xpm-background \
		--enable-utmp \
		--enable-wtmp \
		--enable-mousewheel \
		--enable-slipwheeling \
		--enable-smart-resize \
		--enable-256-color \
		--enable-menubar \
		--enable-languages \
		--enable-xim \
		--enable-shared \
		--enable-keepscrolling \
		--with-term=${term} \
		$(use_enable xgetdefault) || die

	emake || die
}

src_install() {

	einstall mandir=${D}/usr/share/man/man1 || die

	cd ${S}/doc
	dodoc README* *.txt BUGS FAQ
	dohtml *.html
}

pkg_postinst() {

	einfo
	einfo "If you want to change default TERM variable other than rxvt,"
	einfo "set RXVT_TERM environment variable and then emerge rxvt."
	einfo "Especially, if you use rxvt under monochrome X you might need to run"
	einfo "\t RXVT_TERM=rxvt-basic emerge rxvt"
	einfo "otherwise curses based program will not work."
	einfo
}
