# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/beast/beast-0.7.1-r1.ebuild,v 1.1 2008/06/01 21:21:47 eva Exp $

inherit autotools eutils flag-o-matic fdo-mime

IUSE="debug mad static"

DESCRIPTION="BEAST - the Bedevilled Sound Engine"
HOMEPAGE="http://beast.gtk.org"
SRC_URI="ftp://beast.gtk.org/pub/beast/v${PV%.[0-9]}/${P}.tar.bz2
	mirror://gentoo/${P}-guile-1.8.diff.bz2"

LICENSE="GPL-2 LGPL-2.1"
KEYWORDS="~amd64 ~ppc ~x86"
SLOT="0"

RDEPEND=">=dev-libs/glib-2.0
	>=x11-libs/gtk+-2.4.11
	>=sys-libs/zlib-1.1.3
	dev-scheme/guile
	>=media-libs/libart_lgpl-2.3.8
	>=gnome-base/libgnomecanvas-2.0
	>=media-libs/libogg-1.0
	>=media-libs/libvorbis-1.0
	mad? ( media-sound/madplay )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-lang/perl
	media-libs/ladspa-cmt
	media-libs/ladspa-sdk
	>=dev-util/intltool-0.35"

pkg_setup() {
	if has_version =dev-scheme/guile-1.8*; then
		local flags="deprecated"
		built_with_use dev-scheme/guile ${flags} \
		|| die "guile must be built with \"${flags}\" use flags"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${WORKDIR}/${P}-guile-1.8.diff"
	epatch "${FILESDIR}/${P}-noinstalltest.patch"
	epatch "${FILESDIR}/${P}-signalheader.patch"

	# Remove G_DISABLE_DEPRECATED, bug #223291
	epatch "${FILESDIR}/${P}-glib.patch"

	epatch "${FILESDIR}/${P}-configure.patch"

	eautoreconf
	intltoolize --force || die "intltoolize failed"
}

src_compile() {
	# avoid suid related security issues.
	append-ldflags $(bindnow-flags)

	#for some weird reasons there is no doxer in this release
	econf $(use_enable debug) \
		$(use_enable static) \
		|| die "configure failed"
	emake || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	# dont install new mime files !
	for i in subclasses XMLnamespaces aliases globs magic mime.cache\
		audio/x-bsewave.xml audio/x-bse.xml; do
		rm -f "${D}/usr/share/mime/${i}"
	done

	dodoc AUTHORS ChangeLog NEWS README TODO
}

pkg_postinst() {
	fdo-mime_mime_database_update
}
