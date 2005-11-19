# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/gentoo/gentoo-0.11.55.ebuild,v 1.9 2005/11/19 13:40:51 killerfox Exp $

DESCRIPTION="A modern GTK+ based filemanager for any WM"
HOMEPAGE="http://www.obsession.se/gentoo/"
SRC_URI="mirror://sourceforge/gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE="nls gnome fam"

DEPEND="=x11-libs/gtk+-1.2*"
RDEPEND="nls? ( sys-devel/gettext )
	fam? ( virtual/fam )"

src_compile() {
	econf \
		--sysconfdir=/etc/gentoo \
		$(use_enable fam) \
		$(use_enable nls) || die

	emake || die
}

src_install() {
	cp mkinstalldirs ${WORKDIR}
	make DESTDIR=${D} install || die

	if use gnome ; then
		insinto /usr/share/pixmaps
		doins icons/gentoo.png
		insinto /usr/share/gnome/apps/Applications
		doins ${FILESDIR}/gentoo.desktop
	fi

	dodoc AUTHORS BUGS CONFIG-CHANGES CREDITS ChangeLog \
		NEWS ONEWS README* TODO
	dodoc docs/FAQ docs/menus.txt

	dohtml docs/*.{html,css}
	dohtml -r docs/images
	dohtml -r docs/config

	newan docs/gentoo.1x gentoo.1

	docinto scratch
	dodoc docs/scratch/*
}
