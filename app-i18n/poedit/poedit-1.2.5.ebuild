# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/poedit/poedit-1.2.5.ebuild,v 1.11 2005/01/25 14:54:08 greg_g Exp $

inherit eutils kde wxwidgets

IUSE="gtk2 unicode"
DESCRIPTION="Cross-platform gettext catalogs (.po files) editor."
SRC_URI="mirror://sourceforge/poedit/${P}.tar.gz
	mirror://gentoo/${P}-db4-compilation.patch"
HOMEPAGE="http://poedit.sourceforge.net/"

SLOT="0"
LICENSE="as-is"
KEYWORDS="~x86 ~sparc"

DEPEND="<x11-libs/wxGTK-2.5
	app-arch/zip
	>=sys-libs/db-3"

src_unpack() {
	unpack ${A} || die "Failed to unpack ${A}"
	cd ${S} || die "Failed to cd ${S}"
	epatch ${DISTDIR}/${P}-db4-compilation.patch
}

pkg_setup() {
	if use unicode && ! use gtk2; then
		die "You must put gtk2 in your USE if you want unicode."
	fi
}

src_compile() {
	if use unicode ; then
		need-wxwidgets unicode || die "You need to emerge wxGTK with unicode in your USE"
	elif ! use gtk2 ; then
		need-wxwidgets gtk || die "You need to emerge wxGTK with gtk in your USE"
	else
		need-wxwidgets gtk2 || die "You need to emerge wxGTK with gtk2 in your USE"
	fi
	#Maybe WX_CONFIG_NAME should be added to wxwidgets.eclass
	export WX_CONFIG_NAME=${WX_CONFIG}
	econf || die
	emake || die
}

src_install () {
	make DESTDIR=${D} install \
		datadir=/usr/share \
		GNOME_DATA_DIR=/usr/share \
		KDE_DATA_DIR=/usr/share || die

	dodoc AUTHORS LICENSE NEWS README TODO
}
