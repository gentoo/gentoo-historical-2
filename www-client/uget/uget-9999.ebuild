# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/uget/uget-9999.ebuild,v 1.2 2010/01/08 15:31:21 wired Exp $

EAPI="2"

inherit autotools subversion

DESCRIPTION="Download manager using gtk+ and libcurl"
HOMEPAGE="http://urlget.sourceforge.net/"
SRC_URI=""

ESVN_REPO_URI="https://urlget.svn.sourceforge.net/svnroot/urlget/trunk"
ESVN_PROJECT="uget"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="gstreamer libnotify nls"

RDEPEND="
	dev-libs/libpcre
	>=dev-libs/glib-2
	>=net-misc/curl-7.10
	>=x11-libs/gtk+-2.4
	gstreamer? ( media-libs/gstreamer )
	libnotify? ( x11-libs/libnotify )
	"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/gettext"

src_prepare() {
	for i in AUTHORS NEWS README ChangeLog;	do
		[[ ! -f ${i} ]] && touch ${i}
	done

	eautoreconf
	intltoolize || die "intltoolize failed"
	eautoreconf
}

src_configure() {
	econf $(use_enable nls) \
		  $(use_enable gstreamer) \
		  $(use_enable libnotify notify) || die "econf failed"
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog NEWS README || die "dodoc failed"
}
