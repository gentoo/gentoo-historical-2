# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/vdkbuilder/vdkbuilder-2.0.3.ebuild,v 1.11 2004/06/25 02:49:55 agriffis Exp $
#	sdl? ( media-libs/vdksdl )
# if we figure out xdb... there's a --enable-xdb and vdkxdb

inherit eutils

IUSE="nls gnome"

S="${WORKDIR}/${P/vdkbuilder/vdkbuilder2}"
DESCRIPTION="The Visual Development Kit used for VDK Builder."
HOMEPAGE="http://vdkbuilder.sf.net"
SRC_URI="mirror://sourceforge/vdkbuilder/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND="dev-libs/vdk
	gnome? ( gnome-base/libgnome )"

src_compile() {

	local myconf

	# Allows vdkbuilder to compile on gcc3 systems.
	epatch ${FILESDIR}/vdkbuilder-gcc3.patch || die "Patch Failed"

	use gnome \
		&& myconf="${myconf} --enable-gnome=yes" \
		|| myconf="${myconf} --enable-gnome=no"

	econf \
		`use_enable nls` \
		${myconf} || die "econf failed"
	emake || die
}

src_install () {
	einstall || die
	dodoc AUTHORS BUGS ChangeLog COPYING INSTALL NEWS README TODO
}
