# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/uim/uim-0.1.7.ebuild,v 1.3 2004/01/06 08:41:36 usata Exp $

IUSE="gtk nls debug"

DESCRIPTION="UIM is a simple, secure and flexible input method library"
HOMEPAGE="http://anthy.sourceforge.jp/"
SRC_URI="http://freedesktop.org/Software/uim/${P}.tar.gz"

LICENSE="GPL-2 | BSD"
SLOT="0"
KEYWORDS="x86 alpha"

S="${WORKDIR}/${P}"

DEPEND="${RDEPEND}
	>=sys-apps/sed-4"
RDEPEND="gtk? ( >=x11-libs/gtk+-2 )"

# for debugging use
use debug && RESTRICT="nostrip"

src_compile() {

	if [ -n "`use gtk`" ] ; then
		sed -i -e "s:@GTK2_TRUE@::g" -e "s:@GTK2_FALSE@:#:g" \
			Makefile.in `echo */Makefile.in`
	else
		sed -i -e "s:@GTK2_TRUE@:#:g" -e "s:@GTK2_FALSE@::g" \
			Makefile.in `echo */Makefile.in`
		sed -i -e "/^SUBDIRS/s/gtk//" Makefile.in
	fi

	use debug && export CFLAGS="${CFLAGS} -g"
	econf `use_enable nls` || die
	emake || die
}

src_install () {

	einstall || die

	dodoc ABOUT-NLS AUTHORS ChangeLog INSTALL* NEWS README*
}

pkg_postinst() {

	local GTK_IMMODULES=/etc/gtk-2.0/gtk.immodules

	if [ -f ${GTK_IMMODULES} ] ; then
		gtk-query-immodules-2.0 > ${GTK_IMMODULES}
	fi
}

pkg_postrm() {

	local GTK_IMMODULES=/etc/gtk-2.0/gtk.immodules

	if [ -f ${GTK_IMMODULES} ] ; then
		gtk-query-immodules-2.0 > ${GTK_IMMODULES}
	fi
}
