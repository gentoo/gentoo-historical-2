# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-mailwatch/xfce4-mailwatch-1.0.1.ebuild,v 1.13 2007/03/10 18:03:57 nixnut Exp $

inherit xfce44

xfce44
xfce44_plugin

DESCRIPTION="Mail notification panel plugin"
HOMEPAGE="http://spuriousinterrupt.org/projects/mailwatch"
SRC_URI="http://spuriousinterrupt.org/files/mailwatch/${MY_P}.tar.bz2"
KEYWORDS="amd64 hppa ppc ~ppc64 sparc x86 ~x86-fbsd"
IUSE="ssl"

RDEPEND="ssl? ( >=net-libs/gnutls-1.2 )"
DEPEND="dev-util/intltool"

XFCE_CONFIG="${XFCE_CONFIG} $(use_enable ssl)"

xfce44_panel_plugin
