# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/x11-wm/blackbox/blackbox-0.65.0_alpha8.ebuild,v 1.3 2002/07/11 06:31:00 drobbins Exp $

#Needed to change ${P} to match actual tarball version name.
#It is an invalid ebuild name. Much simpler this way.

MY_P=${P/_/}

S=${WORKDIR}/${MY_P}
DESCRIPTION="A small, fast, full-featured window manager for X"
SRC_URI="http://prdownloads.sf.net/blackboxwm/${MY_P}.tar.gz"
LICENSE="as-is"
SLOT="0"
KEYWORDS="x86"

# Old homepage:
# HOMEPAGE="http://blackbox.alug.org/"

HOMEPAGE="http://blackboxwm.sf.net/"

DEPEND="virtual/x11"

RDEPEND="${DEPEND}
	nls? ( sys-devel/gettext )"

PROVIDE="virtual/blackbox"

src_compile() {
	local myconf
	use nls || myconf="${myconf} --disable-nls"

	./configure \
		--build=${CHOST} \
		--prefix=/usr \
		--sysconfdir=/etc/X11/blackbox \
		${myconf} || die "configure failure"

	emake || die "emake failure" 
}

src_install () {
	make prefix=${D}/usr \
		sysconfdir=${D}/etc/X11/blackbox \
		install || die "install failure"

	dodoc ChangeLog* AUTHORS LICENSE README* TODO*
	exeinto /etc/X11/Sessions
	doexe $FILESDIR/blackbox
}

