# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/oroborus/oroborus-2.0.13.ebuild,v 1.2 2003/09/04 06:12:55 msterret Exp $

DESCRIPTION="Small and fast window manager."
HOMEPAGE="http://www.oroborus.org/oroborus.shtml"
SRC_URI="http://www.oroborus.org/debian/dists/sid/main/source/x11/${P/-/_}-1.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE="gnome"

RDEPEND="virtual/x11"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P}"

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

	if [ "`use gnome`" ] ; then
		insinto /usr/share/gnome/wm-properties
		doins ${FILESDIR}/oroborus.desktop
	fi

	dodoc README INSTALL ChangeLog TODO AUTHORS example.oroborusrc
}
