# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/im-ja/im-ja-0.6.ebuild,v 1.1 2003/07/07 17:29:48 nakano Exp $

DESCRIPTION="A Japanese input module for GTK2"
HOMEPAGE="http://im-ja.sourceforge.net/"
SRC_URI="${HOMEPAGE}${P}.tar.gz
	${HOMEPAGE}old/${P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="~x86 ~sparc"
SLOT=0
IUSE="canna freewnn"

DEPEND="virtual/glibc
		>=dev-libs/glib-2.2.1
		>=dev-libs/atk-1.2.2
		>=x11-libs/gtk+-2.2.1
		>=x11-libs/pango-1.2.1
		>=gnome-base/gconf-2.2
		freewnn? ( app-i18n/freewnn )
		canna? ( app-i18n/canna )"

src_unpack() {
	unpack ${A}
	cd ${S}/data
	# work around
	sed -e "s|\(GCONF_CONFIG_SOURCE=\)\$(GCONF_CONFIG_SOURCE)|\1\$(GCONF_SCHEMA_CONFIG_SOURCE)|" < Makefile.in > Makefile.in.tmp
	cp Makefile.in.tmp Makefile.in
}

src_compile() {
	local gconfdir="`gconftool-2 --get-default-source | sed -e \"s|^xml::/|$D|\"`"
	local myconf="--with-gconf-source=xml::${gconfdir}"
	use canna || myconf="$myconf --disable-canna"
	use freewnn || myconf="$myconf --disable-wnn"
	econf $myconf
	emake || die "make failed"
}

src_install () {
	local gconfdir="`gconftool-2 --get-default-source | sed -e \"s|^xml::/|$D|\"`"
	einstall
	# /etc/gconf should be world readable
	find ${gconfdir} -type d | xargs chmod -R +rx
	find ${gconfdir} -type f | xargs chmod -R +r
	dodoc AUTHORS COPYING README ChangeLog
}

pkg_postinst(){
	gtk-query-immodules-2.0 > ${ROOT}/etc/gtk-2.0/gtk.immodules
}

pkg_postrm(){
	gtk-query-immodules-2.0 > ${ROOT}/etc/gtk-2.0/gtk.immodules
}
