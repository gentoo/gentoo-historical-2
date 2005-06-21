# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/gtk-doc/gtk-doc-1.1.ebuild,v 1.22 2005/06/21 09:54:16 leonardop Exp $

inherit gnome.org

DESCRIPTION="GTK+ Documentation Generator"
HOMEPAGE="http://www.gtk.org/gtk-doc/"
IUSE="debug"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ia64 amd64 x86 ppc sparc alpha hppa mips ppc64"

RDEPEND=">=app-text/openjade-1.3.1
	=app-text/docbook-xml-dtd-4.1*
	>=app-text/docbook-dsssl-stylesheets-1.40
	>=dev-lang/perl-5.6
	dev-libs/libxslt
	>=dev-libs/libxml2-2.3.6"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0"


src_compile() {
	local myconf
	use debug \
		&& myconf="--enable-debug=yes" \
		|| myconf="--enable-debug=no"

	econf ${myconf} || die
	emake || die
}

src_install() {
	einstall || die

	dodoc AUTHORS ChangeLog COPYING INSTALL README* NEWS
	docinto doc
	dodoc doc/README doc/*.txt
}
