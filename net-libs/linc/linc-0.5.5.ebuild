# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/linc/linc-0.5.5.ebuild,v 1.2 2002/12/01 18:29:10 foser Exp $

IUSE="doc ssl"


inherit libtool gnome.org

S=${WORKDIR}/${P}
DESCRIPTION="A library to ease the writing of networked applications"
HOMEPAGE="http://www.gnome.org/"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="x86 ~ppc ~sparc ~sparc64 ~alpha"

RDEPEND=">=dev-libs/glib-2.0.6
	ssl? ( >=dev-libs/openssl-0.9.6 )"

DEPEND="${RDEPEND}
	doc? ( >=dev-util/gtk-doc-0.9-r2 )
	>=dev-util/pkgconfig-0.12.0"
	  
src_compile() {
	elibtoolize
	local myconf
	use doc \
		&& myconf="${myconf} --enable-gtk-doc" \
		|| myconf="${myconf} --disable-gtk-doc"

	# if this is disabled (use) ORBit2 will fail to build. Just force it on	
	
	use ssl \
		&& myconf="${myconf} --with-openssl" \
		|| myconf="${myconf} --without-openssl"

	econf ${myconf} || die
	emake || die
}

src_install() {
	einstall || die
    
 	dodoc AUTHORS ChangeLog COPYING HACKING MAINTAINERS README* NEWS TODO
}
