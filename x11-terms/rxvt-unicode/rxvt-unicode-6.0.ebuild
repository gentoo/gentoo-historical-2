# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/rxvt-unicode/rxvt-unicode-6.0.ebuild,v 1.1 2005/12/24 21:02:48 ciaranm Exp $

inherit flag-o-matic

DESCRIPTION="rxvt clone with XFT and Unicode support"
HOMEPAGE="http://software.schmorp.de/"
SRC_URI="http://dist.schmorp.de/rxvt-unicode/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc-macos ~ppc64 ~sparc ~x86"
IUSE="xgetdefault tabs"

RDEPEND="virtual/x11
	dev-lang/perl
	tabs? ( dev-perl/gtk2-perl )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/libtool"

pkg_setup() {
	filter-flags -mno-accumulate-outgoing-args
	replace-flags -Os -O2
}

src_unpack() {
	unpack ${A}
	cd ${S}
	local tdir=/usr/share/terminfo
	sed -i -e \
		"s~@TIC@ \(etc/rxvt\)~@TIC@ -o ${D}/${tdir} \1~" \
		doc/Makefile.in
	sed -i -e \
		"s:-g -O3:${CFLAGS}:" \
		configure
}

src_compile() {
	econf \
		--enable-everything \
		--enable-rxvt-scroll \
		--enable-next-scroll \
		--enable-xterm-scroll \
		--enable-transparency \
		--enable-xpm-background \
		--enable-fading \
		--enable-utmp \
		--enable-wtmp \
		--enable-mousewheel \
		--enable-slipwheeling \
		--enable-smart-resize \
		--enable-ttygid \
		--enable-256-color \
		--enable-24bit \
		--enable-xim \
		--enable-shared \
		--enable-keepscrolling \
		--enable-xft \
		`use_enable xgetdefault` \
		--disable-text-blink \
		--disable-iso14755 \
		--disable-menubar || die

	emake || die

	if useq tabs ; then
		sed -i \
			-e 's/RXVT_BASENAME = "rxvt"/RXVT_BASENAME = "urxvt"/' \
			${S}/doc/rxvt-tabbed || die "tabs sed failed"
	fi
}

src_install() {
	make DESTDIR=${D} install || die

	dodoc README.FAQ Changes
	cd ${S}/doc
	dodoc README* changes.txt etc/*

	if useq tabs ; then
		newbin rxvt-tabbed urxvt-tabbed
	fi
}

pkg_postinst() {
	einfo "urxvt now always uses TERM=rxvt-unicode so that the"
	einfo "upstream-supplied terminfo files can be used."
}
