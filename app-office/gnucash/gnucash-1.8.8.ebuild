# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/gnucash/gnucash-1.8.8.ebuild,v 1.11 2005/01/01 15:33:17 eradicator Exp $

inherit flag-o-matic libtool

# won't configure with this
filter-flags -fomit-frame-pointer
# gnucash uses GLIB_INLINE, this will break it
filter-flags -fno-inline

DOC_VER="1.8.4"
IUSE="nls postgres ofx hbci"

DESCRIPTION="A personal finance manager"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	mirror://sourceforge/${PN}/${PN}-docs-${DOC_VER}.tar.gz"
HOMEPAGE="http://www.gnucash.org/"

KEYWORDS="x86 alpha ppc ~sparc"
SLOT="0"
LICENSE="GPL-2"

RDEPEND=">=gnome-base/gnome-libs-1.4.1.2-r1
	>=dev-util/guile-1.6
	>=dev-libs/slib-2.3.8
	>=media-libs/libpng-1.0.9
	>=media-libs/jpeg-6b
	>=sys-libs/zlib-1.1.4
	>=gnome-base/gnome-print-0.21
	media-libs/gdk-pixbuf
	>=gnome-extra/gtkhtml-0.14.0
	<gnome-extra/gal-1.99
	>=dev-libs/libxml-1.8.3
	>=dev-libs/g-wrap-1.3.3
	>=gnome-extra/guppi-0.35.5-r2
	>=dev-libs/popt-1.5
	>=app-text/scrollkeeper-0.3.1
	app-text/docbook-xsl-stylesheets
	=app-text/docbook-xml-dtd-4.1.2*
	=sys-libs/db-1*
	hbci? ( >=net-libs/openhbci-0.9.13 )
	ofx? ( >=dev-libs/libofx-0.6.4 )
	postgres? ( dev-db/postgresql )"

DEPEND="${RDEPEND}
	>=dev-lang/perl-5
	>=dev-libs/slib-2.3.8
	>=dev-lang/swig-1.3_alpha4
	<gnome-base/libglade-2
	gnome-base/libghttp
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )"

MAKEOPTS="${MAKEOPTS} -j1"


pkg_setup() {
	if built_with_use xorg-x11 bitmap-fonts
	then
		einfo "bitmap-fonts support is enabled in xorg-x11, continuing..."
	else
		eerror "Please rebuild xorg-x11 with bitmap font support!"
		eerror "To do so: USE=\"bitmap-fonts\" emerge xorg-x11"
		eerror "Or, add \"bitmap-fonts\" to your USE string in"
		eerror "/etc/make.conf"
		die "Will not build gnucash without bitmap-fonts support in xorg-x11"
	fi
}

src_compile() {
	elibtoolize
	local myconf=""

	# allow warnings to go unheeded
	myconf="--enable-compile-warnings=no --disable-error-on-warning"

	use postgres && myconf="${myconf} --enable-sql"

	econf \
		`use_enable nls` \
		`use_enable ofx` \
		`use_enable hbci` \
		${myconf} || die "configure failed"

	emake || die "make failed"

	cd ${WORKDIR}/${PN}-docs-${DOC_VER}
	econf --localstatedir=/var/lib || die "doc configure failed"
	emake || die "doc make failed"
}

src_install() {
	einstall pkgdatadir=${D}/usr/share/gnucash || die "install failed"
	dodoc ABOUT-NLS AUTHORS ChangeLog HACKING NEWS README* TODO
	dodoc docs/README*

	cd ${WORKDIR}/${PN}-docs-${DOC_VER}
	make DESTDIR=${D} \
		scrollkeeper_localstate_dir=${D}/var/lib/scrollkeeper \
		install || die "doc install failed"
	rm -rf ${D}/var/lib/scrollkeeper
}

pkg_postinst() {
	if [ -x ${ROOT}/usr/bin/scrollkeeper-update ]; then
		echo ">>> Updating Scrollkeeper"
		scrollkeeper-update -q -p ${ROOT}/var/lib/scrollkeeper
	fi
}

pkg_postrm() {
	if [ -x ${ROOT}/usr/bin/scrollkeeper-update ]; then
		echo ">>> Updating Scrollkeeper"
		scrollkeeper-update -q -p ${ROOT}/var/lib/scrollkeeper
	fi
}
