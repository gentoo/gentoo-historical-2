# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/esound/esound-0.2.29.ebuild,v 1.12 2003/09/28 12:24:32 foser Exp $

IUSE="tcpd alsa"

inherit libtool gnome.org

S=${WORKDIR}/${P}
DESCRIPTION="The Enlightened Sound Daemon"

HOMEPAGE="http://www.tux.org/~ricdude/EsounD.html"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc ppc alpha hppa amd64"

DEPEND=" >=media-libs/audiofile-0.1.9
	alsa? ( >=media-libs/alsa-lib-0.5.9 )
	tcpd? ( >=sys-apps/tcp-wrappers-7.6-r2 )"

src_compile() {
	elibtoolize

	local myconf=""
	use tcpd && myconf="${myconf} --with-libwrap" \
		|| myconf="${myconf} --without-libwrap"

	use alsa && myconf="${myconf} --enable-alsa" \
		|| myconf="${myconf} --enable-alsa=no"

	econf \
		--sysconfdir=/etc/esd \
		${myconf} || die

	make || die
}

src_install() {
	einstall \
		sysconfdir=${D}/etc/esd \
		|| die

	dodoc AUTHORS COPYING* ChangeLog README TODO NEWS TIPS
	dodoc docs/esound.ps

	dohtml -r docs/html
}
