# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome2-user-docs/gnome2-user-docs-2.4.0.ebuild,v 1.10 2004/07/01 19:47:28 eradicator Exp $

inherit gnome2

DESCRIPTION="end user documentation for Gnome2"
HOMEPAGE="http://www.gnome.org"

LICENSE="FDL-1.1"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha amd64 ia64"

DEPEND="virtual/libc
	>=app-text/scrollkeeper-0.3.11"

S=${WORKDIR}/${P}
