# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/glib-java/glib-java-0.2.6-r1.ebuild,v 1.4 2007/02/28 15:01:44 blubb Exp $

inherit java-gnome

DESCRIPTION="Java bindings for glib"

SLOT="0.2"
KEYWORDS="amd64 ppc x86"

DEPS=">=dev-libs/glib-2.8.1"
DEPEND="${DEPS}"
RDEPEND="${DEPS}"
