# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/fidelio/fidelio-0.9.6-r2.ebuild,v 1.3 2002/10/05 05:39:24 drobbins Exp $

IUSE="nls esd"

S=${WORKDIR}/${P}
DESCRIPTION="Fidelio is a Linux/Unix client for Hotline, a proprietary protocol that combines ftp-like, irc-like and news-like functions with user authentication and permissions in one package."
SRC_URI="http://download.sourceforge.net/fidelio/${P}.tar.gz"
HOMEPAGE="http://fidelio.sourceforge.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND="=x11-libs/gtk+-1.2*
	>=gnome-base/gnome-libs-1.4.1.2
	>=dev-libs/libxml2-2.4.12
	esd? ( >=media-sound/esound-0.2.23 )"

src_compile() {
	
	CFLAGS="${CFLAGS} -I/usr/include/libxml2/libxml"
	CXXFLAGS="${CXXFLAGS} -I/usr/include/libxml2/libxml"
	export CPPFLAGS="-I/usr/include/libxml2"
	export XML_CONFIG="/usr/bin/xml2-config"

	local myconf

	use nls || myconf="${myconf} --disable-nls"
	
	econf ${myconf} || die
	emake || die

}

src_install () {

	einstall || die
	
	dodoc AUTHORS ChangeLog NEWS README TODO
}
