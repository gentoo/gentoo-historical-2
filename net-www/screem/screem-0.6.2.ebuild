# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/screem/screem-0.6.2.ebuild,v 1.8 2004/02/17 00:45:29 mr_bones_ Exp $

IUSE="ssl zlib"

S=${WORKDIR}/${P}
DESCRIPTION="SCREEM (Site CReating and Editing EnvironmenMent) is an
integrated environment of the creation and maintenance of websites and
pages"
SRC_URI="http://ftp1.sourceforge.net/screem/${P}.tar.gz"
HOMEPAGE="http://www.screem.org"
KEYWORDS="x86 ~sparc ppc "
SLOT="0"
LICENSE="GPL-2"

RDEPEND=">=gnome-base/libgnome-2.0.2
	>=gnome-base/libgnomeui-2.0.2
	>=dev-libs/libxml2-2.4.3
	>=gnome-base/libglade-1.99.2
	>=gnome-base/gconf-1.2.1
	>=gnome-base/gnome-vfs-2.0
	>=x11-libs/gtk+-2.0
	>=dev-libs/glib-2.0
	>=gnome-base/libbonobo-2.0
	>=gnome-base/libbonoboui-2.0
	=gnome-extra/libgtkhtml-2*
	>=gnome-base/libgnomeprint-2.2.0
	>=gnome-base/libgnomeprintui-2.2.0
	app-text/scrollkeeper
	ssl? ( dev-libs/openssl )
	zlib? ( sys-libs/zlib )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_compile() {

	local myconf=""


	use ssl && myconf="$myconf --with-ssl"

	use zlib || myconf="$myconf --without-zlib"

	econf ${myconf} || die "Configuration Failure"

	emake || die "Compilation Failure"
}

src_install () {
	addwrite /var/lib/scrollkeeper/
	make DESTDIR=${D} install

#	einstall || die "Installation Failure"

	dodoc ABOUT-NLS AUTHORS BUGS ChangeLog INSTALL NEWS README TODO

	einfo "If you want to have http and WebDAV support you should"
	einfo "emerge net-misc/neon and remerge screem."
}
