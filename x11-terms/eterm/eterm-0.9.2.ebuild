# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/eterm/eterm-0.9.2.ebuild,v 1.2 2002/11/03 18:38:34 vapier Exp $

MY_PN=${PN/et/Et}
MY_P=${MY_PN}-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="A vt102 terminal emulator for X"
SRC_URI="http://www.eterm.org/download/${MY_P}.tar.gz
	 http://www.eterm.org/download/${MY_PN}-bg-${PV}.tar.gz"
HOMEPAGE="http://www.eterm.org/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~alpha"

DEPEND="virtual/x11
	>=x11-libs/libast-0.4-r1
	media-libs/imlib2"

src_unpack() {
	unpack ${MY_P}.tar.gz
	cd ${S}
	unpack ${MY_PN}-bg-${PV}.tar.gz
}

src_compile() {
	
	# always disable mmx because binutils 2.11.92+ seems to be broken for this package
	local myconf="--disable-mmx"

	econf \
		--with-imlib \
		--enable-trans \
		--with-x \
		--enable-multi-charset \
		--with-delete=execute \
		${myconf} || die
		
	emake || die

}

src_install () {

	cd ${S}
	dodir /usr/share/terminfo
	make \
		DESTDIR=${D} \
		TIC="tic -o ${D}/usr/share/terminfo" \
		install || die

	dodoc COPYING ChangeLog README ReleaseNotes
	dodoc bg/README.backgrounds
	cd ${D}/usr/share/Eterm/themes
	unpack glass-Eterm-theme.tar.gz
}
