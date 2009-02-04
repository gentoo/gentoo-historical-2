# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/verve/verve-0.3.6.ebuild,v 1.7 2009/02/04 21:16:41 armin76 Exp $

# Christoph Mende <angelos@gentoo.org>
# Move this package to xfce4-verve as soon as 0.3.6 is stable
MY_PN="xfce4-${PN}-plugin"
inherit xfce44

xfce44

DESCRIPTION="Command line panel plugin"

KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="dbus debug"

RDEPEND=">=xfce-extra/exo-0.3.2
	dev-libs/libpcre
	dbus? ( dev-libs/dbus-glib )"
DEPEND="${RDEPEND}
	dev-util/intltool"

xfce44_goodies_panel_plugin
