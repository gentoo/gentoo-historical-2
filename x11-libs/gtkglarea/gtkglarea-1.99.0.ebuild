# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/gtkglarea/gtkglarea-1.99.0.ebuild,v 1.23 2004/11/08 19:31:15 vapier Exp $

inherit gnome2 gnuconfig

DESCRIPTION="GL extensions for gtk+"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 LGPL-2.1"
SLOT="2"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 sparc x86"
IUSE=""

DEPEND="virtual/libc
	>=x11-libs/gtk+-2.0.3
	virtual/glu
	virtual/opengl"

src_compile() {
	gnuconfig_update
	econf || die
	emake || die

}

DOCS="AUTHORS ChangeLog INSTALL NEWS README* docs/*.txt"
