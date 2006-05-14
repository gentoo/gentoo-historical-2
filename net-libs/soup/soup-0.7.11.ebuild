# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/soup/soup-0.7.11.ebuild,v 1.13 2006/05/14 14:18:04 tcort Exp $

inherit gnome.org libtool eutils

DESCRIPTION="Soup is a SOAP implementation"
HOMEPAGE="http://www.gnome.org/"

DEPEND=">=dev-util/pkgconfig-0.12.0
	=dev-libs/glib-1.2*
	dev-libs/libxml
	dev-libs/popt
	ssl? ( dev-libs/openssl )
	doc? ( >=dev-util/gtk-doc-0.9-r2 )"

IUSE="ssl doc"

LICENSE="|| ( GPL-2 LGPL-2 )"
SLOT="0"
KEYWORDS="alpha hppa ppc sparc x86"

src_unpack() {

	unpack ${A}

	cd ${S}
	# fix gcc bailing (#68047)
	epatch ${FILESDIR}/${P}-gcc3.patch

}

src_compile() {
	elibtoolize

	local myconf=""
	use ssl \
		&&  myconf="--enable-ssl" \
		||  myconf="--disable-ssl"

	use doc \
		&& myconf="${myconf} --enable-gtk-doc" \
		|| myconf="${myconf} --disable-gtk-doc"

	# disable apache support. too much trouble than
	# it is worth. it only works with apache1.
	export ac_cv_path_APXS=no
	econf \
		${myconf} \
		--with-libxml=1 || die
	# Evolution 1.1 and 1.2 need it with libxml1
	unset ac_cv_path_APXS

	# dont always work with -j4 -- <azarah@gentoo.org> 9 Nov 2002
	make || die
}

src_install() {
	einstall || die

	dodoc AUTHORS ABOUT-NLS COPYING* ChangeLog README* INSTALL NEWS TODO
}
