# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/im-ja/im-ja-1.4.ebuild,v 1.3 2005/05/23 16:00:20 gustavoz Exp $

inherit gnome2 eutils

DESCRIPTION="A Japanese input module for GTK2 and XIM"
HOMEPAGE="http://im-ja.sourceforge.net/"
SRC_URI="http://im-ja.sourceforge.net/${P}.tar.gz
	http://im-ja.sourceforge.net/old/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc sparc ~alpha ~amd64"
IUSE="gnome canna freewnn skk anthy"
# --enable-debug causes build failure with gtk+-2.4
#IUSE="${IUSE} debug"

DEPEND="dev-lang/perl
	dev-perl/URI
	>=sys-devel/autoconf-2.50
	>=sys-devel/automake-1.7
	${RDEPEND}"
RDEPEND="virtual/libc
	>=dev-libs/glib-2.4
	>=dev-libs/atk-1.6
	>=x11-libs/gtk+-2.4
	>=x11-libs/pango-1.2.1
	>=gnome-base/gconf-2.4
	>=gnome-base/libglade-2.4
	gnome? ( >=gnome-base/gnome-panel-2.0 )
	freewnn? ( app-i18n/freewnn )
	canna? ( app-i18n/canna )
	skk? ( virtual/skkserv )
	anthy? ( || ( app-i18n/anthy app-i18n/anthy-ss ) )"

DOCS="AUTHORS README ChangeLog TODO"

get_gtk_confdir() {
	if useq amd64 || ( [ "${CONF_LIBDIR}" == "lib32" ] && useq x86 ) ; then
		echo "/etc/gtk-2.0/${CHOST}"
	else
		echo "/etc/gtk-2.0"
	fi
}

src_compile() {
	local myconf
	# You cannot use `use_enable ...` here. im-ja's configure script
	# doesn't distinguish --enable-canna from --disable-canna, so
	# --enable-canna stands for --disable-canna in the script ;-(
	use gnome || myconf="$myconf --disable-gnome"
	use canna || myconf="$myconf --disable-canna"
	use freewnn || myconf="$myconf --disable-wnn"
	use anthy || myconf="$myconf --disable-anthy"
	use skk || myconf="$myconf --disable-skk"
	#use debug && myconf="$myconf --enable-debug"

	# gnome2_src_compile automatically sets debug IUSE flag
	econf $myconf || die "econf im-ja failed"
	emake || die "emake im-ja failed"
}

pkg_postinst() {
	if [ -x /usr/bin/gtk-query-immodules-2.0 ] ; then
		gtk-query-immodules-2.0 > ${ROOT}/$(get_gtk_confdir)/gtk.immodules
	fi
	gnome2_pkg_postinst
	einfo
	einfo "This version of im-ja comes with experimental XIM support."
	einfo "If you'd like to try it out, run im-ja-xim-server and set"
	einfo "environment variable XMODIFIERS to @im=im-ja-xim-server"
	einfo "e.g.)"
	einfo "\t$ export XMODIFIERS=@im=im-ja-xim-server (sh)"
	einfo "\t> setenv XMODIFIERS @im=im-ja-xim-server (csh)"
	einfo
}

pkg_postrm() {
	if [ -x /usr/bin/gtk-query-immodules-2.0 ] ; then
		gtk-query-immodules-2.0 > ${ROOT}/$(get_gtk_confdir)/gtk.immodules
	fi
	gnome2_pkg_postrm
}
