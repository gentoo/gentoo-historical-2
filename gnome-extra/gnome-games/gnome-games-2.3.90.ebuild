# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-games/gnome-games-2.3.90.ebuild,v 1.1 2003/09/07 22:07:15 foser Exp $

inherit gnome2 

DESCRIPTION="Collection of games for the GNOME desktop"
HOMEPAGE="http://www.gnome.org/"

IUSE=""
SLOT="0"
KEYWORDS="~x86 ~ppc ~alpha ~sparc ~hppa ~amd64"
LICENSE="GPL-2"

RDEPEND=">=app-text/scrollkeeper-0.3.8
	>=gnome-base/gconf-1.2
	>=gnome-base/gnome-vfs-2
	>=gnome-base/libgnome-2
	>=gnome-base/libgnomeui-2"

DEPEND=">=dev-util/pkgconfig-0.12.0
	>=dev-util/intltool-0.22
	>=sys-devel/gettext-0.10.40
	${RDEPEND}"

# FIXME

#src_install() {
#	export GCONF_DISABLE_MAKEFILE_SCHEMA_INSTALL="1"
#		einstall || die "install failure"
#	unset GCONF_DISABLE_MAKEFILE_SCHEMA_INSTALL
#
#dodoc AUTHORS COPYING COPYING-DOCS ChangeLog HACKING INSTALL MAINTAINERS NEWS README TODO
#
#	docinto aisleriot
#	cd aisleriot
#	dodoc AUTHORS ChangeLog TODO
	
#	cd ../freecell
#	docinto freecell
#	dodoc AUTHORS ChangeLog NEWS README TODO

#	cd ../gataxx
#	docinto gataxx
#	dodoc AUTHORS ChangeLog TODO
	
#	cd ../glines
#	docinto glines
#	dodoc AUTHORS ChangeLog NEWS README TODO

#	cd ../gnect
#	docinto gnect
#	dodoc AUTHORS ChangeLog TODO

#	cd ../gnibbles
#	docinto gnibbles
#	dodoc  AUTHORS ChangeLog

#	cd ../gnobots2
#	docinto gnobots2
#	dodoc  AUTHORS README
	
#	cd ../gnome-stones
#	docinto gnome-stones
#	dodoc  ChangeLog README TODO
	
#	cd ../gnometris
#	docinto gnometris
#	dodoc AUTHORS COPYING  ChangeLog TODO

#	cd ../gnomine
#	docinto gnomine 	
#	dodoc AUTHORS ChangeLog README
	
#	cd ../gnotravex
#	docinto gnotravex
#	dodoc AUTHORS  ChangeLog README

#	cd ../gnotski
#	docinto gnotski
#	dodoc AUTHORS ChangeLog README

#	cd ../gtali
#	docinto gtali
#	dodoc AUTHORS ChangeLog INSTALL README TODO

#	cd ../iagno
#	docinto iagno
#	dodoc  AUTHORS ChangeLog

#	cd ../mahjongg
#	docinto mahjongg
#	dodoc ChangeLog NEWS README TODO

#	cd ../same-gnome
#	docinto same-gnome
#	dodoc ChangeLog README TODO

#	cd ../xbill
#	docinto xbill
#	dodoc AUTHORS COPYING ChangeLog NEWS README README.Ports

#	cd ..
#	export SCROLLKEEPER_UPDATE="1"
#}
