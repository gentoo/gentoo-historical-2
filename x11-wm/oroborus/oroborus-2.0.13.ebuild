# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/oroborus/oroborus-2.0.13.ebuild,v 1.12 2005/05/08 14:44:51 herbs Exp $

DESCRIPTION="Small and fast window manager."
HOMEPAGE="http://www.oroborus.org/"
SRC_URI="http://www.oroborus.org/debian/dists/sid/main/source/x11/${P/-/_}-1.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ppc amd64 sparc"
IUSE="gnome"

DEPEND="virtual/x11"

src_compile() {
	aclocal
	autoheader
	automake --add-missing
	autoconf
	./configure --host=${CHOST} \
		    --prefix=/usr \
		    --sysconfdir=/etc/X11/oroborus \
	 	    --infodir=/usr/share/info \
		    --mandir=/usr/share/man \
		    || die
	emake || die
}

src_install () {
	make prefix=${D}/usr \
	     sysconfdir=${D}/etc/X11/oroborus \
	     infodir=${D}/usr/share/info \
	     mandir=${D}/usr/share/man \
	     install || die

	if use gnome ; then
		insinto /usr/share/gnome/wm-properties
		doins ${FILESDIR}/oroborus.desktop
	fi

	dodoc README INSTALL ChangeLog TODO AUTHORS example.oroborusrc
}
