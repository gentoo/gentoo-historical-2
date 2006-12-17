# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/glib-java/glib-java-0.2.6-r1.ebuild,v 1.1 2006/12/17 13:18:50 betelgeuse Exp $

inherit java-gnome

DESCRIPTION="Java bindings for glib"

SLOT="0.2"
KEYWORDS="~amd64 ~ppc ~x86"

DEPS=">=dev-libs/glib-2.8.1"
DEPEND="${DEPS}"
RDEPEND="${DEPS}"
