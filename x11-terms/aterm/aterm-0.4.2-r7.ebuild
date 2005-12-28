# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/aterm/aterm-0.4.2-r7.ebuild,v 1.18 2005/12/28 22:26:12 grobian Exp $

inherit eutils flag-o-matic

DESCRIPTION="A terminal emulator with transparency support as well as rxvt backwards compatibility"
HOMEPAGE="http://aterm.sourceforge.net"
SRC_URI="mirror://sourceforge/aterm/${P}.tar.bz2
	cjk? ( http://dev.gentoo.org/~spock/portage/distfiles/aterm-0.4.2-ja.patch )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 mips ppc ~sparc x86"
IUSE="cjk"

DEPEND="media-libs/jpeg
	media-libs/libpng
	virtual/x11"

src_unpack() {
	unpack ${P}.tar.bz2
	cd ${S}/src
	cp feature.h feature.h.orig
	sed "s:\(#define LINUX_KEYS\):/\*\1\*/:" \
		feature.h.orig > feature.h

	cd ${S}
	epatch ${FILESDIR}/aterm-0.4.2-borderless.patch
	epatch ${FILESDIR}/aterm-0.4.2-paste.patch
	epatch ${FILESDIR}/aterm-0.4.2-paste_mouse_outside.patch

	if use cjk ; then
		epatch ${DISTDIR}/aterm-0.4.2-ja.patch
	else
		epatch ${FILESDIR}/aterm-0.4.2-copynpaste.patch
	fi
}

src_compile() {
	local myconf

	append-ldflags $(bindnow-flags)

	# You can't --enable-big5 with aterm-0.4.2-ja.patch
	# I think it's very bad thing but as nobody complains it
	# and we don't have per-language flag atm, I stick to
	# use --enable-kanji/--enable-thai (and leave --enable-big5)
	use cjk && myconf="$myconf
		--enable-kanji
		--enable-thai
		--enable-xim
		--enable-linespace"

	econf \
		--enable-transparency \
		--enable-fading \
		--enable-background-image \
		--enable-menubar \
		--enable-graphics \
		--enable-utmp \
		--with-x \
		${myconf} || die

	sed -i -re 's#^XLIB = (.*)#XLIB = \1 -lXmu#' src/Makefile
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die

	fowners root:utmp /usr/bin/aterm
	fperms g+s /usr/bin/aterm

	doman doc/aterm.1
	dodoc ChangeLog INSTALL doc/BUGS doc/FAQ doc/README.*
	docinto menu
	dodoc doc/menu/*
	dohtml -r .
}
