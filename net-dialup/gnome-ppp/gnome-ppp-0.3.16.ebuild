# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/gnome-ppp/gnome-ppp-0.3.16.ebuild,v 1.1 2004/10/07 12:46:51 pclouds Exp $

inherit gnome2 eutils

DESCRIPTION="A GNOME 2 WvDial frontend"
HOMEPAGE="http://www.gnome-ppp.org/"
LICENSE="GPL-2"

MP=${PV%.[0-9]*}
SRC_URI="http://www.gnome-ppp.org/download/${MP}/${P}.tar.gz"

SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=net-dialup/wvdial-1.53-r1
	>=gnome-base/libgnomeui-2.6
	>=gnome-base/libglade-2.4
	>=x11-libs/gtk+-2.4"

DEPEND="sys-devel/gettext
	dev-util/pkgconfig
	${RDEPEND}"

USE_DESTDIR="1"
