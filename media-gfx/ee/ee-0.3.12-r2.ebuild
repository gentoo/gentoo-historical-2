# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/ee/ee-0.3.12-r2.ebuild,v 1.7 2002/10/20 19:52:35 carpaski Exp $

IUSE="nls"

S=${WORKDIR}/${P}
DESCRIPTION="ee"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/stable/sources/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.gnome.org/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND="=sys-libs/db-1*
	>=gnome-base/gnome-libs-1.4.1.2-r1"
RDEPEND="nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	cd ${S}
	patch -p1 < ${FILESDIR}/${PN}-mo.diff
}

src_compile() {
	local myconf
	use nls && myconf="--enable-nls" || myconf="--disable-nls" 
	
	econf ${myconf} || die "configure failure" 
	emake || die "make failure"
}

src_install() {
	make DESTDIR=${D} \
	     prefix=/usr \
	     install || die "make install failure"
	dodoc AUTHORS COPYING ChangeLog NEWS README
}
