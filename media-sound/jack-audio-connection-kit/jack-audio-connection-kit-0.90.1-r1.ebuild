# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/jack-audio-connection-kit/jack-audio-connection-kit-0.90.1-r1.ebuild,v 1.6 2004/03/27 02:32:17 eradicator Exp $

inherit flag-o-matic eutils

IUSE="doc debug jack-tmpfs caps"

DESCRIPTION="A low-latency audio server"
HOMEPAGE="http://jackit.sourceforge.net/"
SRC_URI="mirror://sourceforge/jackit/${P}.tar.gz"
RESTRICT="nomirror"

SLOT="0"
LICENSE="GPL-2 LGPL-2.1"
KEYWORDS="~x86 ~ppc"

DEPEND=">=media-libs/alsa-lib-0.9.1
	>=media-libs/libsndfile-1.0.0
	dev-libs/glib
	dev-util/pkgconfig
	sys-libs/ncurses
	caps? ( sys-libs/libcap )
	doc? ( app-doc/doxygen )
	sys-devel/autoconf
	!media-sound/jack-cvs"

PROVIDE="virtual/jack"

src_unpack() {
	if use jack-caps; then
		eerror "The jack-caps USE flag has been changed to caps.  Please update your environment."
		exit 1
	fi

	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PN}-doc-option.patch || \
		die "Documentation configure option patch failed"
	autoconf || die "Couldn't regenerate configure file, failing"
}

src_compile() {
	local myconf
	local myarch


	myarch=`get-flag -march`

	cd $S
	sed -i "s/^CFLAGS=\$JACK_CFLAGS/CFLAGS=\"\$JACK_CFLAGS $myarch\"/" configure
	use doc \
		&& myconf="--with-html-dir=/usr/share/doc/${PF}" \
		|| myconf="--without-html-dir"

	use jack-tmpfs && myconf="${myconf} --with-default-tmpdir=/dev/shm"
	use caps && myconf="${myconf} --enable-capabilities --enable-stripped-jackd"
	use debug && myconf="${myconf} --enable-debug"

	myconf="${myconf} --enable-optimize --with-gnu-ld"

	econf ${myconf} || die "configure failed"
	emake || die "compilation failed"
}

src_install() {


	make DESTDIR=${D} \
		datadir=${D}/usr/share \
		install || die
	if use doc; then
		mv ${D}/usr/share/doc/${PF}/reference/html \
		   ${D}/usr/share/doc/${PF}/ &&
		rmdir ${D}/usr/share/doc/${PF}/reference
	fi
}
