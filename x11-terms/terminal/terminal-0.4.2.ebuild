# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/terminal/terminal-0.4.2.ebuild,v 1.6 2009/10/24 19:57:20 nixnut Exp $

EAPI=2
EAUTORECONF=yes
MY_P=${P/t/T}
inherit xfconf

DESCRIPTION="Terminal for Xfce desktop environment, based on vte library."
HOMEPAGE="http://www.xfce.org/projects/terminal"
SRC_URI="mirror://xfce/src/apps/${PN}/0.4/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ppc ~ppc64 ~sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~x64-solaris"
IUSE="dbus debug doc"

RDEPEND=">=dev-libs/glib-2.16:2
	>=x11-libs/gtk+-2.14:2
	x11-libs/libX11
	>=x11-libs/vte-0.17.1
	>=xfce-base/exo-0.3.4
	dbus? ( >=dev-libs/dbus-glib-0.31 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/intltool
	sys-devel/gettext
	doc? ( dev-libs/libxslt )"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	PATCHES=( "${FILESDIR}"/${PN}-0.4.0-interix-fs-case.patch )
	XFCONF="--disable-dependency-tracking
		$(use_enable dbus)
		$(use_enable debug)
		$(use_enable doc xsltproc)"
	DOCS="AUTHORS ChangeLog HACKING NEWS README THANKS"
}
