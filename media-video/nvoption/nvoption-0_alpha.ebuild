# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/nvoption/nvoption-0_alpha.ebuild,v 1.1 2002/10/30 08:07:07 vapier Exp $

MY_P="${P/-0/}"
DESCRIPTION="grapich front-end to change NVIDIA options in X mode"
HOMEPAGE="http://www.sorgonet.com/linux/nvoption/"
SRC_URI="http://www.sorgonet.com/linux/nvoption/${MY_P}.tar.gz"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~x86"
IUSE="nls"

DEPEND="gnome-base/gnome-libs
	gnome-base/ORBit
	=x11-libs/gtk+-1.2*"
RDEPEND="nls? ( sys-devel/gettext )"
S="${WORKDIR}/${PN}"

src_compile() {
	local myconf="--with-gnome"
	use nls \
		&& myconf="${myconf} --disable-nls" \
		|| myconf="${myconf} --enable-nls"
	rm -rf config.cache
	econf ${myconf}

	cp Makefile Makefile.old
	sed -e 's:intl po macros src:src:' Makefile.old > Makefile
	emake || die "make failed"
}

src_install() {
	einstall
	dodoc AUTHORS ChangeLog NEWS README
}
