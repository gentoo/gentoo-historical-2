# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/gob/gob-2.0.5.ebuild,v 1.5 2004/06/25 02:34:57 agriffis Exp $

MY_P=${PN}2-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="preprocessor for making GTK+ objects with inline C code"
SRC_URI="http://ftp.5z.com/pub/gob/${MY_P}.tar.gz"
HOMEPAGE="http://www.5z.com/jirka/gob.html"

SLOT="2"
LICENSE="GPL-2"
KEYWORDS="x86 ~sparc"

RDEPEND=">=dev-libs/glib-2.0*
	dev-libs/popt"
DEPEND="${RDEPEND}
	sys-devel/flex"

src_compile() {
	econf || die "configure fail"
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS COPYING.generated-code ChangeLog NEWS README TODO
}
