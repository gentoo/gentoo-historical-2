# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/gfax/gfax-0.6.4.ebuild,v 1.3 2005/02/27 07:06:43 genstef Exp $

inherit eutils mono

DESCRIPTION="Gfax is a free fax front end"
HOMEPAGE="http://gfax.cowlug.org/"
SRC_URI="http://gfax.cowlug.org/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND=">=dev-dotnet/mono-0.93
		>=dev-dotnet/gtk-sharp-1.0.4-r1
		dev-dotnet/gnome-sharp
		dev-dotnet/gconf-sharp
		dev-dotnet/glade-sharp"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/gfax.Makefile.fix
}

src_install() {
	dodir /usr/bin/ /usr/share/pixmaps/ /usr/share/applications/
	make DESTDIR="${D}" install || die "make install failed"
	insinto /usr/share/gfax/data
	doins data/gfax.schema

	local i
	for i in /usr/share/libgnomeprint/*
	do
		insinto ${i}/printers
		doins ${D}/usr/share/gfax/GFAX.xml
		insinto ${i}/models
		doins ${D}/usr/share/gfax/GNOME-GFAX-PS.xml
	done

	keepdir /var/spool/gfax
}

pkg_postinst() {
	einfo "Please run"
	echo 'env GCONF_CONFIG_SOURCE="" gconftool-2 --makefile-install-rule /usr/share/gfax/data/gfax.schema'
	einfo "as your local user, to get gfax working"
}
